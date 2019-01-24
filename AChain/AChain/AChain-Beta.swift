/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import UIKit

extension UIView: AChainAnimatable {}

protocol AChainAnimatable {
  var cloneLayer: CALayer {get}
//  var replicateLayer: Bool {get}
}

// reuse the animator for all the animations ?
// move something to a protocol to be implemented by the root view ?
// remove the layer and the replicator after the animation
extension AChainAnimatable where Self: UIView {
  var cloneLayer: CALayer {
    //    if replicateLayer {
    guard let superview = superview else {return CALayer()}
    let replicatorLayer = CAReplicatorLayer()
    replicatorLayer.frame.size = superview.frame.size
    replicatorLayer.masksToBounds = true
    superview.layer.addSublayer(replicatorLayer)

    let imageLayer = CALayer()
    imageLayer.contents = layer.contents
    imageLayer.frame.size = layer.frame.size
    imageLayer.backgroundColor = layer.backgroundColor

    replicatorLayer.addSublayer(imageLayer)
    replicatorLayer.instanceCount = 1
//    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(100, 0, 0)
//    replicatorLayer.instanceGreenOffset = -0.2

    return imageLayer
    //    }
    //    else {
    //      return layer
    //    }
  }
}

extension CALayer {
  func rotate(by angle: Float) {

  }

  func scaleTo(x: Double, y: Double, z: Double) {

  }

  func move(to newBounds: CGRect) {
    let positionAnimation = CABasicAnimation(keyPath: "bounds")
    positionAnimation.fromValue = NSValue(cgRect: bounds)
    positionAnimation.toValue = NSValue(cgRect: newBounds)
    positionAnimation.duration = 3
    add(positionAnimation, forKey: "bounds")
  }
}

extension UIView {

  typealias achainBlockType          = ()->()
  typealias achainLayerBlockType     = ([CALayer])->()
  typealias achainCompletBlockType   = (Bool)->()
  typealias achainCancelBlockType    = ()->()

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
  struct AChainParameters {
    var animation: achainBlockType                = {}
    var completion: achainCompletBlockType        = {finished in}
    var cancelCompletion: achainCancelBlockType   = {}

    var delay: TimeInterval             = 0
    var options: UIViewAnimationOptions = []
    let duration: TimeInterval
    var identifier: String

    //todo: faire un init sans paramétres car initialement ils ne servent à rien
    init(animation: @escaping achainBlockType = {}, completion: @escaping achainCompletBlockType = {finished in}, cancelCompletion: @escaping achainCancelBlockType = {}, delay: TimeInterval = 0, options: UIViewAnimationOptions = [], duration: TimeInterval, identifier: String) {
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

    typealias AChainIdentifier = String
    static var animations : [AChainIdentifier:AChain] = [:]
    private var parameters : AChainParameters
    private var completed: Bool   = false
    private var isCancelled: Bool = false
    private var previousChain: AChain?

    convenience init(duration: TimeInterval, delay: TimeInterval = 0, options: UIViewAnimationOptions = [], identifier: AChainIdentifier = "default") {
      var parameters         = AChainParameters(duration: duration, identifier: identifier)
      parameters.options     = options
      parameters.delay       = delay
      self.init(with: parameters)
      AChain.animations[identifier] = self
    }

    init(with parameters: AChainParameters) {
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
      if self.previousChain != nil {
        _ = self.previousChain?.cancelCompletion(cancelCompletion)
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
    func chain(duration : TimeInterval, delay: TimeInterval = 0, options: UIViewAnimationOptions = [], identifier: AChainIdentifier = "default", anim: @escaping achainBlockType) -> AChain {
      var parameters                   = AChainParameters(duration: duration, identifier: identifier)
      parameters.delay                 = delay
      parameters.options               = options
      parameters.animation             = anim
      let chain : AChain               = UIView.AChain(with: parameters)
      chain.previousChain = self
      return chain
    }

    /// Launches the animation(s)
    func animate() {

      if isCancelled {return}

      if let previousAnimator = self.previousChain, completed == false {
        completed = true
        previousAnimator.completion({finished in self.animate()}).animate()
      }
      else {
        UIView.animate(withDuration: parameters.duration, delay: parameters.delay, options: parameters.options, animations: parameters.animation, completion: parameters.completion)
      }
    }

    // à refléchir :
    func revert(layer: CALayer) {
      isCancelled = true
      layer.transform = CATransform3DInvert(layer.transform)
    }

    // à virer :
    static func rotate(layer: CALayer, by angle: CGFloat) {
      let transform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
      layer.transform = CATransform3DConcat(layer.transform, transform)
    }

    static func scale(layer: CALayer, to size: CGSize) {
      layer.transform = CATransform3DScale(layer.transform, size.width, size.height, 0)
    }

    static func move(layer: CALayer, by offset: CGPoint) {
      let transform = CATransform3DMakeTranslation(offset.x, offset.y, 0)
      layer.transform = CATransform3DConcat(layer.transform, transform)
    }

//    static func chain(by identifier: AChainIdentifier) -> AChain {
//      return ...
//    }
  }

}


/*
TODO

 - init sans param & animation ?
 - retenir la chaine dans les userDefaults ? ou bien dans un dico static ? (retirer progressivement chaque chaine lorsque les animations sont finies ?)
 - penser à faire le revert en récupérant la chaine

 - add record mode:  with gesture we move, rotate and scale layer, then we set steps which are printing source code to copy & paste in the code base. To be activated in code, then double click on a layer enters in record mode




 */




