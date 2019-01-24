/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import UIKit


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

  struct AnimatorParameters {
    var animation: animBlockType            = {}
    var completion: completBlockType        = {finished in}
    var cancelCompletion: cancelBlockType   = {}

    var delay: TimeInterval             = 0
    var options: UIViewAnimationOptions = []
    let duration: TimeInterval
    var identifier: String

    init(animation: @escaping animBlockType = {}, completion: @escaping completBlockType = {finished in}, cancelCompletion: @escaping cancelBlockType = {}, delay: TimeInterval = 0, options: UIViewAnimationOptions = [], duration: TimeInterval, identifier: String) {
      self.animation        = animation
      self.completion       = completion
      self.cancelCompletion = cancelCompletion
      self.delay            = delay
      self.options          = options
      self.duration         = duration
      self.identifier       = identifier
    }
  }

  /**
   * Animator Class
   *
   * This class facilitates the chaining of animations. It allows you to nest blocks of animations in very few lines of code.
   */

  class AChain {

    typealias AnimationIdentifier = String
    static var animations : [AnimationIdentifier:AChain] = [:]

    var parameters : AnimatorParameters
    var completed: Bool   = false
    var isCancelled: Bool = false
    var previousChainedAnimator: AChain?

    convenience init(duration : TimeInterval = 0, delay: TimeInterval = 0, options: UIViewAnimationOptions = [], identifier: AnimationIdentifier = "default") {
      var parameters         = AnimatorParameters(duration: duration, identifier: identifier)
      parameters.options     = options
      parameters.delay       = delay
      self.init(with: parameters)
      AChain.animations[identifier] = self
    }

    init(with parameters: AnimatorParameters) {
      self.parameters = parameters
    }

    func animation(_ animation: @escaping animBlockType) -> Self {
      self.parameters.animation = animation
      return self
    }

    func completion(_ completion: @escaping completBlockType) -> Self {
      self.parameters.completion = completion
      AChain.animations.removeValue(forKey: self.parameters.identifier)
      return self
    }

    func cancelCompletion(_ cancelCompletion: @escaping cancelBlockType) -> Self {
      if self.previousChainedAnimator != nil {
        _ = self.previousChainedAnimator?.cancelCompletion(cancelCompletion)
      }
      else {
        self.parameters.cancelCompletion = cancelCompletion
      }
      return self
    }

    /// Chain two animations
    /// - Parameter duration: The total duration of the animations
    /// - Parameter delay: The amount of time to wait before beginning the animations
    /// - Parameter options: A mask of options indicating how you want to perform the animations
    /// - Parameter anim: A block object containing the changes to commit to the views
    /// - Returns: Animator with its two animations chained

    func chain(duration : TimeInterval, delay: TimeInterval = 0, options: UIViewAnimationOptions = [], identifier: AnimationIdentifier = "default", anim: @escaping animBlockType) -> AChain {
      var parameters                   = AnimatorParameters(duration: duration, identifier: identifier)
      parameters.delay                 = delay
      parameters.options               = options
      parameters.animation             = anim
      let animator : AChain         = UIView.AChain(with: parameters)
      animator.previousChainedAnimator = self
      return animator
    }

    /// Launches the animation(s)
    func animate() {

      if isCancelled {return}

      if let previousAnimator = self.previousChainedAnimator, completed == false {
        completed = true
        previousAnimator.completion({finished in self.animate()}).animate()
      }
      else {
        UIView.animate(withDuration: parameters.duration, delay: parameters.delay, options: parameters.options, animations: parameters.animation, completion: parameters.completion)
      }
    }

    func revert(layer: CALayer) -> AChain {
      return animation {
        layer.transform = CATransform3DInvert(layer.transform)
      }
    }

    func rotate(layer: CALayer, by angle: CGFloat) -> AChain {
      return animation {
        let transform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
        layer.transform = CATransform3DConcat(layer.transform, transform)
      }
    }

    func scale(layer: CALayer, to size: CGSize) -> AChain {
      return animation {
        layer.transform = CATransform3DScale(layer.transform, size.width, size.height, 0)
      }
    }

    func move(layer: CALayer, by offset: CGPoint) -> AChain {
      return animation {
        let transform = CATransform3DMakeTranslation(offset.x, offset.y, 0)
        layer.transform = CATransform3DConcat(layer.transform, transform)
      }
    }
  }
}


// GARDER CA DANS LA V1 (beta)
extension UIView {
  func revert() {
    layer.transform = CATransform3DInvert(layer.transform)
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
