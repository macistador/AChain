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
    @IBOutlet weak var CancelButton: UIButton!
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

    @IBAction func startAction(_ sender: Any) {

        showVanishing(message: "Animation starts...")

        // Sample with an optional reference needed to cancel the animation
        activeChain = UIView.AChain()

            // All animations in between each "chain link" are executed simulatenously

            // Chain link 1 : Custom animation closure
            .chain(withDuration: 0.5, options: [.curveEaseIn]) {
                var transform = CATransform3DTranslate(self.redView.layer.transform, 100, 35, 0)
                transform = CATransform3DRotate(transform, 30, 0.0, 0.0, 1.0)
                self.redView.layer.transform = transform
            }

            // Chain link 2 : Animation closure with helper methods
            .chain(withDuration: 1.5) {
                self.redView.move(by: [100, 35])
                self.redView.rotate(by: 30)
            }

            // Chain link 3 : helper methods only
            .chain(withDuration: 3.0, delay: 0.5, options: [.curveEaseOut])
            .move(self.redView.layer, by: [100, 35])
            .rotate(self.redView.layer, by: 30)

            // [...]

            .cancelCompletion {
                self.showVanishing(message: "Animation canceled")
        }

        activeChain?.animate()
    }
}


// MARK: Cancel and reset actions

extension DemoAChain {

    @IBAction func CancelAction(_ sender: Any) {
        showVanishing(message: "Cancelling animation...")
        activeChain?.cancel() ?? showVanishing(message: "No active animation detected...")
    }

    @IBAction func ResetAction(_ sender: Any) {
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


