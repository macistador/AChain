//
//  Helpers.swift
//  AChain
//
//  Created by Michel-Andre Chirita on 27/01/2019.
//  Copyright © 2019 PagesJaunes. All rights reserved.
//

import UIKit

// MARK: helper methods for the demo

func showVanishing(message: String, in view: UIView, at point: CGPoint) {
    let label = UILabel()
    label.text = message
    label.frame = CGRect(x: point.x, y: point.y, width: 200, height: 50)
    view.addSubview(label)

    UIView
        .AChain(withDuration: 1.5, options: [.curveEaseOut])
        .move(label.layer, by: [0, -80])
        .alpha(label, to: 0)
        .completion{ _ in label.removeFromSuperview()}
        .animate()
}

extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
