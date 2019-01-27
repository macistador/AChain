//
//  AChain-builtin.swift
//  AChain
//
//  Created by Michel-Andre Chirita on 27/01/2019.
//  Copyright © 2019 PagesJaunes. All rights reserved.
//

import UIKit

// MARK : Built-in elementary animations

// Used on a .chain
extension UIView.AChain {

    func rotate(_ layer: CALayer, by angle: CGFloat) -> UIView.AChain {
        return animation {
            layer.transform =  CATransform3DRotate(layer.transform, angle, 0.0, 0.0, 1.0)
        }
    }

    func scale(_ layer: CALayer, to size: CGSize) -> UIView.AChain {
        return animation {
            layer.transform = CATransform3DScale(layer.transform, size.width, size.height, 1.0)
        }
    }

    func move(_ layer: CALayer, by offset: CGPoint) -> UIView.AChain {
        return animation {
            layer.transform = CATransform3DTranslate(layer.transform, offset.x, offset.y, 0)
        }
    }

    func alpha(_ view: UIView, to value: Float) -> UIView.AChain {
        return animation {
            view.alpha = CGFloat(value)
        }
    }
}


// Used on a view, inside an animation closure
extension UIView {
    func reset() {
        layer.transform = CATransform3DIdentity
    }
    func revert() {
        layer.transform = CATransform3DInvert(layer.transform)
    }

    func alpha(_ value: Float) {
        alpha = CGFloat(value)
    }

    func rotate(by angle: Float) {
        layer.transform =  CATransform3DRotate(layer.transform, CGFloat(angle), 0.0, 0.0, 1.0)
    }

    func scale(to size: CGSize) {
        layer.transform = CATransform3DScale(layer.transform, size.height, size.width, 1.0)
    }

    func scale(by factor: Double) {
        scale(to: [CGFloat(factor), CGFloat(factor)])
    }

    func move(by offset: CGPoint) {
        layer.transform = CATransform3DTranslate(layer.transform, offset.x, offset.y, 0)
    }
}
