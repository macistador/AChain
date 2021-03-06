//
//  ViewController.swift
//  AChain
//
//  Created by Michel-Andre Chirita on 17/04/2018.
//  Copyright © 2018 PagesJaunes. All rights reserved.
//

import UIKit

/*
 AChain demo

 This class presents how to animate a simple view
 with vanilla UIKit
 and with AChain

 */

class DemoAChain: UIViewController {

    var redView: UIView!
    var activeChain: UIView.AChain?

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var ResetButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

    /// Configuring the animable views
    private func configureViews() {
        redView = UIView()
        redView.frame = CGRect(x: 140, y: 250, width: 93, height: 85)
        redView.translatesAutoresizingMaskIntoConstraints = false
        redView.backgroundColor = .red
        view.addSubview(redView)
    }
}


// MARK: Classic methods for doing simple chained animations

extension DemoAChain {

    /// This is how you would have done animations without AChain
    @IBAction func startAction_NOT_CALLED(_ sender: Any) {

        showVanishing(message: "Animation starts...")

        // Classic method 1
        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseIn], animations: {
            var transform = CATransform3DTranslate(self.redView.layer.transform, 100, 35, 0)
            transform = CATransform3DRotate(transform, 30, 0.0, 0.0, 1.0)
            self.redView.layer.transform = transform
        }) { _ in

            UIView.animate(withDuration: 3.0, delay: 0, options: [.curveEaseIn], animations: {
                var transform = CATransform3DTranslate(self.redView.layer.transform, 100, 35, 0)
                transform = CATransform3DRotate(transform, 30, 0.0, 0.0, 1.0)
                self.redView.layer.transform = transform
            }) { _ in

                UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseIn], animations: {
                    var transform = CATransform3DTranslate(self.redView.layer.transform, 100, 35, 0)
                    transform = CATransform3DRotate(transform, 30, 0.0, 0.0, 1.0)
                    self.redView.layer.transform = transform
                })
            }
        }

        // Classic method 2
        UIView.animateKeyframes(withDuration: 5, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                self.redView.transform = CGAffineTransform(scaleX: 2, y: 2)
            }

            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                self.redView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.maxY)
            }

            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25) {
                self.redView.center = CGPoint(x: self.view.bounds.width, y: self.view.bounds.height)
            }
        })

        //
        // Not bad
        // but too verbose when we need to chain multiple animations...
        //
    }
}


// MARK: Same animations with AChain, with and without helpers
// For usual animation needs it's shorter and cleaner to use the built-in helpers

extension DemoAChain {

