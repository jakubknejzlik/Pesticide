//
//  CrosshairOverlay.swift
//  debugdrawer
//
//  Created by Elias Bagley on 11/22/14.
//  Copyright (c) 2014 Rocketmade. All rights reserved.
//

import Foundation

let radius:CGFloat = 15

class TouchTrackerView : UIView {

    var circle : UIView = UIView()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(frame: CGRect) {
        circle = UIView()
        super.init(frame: frame)

        circle.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        circle.layer.cornerRadius = radius/2
        circle.layer.borderColor = UIColor.gray.cgColor
        circle.layer.borderWidth = 1
        circle.alpha = 0

        circle.translatesAutoresizingMaskIntoConstraints = false

        circle.frame = CGRect(x: 0, y: 0, width: radius, height: radius)

        addSubview(circle)
    }

    // pass touches though this overlay view
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        setFramesFromPoint(point)
        showCircle()
        hideCircle()
        return false
    }

    func setFramesFromPoint(_ point: CGPoint) {
        circle.frame = CGRect(x: point.x, y: point.y, width: radius, height: radius)
    }

    func showCircle() {
        circle.alpha = 1;
    }

    func hideCircle() {
        UIView.animate(withDuration: 0.15, delay: 0.1, options: .curveEaseIn, animations: { () -> Void in
            self.circle.alpha = 0
        }, completion: nil)
    }
}
