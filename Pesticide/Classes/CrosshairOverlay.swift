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
        label.textColor = UIColor.red

        horizontal.translatesAutoresizingMaskIntoConstraints = false
        vertical.translatesAutoresizingMaskIntoConstraints = false

        horizontal.frame = CGRect(x: 0, y: 0, width: bounds.width, height: lineWidth)
        vertical.frame = CGRect(x: 0, y: 0, width: lineWidth, height: bounds.height)
        label.frame = CGRect(x: 5, y: 10, width: 150, height: 30)

        addSubview(horizontal)
        addSubview(vertical)
        addSubview(label)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: self) {
            setFramesFromPoint(point)
        }

        super.touchesBegan(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: self) {
            setFramesFromPoint(point)
        }

        super.touchesMoved(touches, with: event)
    }

    func setFramesFromPoint(_ point: CGPoint) {
        horizontal.frame = CGRect(x: 0, y: point.y, width: bounds.width, height: lineWidth)
        vertical.frame = CGRect(x: point.x, y: 0, width: lineWidth, height: bounds.height)

        label.text = "\(roundPoint(point.x)), \(roundPoint(point.y))"
    }

    fileprivate func roundPoint(_ p: CGFloat) -> CGFloat {
        return round(p * 100) / 100
    }

}
