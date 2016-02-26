//
//  CrosshairOverlay.swift
//  debugdrawer
//
//  Created by Elias Bagley on 11/22/14.
//  Copyright (c) 2014 Rocketmade. All rights reserved.
//

import Foundation

let lineWidth:CGFloat = 1.0

class CrosshairOverlay : UIView {

    let horizontal = UIView()
    let vertical = UIView()
    let label = UILabel()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        vertical.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.75)
        horizontal.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.75)
        label.textColor = UIColor.redColor()

        horizontal.translatesAutoresizingMaskIntoConstraints = false
        vertical.translatesAutoresizingMaskIntoConstraints = false

        horizontal.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), lineWidth)
        vertical.frame = CGRectMake(0, 0, lineWidth, CGRectGetHeight(self.bounds))
        label.frame = CGRectMake(5, 10, 100, 30)

        self.addSubview(horizontal)
        self.addSubview(vertical)
        self.addSubview(label)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.locationInView(self) {
            self.setFramesFromPoint(point)
        }

        super.touchesBegan(touches, withEvent: event)
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.locationInView(self) {
            self.setFramesFromPoint(point)
        }

        super.touchesMoved(touches, withEvent: event)
    }

    func setFramesFromPoint(point: CGPoint) {
        horizontal.frame = CGRectMake(0, point.y, CGRectGetWidth(self.bounds), lineWidth)
        vertical.frame = CGRectMake(point.x, 0, lineWidth, CGRectGetHeight(self.bounds))

        label.text = "\(point.x), \(point.y)"
    }
}
