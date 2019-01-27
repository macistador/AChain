/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import UIKit


extension UIView {
    static func chainAnimate(withDuration duration : TimeInterval, delay: TimeInterval = 0, options: UIViewAnimationOptions = [], anim: @escaping animBlockType) -> AChain {
        return AChain().chain(withDuration: duration, delay: delay, options: options, anim: anim)
    }
}

extension UIView {

    typealias animBlockType      = ()->()
    typealias completBlockType   = (Bool)->()
    typealias cancelBlockType    = ()->()

    /**
     * Animator Parameters
     *
     * This parameters structure groups the blocks:
     * - animation block
     * - cancellation block
     * - end block
     *
     * It also contains the parameters of the animation
     */

    struct ChainAnimationParameters {
        var animations: [animBlockType]         = [{}]
        var completion: completBlockType        = {finished in}
        var cancelCompletion: cancelBlockType   = {}

        var delay: TimeInterval             = 0
        var options: UIViewAnimationOptions = []
        let duration: TimeInterval

        init(animation: @escaping animBlockType = {}, completion: @escaping completBlockType = {finished in}, cancelCompletion: @escaping cancelBlockType = {}, delay: TimeInterval = 0, options: UIViewAnimationOptions = [], duration: TimeInterval) {
            self.animations       = [animation]
            self.completion       = completion
            self.cancelCompletion = cancelCompletion
            self.delay            = delay
            self.options          = options
            self.duration         = duration
        }
    }

    /**
     * Animator Class
     *
     * This class facilitates the chaining of animations. It allows you to nest blocks of animations in very few lines of code.
     */

    class AChain {

        var parameters : ChainAnimationParameters
        var completed: Bool   = false
        var isCancelled: Bool = false
        var previousChain: AChain?

        convenience init(withDuration duration : TimeInterval = 0, delay: TimeInterval = 0, options: UIViewAnimationOptions = []) {
            var parameters         = ChainAnimationParameters(duration: duration)
            parameters.options     = options
            parameters.delay       = delay
            self.init(with: parameters)
        }

        init(with parameters: ChainAnimationParameters) {
            self.parameters = parameters
        }

        func animation(_ animation: @escaping animBlockType) -> Self {
            self.parameters.animations.append(animation)
            return self
        }

        func completion(_ completion: @escaping completBlockType) -> Self {
            self.parameters.completion = completion
            return self
        }

        func cancel() {
            if self.previousChain != nil {
                _ = self.previousChain?.cancel()
            }
            self.isCancelled = true
        }

        func cancelCompletion(_ cancelCompletion: @escaping cancelBlockType) -> Self {
            if self.previousChain != nil {
                _ = self.previousChain?.cancelCompletion(cancelCompletion)
            }
            else {
                self.parameters.cancelCompletion = cancelCompletion
            }
            return self
        }

        /// Chain two animations
        /// - Parameter duration: The total duration of the animations /// ????
        /// - Parameter delay: The amount of time to wait before beginning the animations
        /// - Parameter options: A mask of options indicating how you want to perform the animations
        /// - Parameter anim: A block object containing the changes to commit to the views
        /// - Returns: Animator with its two animations chained

        func chain(withDuration duration : TimeInterval, delay: TimeInterval = 0, options: UIViewAnimationOptions = [], anim: @escaping animBlockType = {}) -> AChain {
            var parameters                   = ChainAnimationParameters(duration: duration)
            parameters.delay                 = delay
            parameters.options               = options
            parameters.animations            = [anim]
            let newChain : AChain            = UIView.AChain(with: parameters)
            newChain.previousChain = self
            return newChain
        }

        /// Launches the animation(s)
        func animate() {

            if isCancelled {
                parameters.cancelCompletion()
                return
            }

            if let previousAnimator = self.previousChain, completed == false {
                completed = true
                previousAnimator.completion({finished in self.animate()}).animate()
            }
            else {
                let animation = {
                    self.parameters.animations.forEach{ anim in anim() }
                }
                UIView.animate(withDuration: parameters.duration, delay: parameters.delay, options: parameters.options, animations: animation, completion: parameters.completion)
            }
        }

        func reset(layer: CALayer) -> AChain {
            return animation {
                layer.transform = CATransform3DIdentity
            }
        }

        func revert(layer: CALayer) -> AChain {
            return animation {
                layer.transform = CATransform3DInvert(layer.transform)
            }
        }

        func rotate(layer: CALayer, by angle: CGFloat) -> AChain {
            return animation {
                layer.transform =  CATransform3DRotate(layer.transform, angle, 0.0, 0.0, 1.0)
            }
        }

        func scale(layer: CALayer, to size: CGSize) -> AChain {
            return animation {
                layer.transform = CATransform3DScale(layer.transform, size.width, size.height, 1.0)
            }
        }

        func move(layer: CALayer, by offset: CGPoint) -> AChain {
            return animation {
                layer.transform = CATransform3DTranslate(layer.transform, offset.x, offset.y, 0)
            }
        }

        func alpha(view: UIView, to value: Float) -> AChain {
            return animation {
                view.alpha = CGFloat(value)
            }
        }
    }
}


// MARK: Standard animations helpers
// GARDER CA DANS LA V1 (beta)
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
        let transform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
        layer.transform = CATransform3DConcat(layer.transform, transform)
    }

    func scale(x: Double, y: Double, z: Double) {
        let transform = CATransform3DMakeScale(CGFloat(x), CGFloat(y), CGFloat(z))
        layer.transform = CATransform3DConcat(layer.transform, transform)
    }

    func scale(by factor: Double) {
        let transform = CATransform3DMakeScale(CGFloat(factor), CGFloat(factor), CGFloat(0))
        layer.transform = CATransform3DConcat(layer.transform, transform)
    }

    func move(by offset: CGPoint) {
        let transform = CATransform3DMakeTranslation(offset.x, offset.y, 0)
        layer.transform = CATransform3DConcat(layer.transform, transform)
    }

    func move(x: Double, y: Double, z: Double) {
        let transform = CATransform3DMakeTranslation(CGFloat(x), CGFloat(y), CGFloat(z))
        layer.transform = CATransform3DConcat(layer.transform, transform)
    }
}

extension CGPoint: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: CGFloat...) {
        assert(elements.count == 2)
        self.init(x: elements[0], y: elements[1])
    }
}

extension CGSize: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: CGFloat...) {
        assert(elements.count == 2)
        self.init(width: elements[0], height: elements[1])
    }
}
