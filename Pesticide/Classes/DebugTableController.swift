//
//  DebugTableController.swift
//  debugdrawer
//
//  Created by Abraham Hunt on 11/21/14.
//  Copyright (c) 2014 Rocketmade. All rights reserved.
//

import UIKit
import CocoaLumberjack

class SectionInfo: NSObject {
    var rowObjects = Array<RowControl>()
}

class DebugTableController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    var sectionObjects = [SectionInfo()]
    let dropDownPicker = UIPickerView()
    let consoleView = UITextView(frame: CGRect(x: 0, y: 0, width: 320, height: 200))
    var currentField : UITextField?
     let keyboardDoneButtonView = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.darkGray
        dropDownPicker.delegate = self
        dropDownPicker.dataSource = self
        consoleView.isEditable = false
        consoleView.backgroundColor = UIColor.darkGray
        consoleView.textContainerInset = UIEdgeInsetsMake(25, 0, 0, 0)
        consoleView.textColor = UIColor.white
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.interactive
        let cellIds : Array<ControlType> = [.Switch, .Slider, .Button, .TextInput, .Label, .Header]
        for type in cellIds {
            tableView.register(UINib(nibName: type.rawValue, bundle: Bundle(for: DebugTableController.self)), forCellReuseIdentifier:type.rawValue)
        }
        readCurrentLog()
        tableView.tableHeaderView = consoleView

        keyboardDoneButtonView.barStyle = UIBarStyle.default
        keyboardDoneButtonView.isTranslucent = false
        keyboardDoneButtonView.tintColor = nil
        keyboardDoneButtonView.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(DebugTableController.pickerViewDone))
        keyboardDoneButtonView.setItems([doneButton], animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        consoleView.scrollRangeToVisible(NSMakeRange(consoleView.text.characters.count - 1, 1))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return sectionObjects.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        let info = sectionObjects[section]
        return info.rowObjects.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionInfo = sectionObjects[(indexPath as NSIndexPath).section]
        let rowControl = sectionInfo.rowObjects[(indexPath as NSIndexPath).row]

        if rowControl.type == .Header {
            return 30.0
        }

        return 44.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionInfo = sectionObjects[(indexPath as NSIndexPath).section]
        let rowControl = sectionInfo.rowObjects[(indexPath as NSIndexPath).row]
        var identifier = rowControl.type
        if  identifier == .DropDown {
            identifier = .TextInput
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier.rawValue, for: indexPath)
        configureCell(cell, indexPath: indexPath)
        return cell
    }

    // MARK: - Configure Cell

    func configureCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        let sectionInfo = sectionObjects[(indexPath as NSIndexPath).section]
        let rowControl = sectionInfo.rowObjects[(indexPath as NSIndexPath).row]
        guard let pesticideCell = cell as? PesticideCell else {
            return
        }

        pesticideCell.setName(rowControl.name)
        switch rowControl.type {
        case .Switch:
            if let switchCell = cell as? SwitchCell {
                switchCell.switchControl.addTarget(self, action: #selector(DebugTableController.switchChanged(_:)), for: UIControlEvents.valueChanged)
                if let switchControl = rowControl as? SwitchControl {
                    switchCell.switchControl.isOn = switchControl.value
                }
            }
        case .Slider:
            if let sliderCell = cell as? SliderCell {
                sliderCell.slider.addTarget(self, action: #selector(DebugTableController.sliderChanged(_:)), for: UIControlEvents.valueChanged)
                if let sliderControl = rowControl as? SliderControl {
                    sliderCell.slider.value = sliderControl.value
                }
            }
        case .Button:
            if let buttonCell = cell as? ButtonCell {
                buttonCell.button.addTarget(self, action: #selector(DebugTableController.buttonTapped(_:)), for: UIControlEvents.touchUpInside)
            }
        case .DropDown:
            if let dropDown = cell as? TextFieldCell {
                dropDown.textField.addTarget(self, action: #selector(DebugTableController.editingEnded(_:)), for: UIControlEvents.editingDidEnd)
                dropDown.textField.addTarget(self, action: #selector(DebugTableController.editingBegan(_:)), for: UIControlEvents.editingDidBegin)
                dropDown.textField.inputAccessoryView = keyboardDoneButtonView
                dropDown.textField.inputView = dropDownPicker
                dropDown.textField.delegate = self
                dropDown.textField.tintColor = UIColor.clear
                if let dropDownControl = rowControl as? DropDownControl {
                    dropDown.textField.text = dropDownControl.value
                }
            }
        case .TextInput:
            if let textInput = cell as? TextFieldCell {
                textInput.textField.addTarget(self, action: #selector(DebugTableController.editingEnded(_:)), for: UIControlEvents.editingDidEnd)
                textInput.textField.inputView = nil
                if let textInputControl = rowControl as? TextInputControl {
                    textInput.textField.text = textInputControl.value
                }
            }
        case .Label:
            if let labelCell = cell as? LabelCell {
                if let labelControl = rowControl as? LabelControl {
                    labelCell.label.text = labelControl.label
                }
            }
        case .Header:
            break
        }
    }

    func readCurrentLog() {
        logInfo("Read log")
        let fileLogger = DDFileLogger()
        let logFileInfo = fileLogger?.currentLogFileInfo
        if let filePath = logFileInfo?.filePath, let logString = try? String(contentsOfFile: filePath, encoding: String.Encoding.utf8){
            consoleView.text = logString as? String
        }
        let consoleLogger = PesticideLogger()
        consoleLogger.textView = consoleView
        DDLog.add(consoleLogger)
        logInfo("added log watcher")
    }

    func addRowControl(_ rowControl : RowControl) {
        sectionObjects[0].rowObjects.append(rowControl)
        tableView.reloadData()
    }

    // MARK: - Actions

    func switchChanged(_ sender: UISwitch) {
        if let indexPath = indexPathForCellSubview(sender) {
            let sectionInfo = sectionObjects[(indexPath as NSIndexPath).section]
            if let control = sectionInfo.rowObjects[(indexPath as NSIndexPath).row] as? SwitchControl {
                control.executeBlock(sender.isOn)
            }
        }
    }

    func sliderChanged(_ sender: UISlider) {
        if let indexPath = indexPathForCellSubview(sender) {
            let sectionInfo = sectionObjects[(indexPath as NSIndexPath).section]
            if let control = sectionInfo.rowObjects[(indexPath as NSIndexPath).row] as? SliderControl {
                control.executeBlock(sender.value)
            }
        }
    }

    func buttonTapped(_ sender: UIButton) {
        if let indexPath = indexPathForCellSubview(sender) {
            let sectionInfo = sectionObjects[(indexPath as NSIndexPath).section]
            if let control = sectionInfo.rowObjects[(indexPath as NSIndexPath).row] as? ButtonControl {
                control.executeBlock()
            }
        }
    }

    func editingBegan(_ sender: UITextField) {
        currentField = sender
    }

    func editingEnded(_ sender: UITextField) {
        if let indexPath = indexPathForCellSubview(sender) {
            let sectionInfo = sectionObjects[(indexPath as NSIndexPath).section]
            if let control = sectionInfo.rowObjects[(indexPath as NSIndexPath).row] as? TextInputControl {
                control.executeBlock(sender.text ?? "")
                return
            } else if let control = sectionInfo.rowObjects[(indexPath as NSIndexPath).row] as? DropDownControl {
                control.executeBlock(sender.text ?? "")
            }
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }

    func indexPathForCellSubview(_ subview: UIView) -> IndexPath? {
        let aPoint = tableView.convert(CGPoint.zero, from: subview)
        return tableView.indexPathForRow(at: aPoint)
    }

    func controlForCellSubview(_ cellView : UIView) -> RowControl? {
        if let indexPath = indexPathForCellSubview(cellView) {
            let sectionInfo = sectionObjects[(indexPath as NSIndexPath).section]
            return sectionInfo.rowObjects[(indexPath as NSIndexPath).row]
        }
        return nil
    }

    // MARK: - Picker view data source and delegate

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if  currentField == nil {
            return 0
        }
        if let control = controlForCellSubview(currentField!) as? DropDownControl {
            return control.options.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentField?.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentField == nil {
            return "oops"
        }
        if let control = controlForCellSubview(currentField!) as? DropDownControl {
            return control.optionStrings[row]
        }
        return "oops"
    }

    func pickerViewDone() -> String! {
        if currentField == nil {
            return "oops"
        }

        currentField?.resignFirstResponder()

        if let control = controlForCellSubview(currentField!) as? DropDownControl {
            return control.optionStrings[dropDownPicker.selectedRow(inComponent: 0)]
        }
        return "oops"
    }

}
