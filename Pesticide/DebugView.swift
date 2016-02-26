//
//  DebugView.swift
//  debugdrawer
//
//  Created by Daniel Gubler on 11/21/14.
//  Copyright (c) 2014 Rocketmade. All rights reserved.
//

import UIKit

class DebugView : UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initInit()
    }

    func initInit() {
        self.backgroundColor = .yellowColor()
    }
}
