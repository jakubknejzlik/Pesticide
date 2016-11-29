//
//  Pesticide.swift
//  debugdrawer
//
//  Created by Daniel Gubler on 11/21/14.
//  Copyright (c) 2014 Rocketmade. All rights reserved.
//

import CocoaLumberjack

public enum PesticideControlType {
    case button
    case `switch`
    case slider
    case dropdown
    case label
    case header
}

public final class Pesticide {
    
    fileprivate struct CV {
        static let debugVC = DebugTableController()
        static var commands = Dictionary<String, (Array<String>) -> ()>()
        static var window = UIWindow()
        static var isSetup = false
        static var viewInspector: ViewInspector?
        static var crosshairOverlay: CrosshairOverlay?
        static var touchesOverlay : TouchTrackerView?
        static var hasCommandPrompt = false
    }

    open class func log(_ message: String) {
        logInfo(message)
    }
    
    open class func addCommand(_ commandName: String, block: @escaping (Array<String>) -> ()) {
        if !CV.hasCommandPrompt {
            addTextInput("Commands", block: {(command: String) in
                if command.characters.count < 1 {
                    return
                }
                self.runFullCommand(command)
            })
            CV.hasCommandPrompt = true
        }
        CV.commands[commandName] = block
    }
    
    class func runFullCommand(_ command: String) {
        var components = command.components(separatedBy: " ")
        let name = components.remove(at: 0)
        let block = CV.commands[name]
        block?(components)
    }
    
    open class func addSwitch(_ initialValue: Bool, name: String, block: @escaping (Bool) -> ()) {
        CV.debugVC.addRowControl(SwitchControl(initialValue: initialValue, name: name, block: block))
    }
    
    open class func addButton(_ name: String, block: @escaping () -> ()) {
        CV.debugVC.addRowControl(ButtonControl(name: name, block: block))
    }
    
    open class func addSlider(_ initialValue: Float, name: String, block: @escaping (Float) -> ()) {
        CV.debugVC.addRowControl(SliderControl(initialValue: initialValue, name: name, block: block))
    }
    
    open class func addDropdown(_ initialValue: String, name: String, options: Dictionary<String,AnyObject>, block: @escaping (_ option: AnyObject) -> ()) {
        CV.debugVC.addRowControl(DropDownControl(initialValue: initialValue as NSString, name: name, options:options, block: block))
    }
    
    open class func addLabel(_ name: String, label: String) {
        CV.debugVC.addRowControl(LabelControl(name: name, label: label))
    }
    
    open class func addTextInput(_ name: String, block: @escaping (String) -> ()) {
        CV.debugVC.addRowControl(TextInputControl(name: name, block: block))
    }

    open class func addHeader(_ name: String) {
        CV.debugVC.addRowControl(HeaderControl(name: name))
    }
    
    open class func addProxy(_ block: @escaping (URLSessionConfiguration) -> ()) {
        Pesticide.addTextInput("Proxy", block: { (hostAndPort: String) in
            let config = Proxy.createSessionConfiguration(hostAndPort)
            block(config)
        })
    }
    
    open class func toggle() {
        let topVC :UIViewController = topViewController(CV.window.rootViewController!)
        if (topVC.isKind(of: DebugTableController.self)) {

            topVC.dismiss(animated: true, completion: nil)
        } else {
            topVC.present(CV.debugVC, animated: true, completion: nil)
        }
    }
    
    
    
    
    
// MARK: setter functions
    
    open class func setWindow(_ window :UIWindow) {
        if (!CV.isSetup) {
            Pesticide.setup()
        }
        CV.window = window
    }
    
    
    
    
// MARK: private functions
    
    fileprivate class func setup() {
        setupLogging()
        // Build information
        Pesticide.addHeader("Build Information")

        Pesticide.addLabel("Date", label: BuildUtils.getDateString())
        Pesticide.addLabel("Version", label: BuildUtils.getVersionString())
        Pesticide.addLabel("Build", label: BuildUtils.getBuildNumberString())
        Pesticide.addLabel("Hash", label: BuildUtils.getGitHash())

        // Device information
        Pesticide.addHeader("Device Information")
        Pesticide.addLabel("Device", label: DeviceUtils.getDeviceVersionString())
        Pesticide.addLabel("Resolution", label: DeviceUtils.getResolutionString())

        // User interface
        Pesticide.addHeader("User Interface")
        Pesticide.addSwitch(false, name:"Hierarchy Viewer", block: { (on: Bool) in
            if (on) {
                if let root = CV.window.rootViewController?.view {
                    CV.viewInspector = ViewInspector(rootView: root)
                    self.toggle()
                }
            } else {
                CV.viewInspector?.done()
            }
        })
        Pesticide.addSwitch(false, name:"Crosshair View", block: { (on: Bool) in
            if (on) {
                CV.crosshairOverlay = CrosshairOverlay(frame: CV.window.bounds)
                CV.window.rootViewController?.view.addSubview(CV.crosshairOverlay!)
                self.toggle()
            } else {
                CV.crosshairOverlay?.removeFromSuperview()
            }
        })
        Pesticide.addSwitch(false, name:"Show Touches", block: { (on: Bool) in
            if (on) {
                CV.touchesOverlay = TouchTrackerView(frame: CV.window.bounds)
                CV.window.rootViewController?.view.addSubview(CV.touchesOverlay!)
                self.toggle()
            } else {
                CV.touchesOverlay?.removeFromSuperview()
            }
        })


        // Network
        Pesticide.addHeader("Network")
        
        CV.isSetup = true
    }
    
    fileprivate class func setupLogging () {
        Pesticide.startLogging()
        //Logging
        Pesticide.addHeader("Logging")
        
        let logOptions = ["All":"All","Verbose":"Verbose","Debug":"Debug","Info":"Info","Warning":"Warning","Error":"Error","Off":"Off"];
        Pesticide.addDropdown("Verbose", name: "Log Level", options: logOptions as Dictionary<String, AnyObject>, block: {(option:AnyObject) in
            if let newLevel = option as? String {
                switch newLevel {
                case "All":
                    DDLog.logLevel = .all
                case "Verbose":
                    DDLog.logLevel = .verbose
                case "Debug":
                    DDLog.logLevel = .debug
                case "Info":
                    DDLog.logLevel = .info
                case "Warning":
                    DDLog.logLevel = .warning
                case "Error":
                    DDLog.logLevel = .error
                case "Off":
                    DDLog.logLevel = .off
                default:
                    DDLog.logLevel = .verbose
                }
            }
        })
    }
    
    fileprivate class func topViewController(_ rootController :UIViewController)->UIViewController {
        if (rootController.presentedViewController != nil) {
            return topViewController(rootController.presentedViewController!)
        } else {
            return rootController
        }
    }
    
    fileprivate class func startLogging () {
        DDLog.logLevel = .verbose
        DDLog.add(DDTTYLogger.sharedInstance())
        DDLog.add(DDASLLogger.sharedInstance())
        let fileLogger = DDFileLogger()
        fileLogger?.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        fileLogger?.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
}