    fileprivate func startAction1() {
        showVanishing(message: "Animation starts...")

        /// Basic sample closest to the default UIKit implementation
        /// All parameters but the duration are optionnals
        UIView.chainAnimate(withDuration: 1.0, delay: 0.5, options: [.curveEaseInOut, .repeat, .autoreverse, .beginFromCurrentState], anim: {
            self.redView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.maxY)
            })
            .chain(withDuration: 2.0, delay: 0.5, options: [.curveEaseIn]) {
                self.redView.transform = CGAffineTransform(scaleX: 2, y: 2)
            }
            .animate() // start the animations
    }

    fileprivate func startAction2() {

        /// Sample with 3 chained steps reproducing in different ways the same animation
        UIView.AChain()

            // All animations between each chain step are executed simultaneously

            // Chain step 1 : Sample with custom animation closure
            .chain(withDuration: 0.5, options: [.curveEaseIn]) {
                var transform = CATransform3DTranslate(self.redView.layer.transform, 100, 35, 0)
                transform = CATransform3DRotate(transform, 30, 0.0, 0.0, 1.0)
                self.redView.layer.transform = transform
            }

            // Chain step 2 : Sample animation closure with helper methods
            .chain(withDuration: 1.5) {
                self.redView.move(by: [100, 35])
                self.redView.rotate(by: 30)
            }

            // Chain step 3 : Sample with helper methods only
            .chain(withDuration: 3.0, delay: 0.5, options: [.curveEaseOut])
            .move(self.redView.layer, by: [100, 35])
            .rotate(self.redView.layer, by: 30)
//            .rotate(label3.layer, by: -90.degreesToRadians)

            // .chain(...)
            // [...]

            .animate()

    }

    fileprivate func startAction3() {

        /// Sample with an optional reference needed to cancel the animation
//        activeChain = UIView
//            .chainAnimate(withDuration: 1.0)
//            .move(self.redView.layer, by: [100, 35])
//            .rotate(self.redView.layer, by: 30)
//
//            .chain(withDuration: 1.5)
////            .move(self.redView.layer, by: [100, 35]) //FIXME: not animated !
//            .rotate(self.redView.layer, by: 30)
//
//            .chain(withDuration: 3.0, delay: 0.5, options: [.curveEaseOut])
//            .move(self.redView.layer, by: [100, 35])
////            .rotate(self.redView.layer, by: 30)
//
//            .cancelCompletion { self.showVanishing(message: "Animation canceled") }  //FIXME: not called !
//
//        // [...]
//
//        activeChain?.animate()
        // [...]
//        activeChain?.cancel() // stop the animation, at the end of the current executing chain step

//        var t = self.redView.transform

        UIView.animate(withDuration: 1.0, animations: {
            self.view.setNeedsLayout()
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
            self.redView.setNeedsLayout()
            self.redView.setNeedsDisplay()
            self.redView.layoutIfNeeded()
//            self.redView.transform = CGAffineTransform.identity
            self.redView.transform = self.redView.transform.translatedBy(x: 30, y: 50)
//            t = t.translatedBy(x: 30, y: 50)
//            self.redView.transform = t
            self.view.setNeedsLayout()
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
            self.redView.setNeedsLayout()
            self.redView.setNeedsDisplay()
            self.redView.layoutIfNeeded()
        }) { (a) in
            self.view.setNeedsLayout()
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
            self.redView.setNeedsLayout()
            self.redView.setNeedsDisplay()
            self.redView.layoutIfNeeded()
            self.redView.transform = self.redView.transform.inverted()
            UIView.animate(withDuration: 1.0, animations: {
                self.view.setNeedsLayout()
                self.view.setNeedsDisplay()
                self.view.layoutIfNeeded()
                self.redView.setNeedsLayout()
                self.redView.setNeedsDisplay()
                self.redView.layoutIfNeeded()
                    self.redView.frame = self.redView.frame
//                self.redView.transform = CGAffineTransform.identity
                self.redView.transform = CGAffineTransform(rotationAngle: 45.degreesToRadians)
//                t = t.rotated(by: 45.degreesToRadians)
//                self.redView.transform = t
                self.view.setNeedsLayout()
                self.view.setNeedsDisplay()
                self.view.layoutIfNeeded()
                self.redView.setNeedsLayout()
                self.redView.setNeedsDisplay()
                self.redView.layoutIfNeeded()
            }) //, completion: { a in self.redView.transform = CGAffineTransform.identity })
        }
    }
}


// MARK: Cancel and reset actions

extension DemoAChain {

    @IBAction func startStopAction(_ sender: Any) {
        if let chain = activeChain, !chain.isCancelled {
            cancelAction()
        }
        else {
            startAction3()
        }
    }

    func cancelAction() {
        showVanishing(message: "Cancelling animation...")
        activeChain?.cancel() ?? showVanishing(message: "No active animation detected...")
    }

    @IBAction func resetAction(_ sender: Any) {
        showVanishing(message: "Reseting animation...")
        activeChain?.cancel() ?? showVanishing(message: "No active animation detected...")
        self.redView.reset()
    }
}


// MARK: A little message for clarity

extension DemoAChain {
    fileprivate func showVanishing(message: String) {
        AChain.showVanishing(message: message, in: view, at: [50, 500])
    }
}


