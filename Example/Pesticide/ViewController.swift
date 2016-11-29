//
//  ViewController.swift
//  Pesticide
//
//  Created by Jakub Knejzlik on 09/30/2016.
//  Copyright (c) 2016 Inloop. All rights reserved.
//

import UIKit
import Pesticide

class ViewController: UIViewController {

    @IBAction func togglePesticide() {
        Pesticide.toggle()
    }

}

