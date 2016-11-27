//
//  DeviceUtils.swift
//  debugdrawer
//
//  Created by Elias Bagley on 11/21/14.
//  Copyright (c) 2014 Rocketmade. All rights reserved.
//

import Foundation
import UIKit

class DeviceUtils {
    class func getDeviceVersionString() -> String {
        let version = UIDevice.current.systemVersion
        let model = UIDevice.current.model

        return "\(model) \(version)"
    }

    class func getResolutionString() -> String {
        let screenSize = UIScreen.main.bounds
        let scale = UIScreen.main.scale
        let width = Int(screenSize.width*scale)
        let height = Int(screenSize.height*scale)

        return "\(width)x\(height)"
    }
}
