//
//  ViewController.swift
//  AChain
//
//  Created by Michel-Andre Chirita on 17/04/2018.
//  Copyright © 2018 PagesJaunes. All rights reserved.
//

import UIKit

class DemoAChainBeta: UIViewController {

  @IBOutlet weak var blueView: UIView!
  @IBOutlet weak var redView: UIView!
  @IBOutlet weak var greenView: UIView!
  
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var PauseButton: UIButton!
  @IBOutlet weak var RevertButton: UIButton!
  @IBOutlet weak var replicatorSwitch: UISwitch!

//  var imageLayer = CALayer()

  override func viewDidLoad() {
    super.viewDidLoad()
//    self.imageLayer = self.redView.cloneLayer
  }

  @IBAction func startAction(_ sender: Any) {
    let redLayer = self.redView.cloneLayer

//    UIView.AChain.animateClones(of: [self.redView]) { redClone in
//      let newBounds = CGRect(x: 40, y: 50, width: 32, height: 80)
//      redLayer.move(to: newBounds)
//    }

//    UIView.AChain(duration: 1.0, delay: 0, options: [.curveEaseIn], identifier: "red-beta")
//      .chain(duration: 0.5, anim: {
//        UIView.AChain.rotate(layer: redLayer, by: CGFloat(30))
//        UIView.AChain.move(layer: redLayer, by: CGPoint(x: 40, y: 35))
//        redLayer.setNeedsLayout()
//        redLayer.layoutIfNeeded()
//      })
//      .chain(duration: 2.0) {
//        UIView.AChain.move(layer: redLayer, by: CGPoint(x: 55, y: 80))
//        redLayer.setNeedsLayout()
//        redLayer.layoutIfNeeded()
//      }
//      .completion{ _ in
//        redLayer.removeFromSuperlayer()
//      }
//      .animate()

    showVanishingMessage("Animation starts...")
  }
  
  @IBAction func PauseAction(_ sender: Any) {

  }
  
  @IBAction func RevertAction(_ sender: Any) {

  }
}


extension DemoAChainBeta {
  private func showVanishingMessage(_ message: String) {
    let label = UILabel(frame: CGRect(x: 50, y: 500, width: 200, height: 50))
    label.text = message
    view.addSubview(label)
//    label.isHidden = true

//    let clone = label.cloneLayer
    UIView.AChain(duration: 1.5).animation {
//      UIView.AChain.move(layer: clone, by: CGPoint(x: 0, y: -80))
      //      clone.opacity = 0.0
      label.move(by: CGPoint(x: 0, y: -80))
      label.layer.opacity = 0.0
      }.completion{ _ in label.removeFromSuperview();
//        clone.removeFromSuperlayer()}.animate()
        label.removeFromSuperview()}.animate()
  }
}


