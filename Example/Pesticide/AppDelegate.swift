//
//  AppDelegate.swift
//  Pesticide
//
//  Created by Jakub Knejzlik on 09/30/2016.
//  Copyright (c) 2016 Inloop. All rights reserved.
//

import UIKit
import Pesticide

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let window = window {
            Pesticide.setWindow(window)
        }
        
        Pesticide.log("Hello, World!")
        
        Pesticide.addButton("Hide") { 
            Pesticide.toggle()
        }
        
        return true
    }

}

