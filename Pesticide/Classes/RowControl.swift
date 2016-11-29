//
//  RowControl.swift
//  debugdrawer
//
//  Created by Abraham Hunt on 11/21/14.
//  Copyright (c) 2014 Rocketmade. All rights reserved.
//

import UIKit

enum ControlType : String {
    case Switch = "SwitchCell"
    case Slider = "SliderCell"
    case Button = "ButtonCell"
    case DropDown = "DropDownCell"
    case Label = "LabelCell"
    case TextInput = "TextFieldCell"
    case Header = "HeaderCell"
}

class RowControl: NSObject {

    var name : String
    var type : ControlType
    init (name : String, type : ControlType) {
        self.name = name
        self.type = type
        super.init()
    }
}

class SwitchControl : RowControl {

    var block : (Bool) -> ()
    var value : Bool

    init (initialValue: Bool, name : String, block: @escaping (Bool) -> ()) {
        self.block = block
        self.value = initialValue
        super.init(name: name, type: .Switch)
    }

    func executeBlock (_ switchOn : Bool) {
        self.block(switchOn)
    }
}

class SliderControl : RowControl {

    var block : (Float) -> ()
    var value : Float

    init (initialValue: Float, name : String, block: @escaping (Float) -> ()) {
        self.block = block
        self.value = initialValue
        super.init(name: name, type: .Slider)
    }

    func executeBlock (_ sliderValue : Float) {
        block(sliderValue)
    }

}

class ButtonControl : RowControl {

    var block : () -> ()

    init (name : String, block: @escaping () -> ()) {
        self.block = block
        super.init(name: name, type: .Button)
    }

    func executeBlock () {
        block()
    }

}

class LabelControl : RowControl {

    var label :String

    init (name : String, label: String) {
        self.label = label
        super.init(name: name, type: .Label)
    }

}

class HeaderControl : RowControl {
    init (name: String) {
        super.init(name: name, type: .Header)
    }
}

class TextInputControl : RowControl {

    var block : (String) -> ()
    var value = ""

    init (name : String, block: @escaping (String) -> ()) {
        self.block = block

        if (Preferences.isSet(name)) {
//            var val = Preferences.load(name) as String?
//            var val: [NSString]? = Preferences.load(name) as? [NSString] //NSUserDefaults.standardUserDefaults().objectForKey("food") as? [NSString]
//            self.value = val as String!
            self.value = Preferences.loadString(name)
            block(self.value)

            print("VALUE: \(self.value)")
        }

        super.init(name: name, type: .TextInput)
    }

    init (name : String, value: String, block: @escaping (String) -> ()) {
        self.block = block

        self.value = value
        block(self.value)

        print("VALUE: \(self.value)")

        super.init(name: name, type: .TextInput)
    }

    init (name : String, type:ControlType,  block: @escaping (String) -> ()) {
        self.block = block
        super.init(name: name, type: type)
    }

    func executeBlock (_ input: String) {
        value = input
        Preferences.save(name, object: value as? AnyObject)
        block(input)
    }

}

class DropDownControl : RowControl {

    var options : Dictionary<String,AnyObject>
    var block : (AnyObject) -> ()
    var value : String
    var optionStrings : Array<String>

    init (initialValue: NSString, name : String, options: Dictionary<String,AnyObject>, block : @escaping (_ option: AnyObject) -> ()) {
        self.value = initialValue as String
        self.options = options
        self.optionStrings = [String](options.keys)
        self.block = block
        super.init(name: name, type: .DropDown)
    }

    func executeBlock(_ input: String) {
        block(options[input]!)
    }

}
