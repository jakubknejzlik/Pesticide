//
//  PesticideLogger.swift
//  debugdrawer
//
//  Created by Abraham Hunt on 11/21/14.
//  Copyright (c) 2014 Rocketmade. All rights reserved.
//

import UIKit
import CocoaLumberjack

class PesticideLogger: DDAbstractLogger {

    var textView : UITextView?
    var dateFormatter : DateFormatter
    override init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss:SSS"
        super.init()
    }

    override func log(message logMessage: DDLogMessage!) {
        if  self.textView != nil {
            if  logMessage != nil {
                var logString = self.formatMessage(logMessage)
                DispatchQueue.main.async(execute: {
                    if var currentText = self.textView!.text {
                        currentText = currentText + logString
                        logString = currentText
                    }
                    self.textView!.text = logString + "\n"
                    self.textView?.scrollRangeToVisible(NSMakeRange(logString.characters.count - 1, 1))
                })
            }
        }
        return
    }

    func formatMessage(_ logMessage : DDLogMessage) -> String {
        let message = logMessage.message
        let date = logMessage.timestamp
        let dateString = self.dateFormatter.string(from: date!)
        return "\(dateString)  \(message)"
    }
}
