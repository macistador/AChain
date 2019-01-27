/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import UIKit

extension UIView {

    /**
     * AChain
     *
     * Lightweight, syntax-similar to default UIKit, yet powerful animation lib
     *
     * Its main goal is to facilitates the chaining of animations.
     * It allows you to nest blocks of animations in very few lines of code.
     *
     */

    class AChain {

        var parameters : ChainAnimationParameters
        var completed: Bool   = false
        var isCancelled: Bool = false
        var previousChain: AChain?

        /// Chain two animations
        /// - Parameter duration: The total duration of the animations /// ????
        /// - Parameter delay: The amount of time to wait before beginning the animations
        /// - Parameter options: A mask of options indicating how you want to perform the animations
        /// - Parameter anim: A block object containing the changes to commit to the views
        /// - Returns: Animator with its two animations chained

        func chain(withDuration duration : TimeInterval, delay: TimeInterval = 0, options: UIView.AnimationOptions = [], anim: @escaping animBlockType = {}) -> AChain {
            var parameters                   = ChainAnimationParameters(duration: duration)
            parameters.delay                 = delay
            parameters.options               = options
            parameters.animations            = [anim]
            let newChain : AChain            = UIView.AChain(with: parameters)
            newChain.previousChain = self
            return newChain
        }

        /// FIXME: documentation needed...
        convenience init(withDuration duration : TimeInterval = 0, delay: TimeInterval = 0, options: UIView.AnimationOptions = []) {
            var parameters         = ChainAnimationParameters(duration: duration)
            parameters.options     = options
            parameters.delay       = delay
            self.init(with: parameters)
        }

        /// FIXME: documentation needed...
        init(with parameters: ChainAnimationParameters) {
            self.parameters = parameters
        }

        /// FIXME: documentation needed...
        func animation(_ animation: @escaping animBlockType) -> Self {
            self.parameters.animations.append(animation)
            return self
        }

        /// FIXME: documentation needed...
        func completion(_ completion: @escaping completBlockType) -> Self {
            self.parameters.completion = completion
            return self
        }

        /// FIXME: documentation needed...
        func cancel() {
            if self.previousChain != nil {
                _ = self.previousChain?.cancel()
            }
            self.isCancelled = true
        }

        /// FIXME: documentation needed...
        func cancelCompletion(_ cancelCompletion: @escaping cancelBlockType) -> Self {
            if self.previousChain != nil {
                _ = self.previousChain?.cancelCompletion(cancelCompletion)
            }
            else {
                self.parameters.cancelCompletion = cancelCompletion
            }
            return self
        }

        /// Launches the animation(s)
        /// To be called after the animation declaration
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
    }
}



// MARK: Parameters

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
        var options: UIView.AnimationOptions = []
        let duration: TimeInterval

        init(animation: @escaping animBlockType = {}, completion: @escaping completBlockType = {finished in}, cancelCompletion: @escaping cancelBlockType = {}, delay: TimeInterval = 0, options: UIView.AnimationOptions = [], duration: TimeInterval) {
            self.animations       = [animation]
            self.completion       = completion
            self.cancelCompletion = cancelCompletion
            self.delay            = delay
            self.options          = options
            self.duration         = duration
        }
    }
}



// MARK: Sugar syntax

extension UIView {
    static func chainAnimate(withDuration duration : TimeInterval, delay: TimeInterval = 0, options: UIView.AnimationOptions = [], anim: @escaping animBlockType) -> AChain {
        return AChain().chain(withDuration: duration, delay: delay, options: options, anim: anim)
    }
}



// MARK: helpers

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
