//
//  AChain-builtin.swift
//  AChain
//
//  Created by Michel-Andre Chirita on 27/01/2019.
//  Copyright © 2019 PagesJaunes. All rights reserved.
//

import UIKit

/*
 * AChain
 * Built-in elementary animations
 * Compose this helpers for a short & clean syntaxe
 */

// Used on a .chain
extension UIView.AChain {

    func rotate(_ layer: CALayer, by angle: CGFloat) -> UIView.AChain {
        return animation {
            print("👉 >>> rotate on transform: \(layer.affineTransform())")
//            layer.transform = CATransform3DRotate(layer.transform, angle, 0.0, 0.0, 1.0)
            let newTransform = layer.affineTransform().rotated(by: angle)
            layer.setAffineTransform(newTransform)
        }
    }

    func scale(_ layer: CALayer, to size: CGSize) -> UIView.AChain {
        return animation {
            print("👉 >>> Scale on transform: \(layer.affineTransform())")
//            layer.transform = CATransform3DScale(layer.transform, size.width, size.height, 1.0)
            let newTransform = layer.affineTransform().scaledBy(x: size.width, y: size.height)
            
            layer.setAffineTransform(newTransform)
        }
    }

    func move(_ layer: CALayer, by offset: CGPoint) -> UIView.AChain {
        return animation {
            print("👉 >>> move on transform: \(layer.affineTransform())")
//            layer.transform = CATransform3DTranslate(layer.transform, offset.x, offset.y, 0)
            let newTransform = layer.affineTransform().translatedBy(x: offset.x, y: offset.y)
            layer.setAffineTransform(newTransform)
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
        layer.transform = CATransform3DRotate(layer.transform, CGFloat(angle), 0.0, 0.0, 1.0)
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

// MARK: helpers

/// Syntactic sugar for expressing a CGPoint with the format [x,y]
extension CGPoint: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: CGFloat...) {
        assert(elements.count == 2)
        self.init(x: elements[0], y: elements[1])
    }
}

/// Syntactic sugar for expressing a CGSize with the format [height,width]
extension CGSize: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: CGFloat...) {
        assert(elements.count == 2)
        self.init(width: elements[0], height: elements[1])
    }
}
