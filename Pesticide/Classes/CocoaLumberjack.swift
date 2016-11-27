// Created by Ullrich Schäfer on 16/08/14.
// Updated to Swift 1.1 and CocoaLumberjack beta4 by Stan Serebryakov on 24/10/14
// https://gist.github.com/cfr/7da8da56654288fad7aa

import Foundation
import CocoaLumberjack

extension DDLog {
    
    fileprivate struct State {
        static var logLevel: DDLogLevel = .error
        static var logAsync: Bool = true
    }
    
    class var logLevel: DDLogLevel {
        get { return State.logLevel }
        set { State.logLevel = newValue }
    }
    
    class var logAsync: Bool {
        get { return (self.logLevel != .error) && State.logAsync }
        set { State.logAsync = newValue }
    }
    
    class func log(_ flag: DDLogFlag, message: @autoclosure () -> String,
        function: String = #function, file: String = #file,  line: UInt = #line) {
            if flag.rawValue & logLevel.rawValue != 0 {
                let logMsg = DDLogMessage(message: message(), level: logLevel, flag: flag, context: 0,
                    file: file, function: function, line: line,
                    tag: nil, options: DDLogMessageOptions(rawValue: 0), timestamp: nil)
                DDLog.log(asynchronous: logAsync, message: logMsg)
            }
    }
}

func logError(_ message: @autoclosure () -> String, function: String = #function,
    file: String = #file, line: UInt = #line) {
        DDLog.log(.error, message: message, function: function, file: file, line: line)
}

func logWarn(_ message: @autoclosure () -> String, function: String = #function,
    file: String = #file, line: UInt = #line) {
        DDLog.log(.warning, message: message, function: function, file: file, line: line)
}

func logInfo(_ message: @autoclosure () -> String, function: String = #function,
    file: String = #file, line: UInt = #line) {
        DDLog.log(.info, message: message, function: function, file: file, line: line)
}

func logDebug(_ message: @autoclosure () -> String, function: String = #function,
    file: String = #file, line: UInt = #line) {
        DDLog.log(.debug, message: message, function: function, file: file, line: line)
}

func logVerbose(_ message: @autoclosure () -> String, function: String = #function,
    file: String = #file, line: UInt = #line) {
        DDLog.log(.verbose, message: message, function: function, file: file, line: line)
}
