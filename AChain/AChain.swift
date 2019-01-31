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

        private var parameters : ChainAnimationParameters
        var completed: Bool   = false
        var isCancelled: Bool = false
        private var previousChain: AChain?

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

        /// Init the chain
        ///
        /// - Parameters:
        ///   - duration: duration in seconds of the first chain step animations
        ///   - delay: delay in seconds before the first chain animations
        ///   - options: options
        convenience init(withDuration duration : TimeInterval = 0, delay: TimeInterval = 0, options: UIView.AnimationOptions = []) {
            var parameters         = ChainAnimationParameters(duration: duration)
            parameters.options     = options
            parameters.delay       = delay
            self.init(with: parameters)
        }

        /// Initializer of a chain step
        /// Not designed to be called directly
        ///
        /// - Parameter parameters: parameters of the chain step
        private init(with parameters: ChainAnimationParameters) {
            self.parameters = parameters
        }

        /// Add an animation closure to this step pool of animations
        ///
        /// - Parameter animation: animation closure
        /// - Returns: the chain step
        func animation(_ animation: @escaping animBlockType) -> Self {
            self.parameters.animations.append(animation)
            return self
        }

        /// Set the completion closure and propagate to the previous steps
        ///
        /// - Parameter completion: the completion closure
        /// - Returns: the chain step
        func completion(_ completion: @escaping completBlockType) -> Self {
            self.parameters.completion = completion
            return self
        }

        /// Cancel the chain by propagatting the cancel signal to all previous steps
        func cancel() {
            if self.previousChain != nil {
                _ = self.previousChain?.cancel()
            }
            self.isCancelled = true
        }

        /// Set the cancel completion and propagate it to the previous steps
        ///
        /// - Parameter cancelCompletion: cancel completion called if the chain is cancelled
        /// - Returns: this chain step
        func cancelCompletion(_ cancelCompletion: @escaping cancelBlockType) -> Self {
            if self.previousChain != nil {
                _ = self.previousChain?.cancelCompletion(cancelCompletion)
            }
            else {
                self.parameters.cancelCompletion = cancelCompletion
            }
            return self
        }

        /// Launches the chain animation(s)
        /// To be called after all the steps are declared
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

    fileprivate struct ChainAnimationParameters {
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

    /// Alternative initializer of a chain
    static func chainAnimate(withDuration duration : TimeInterval, delay: TimeInterval = 0, options: UIView.AnimationOptions = [], anim: @escaping animBlockType = {}) -> AChain {
        return AChain().chain(withDuration: duration, delay: delay, options: options, anim: anim)
    }
}
