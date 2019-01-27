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

    var blueView: UIView!
    var redView: UIView!
    var greenView: UIView!
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

        //    blueView = UIView()
        //    blueView.frame = CGRect(x: 235, y: 101, width: 93, height: 85)
        //    blueView.translatesAutoresizingMaskIntoConstraints = false
        //    blueView.backgroundColor = .blue
        //    view.addSubview(blueView)
        //
        //    greenView = UIView()
        //    greenView.frame = CGRect(x: 141, y: 235, width: 93, height: 85)
        //    greenView.translatesAutoresizingMaskIntoConstraints = false
        //    greenView.backgroundColor = .green
        //    view.addSubview(greenView)
    }
}


// MARK: Classic methods for doing simple chained animations

extension DemoAChain {

    @IBAction func startAction0(_ sender: Any) {

        showVanishingMessage("Animation starts...")

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


    }
}


// MARK: Same animations with AChain without helpers

extension DemoAChain {

    @IBAction func startAction(_ sender: Any) {

        showVanishingMessage("Animation starts...")

        // Sample with reference and cancel
        activeChain = UIView.AChain()
            .chain(withDuration: 0.5, options: [.curveEaseIn]) {
                var transform = CATransform3DTranslate(self.redView.layer.transform, 100, 35, 0)
                transform = CATransform3DRotate(transform, 30, 0.0, 0.0, 1.0)
                self.redView.layer.transform = transform
            }
            .chain(withDuration: 1.5) {
                var transform = CATransform3DTranslate(self.redView.layer.transform, 100, 35, 0)
                transform = CATransform3DRotate(transform, 30, 0.0, 0.0, 1.0)
                self.redView.layer.transform = transform
            }
            .chain(withDuration: 3.0, delay: 0.5, options: [.curveEaseOut]) {
                var transform = CATransform3DTranslate(self.redView.layer.transform, 100, 35, 0)
                transform = CATransform3DRotate(transform, 30, 0.0, 0.0, 1.0)
                self.redView.layer.transform = transform
            }
            .cancelCompletion {
                self.showVanishingMessage("Animation canceled")
        }

        activeChain?.animate()
    }
}


// MARK: Samples with AChain and helpers

extension DemoAChain {

    @IBAction func startAction000(_ sender: Any) {

        showVanishingMessage("Animation starts...")

        // Sample 1
        // ....
        UIView.AChain()
            .chain(withDuration: 1.5) { self.redView.scale(by: 30) }
            .chain(withDuration: 0.5) { self.redView.move(by: [100,35]) }
            .chain(withDuration: 0.2) { self.redView.rotate(by: -30) }
            .animate()

        // Sample 2 with separate declaration and start
        UIView.AChain()
            .chain(withDuration: 1.5) { self.redView.rotate(by: 30) }

            .chain(withDuration: 0.5, delay: 0.2) {
                self.redView.move(by: [100,35])
                self.redView.rotate(by: 30)
            }

            .chain(withDuration: 0.2, delay: 0.2, options: [.curveEaseInOut]) {
                self.redView.rotate(by: -30)
                /* ... */
            }
            .completion{ _ in
                // [...]
            }
            .animate()

        // Sample 3
        //
        UIView.AChain()
            // Step 1: define any animation you want to happen simultaneously
            .chain(withDuration: 0.5)
            .move(layer: self.redView.layer, by: [100,35])
            .alpha(view: self.redView, to: 0)

            // Step 2: define animations which will happen once the previous step is finished
            .chain(withDuration: 2.5)
            .move(layer: self.redView.layer, by: [100,35])
            .alpha(view: self.redView, to: 1)

            // Step 3 (with custom animation and delay)
            .chain(withDuration: 0.5, delay: 0.5) {
                // [...]
            }
            .animate()

        // Sample 4 with separate declaration and start
        // Declare the animation
        var chain = UIView.AChain()
            .chain(withDuration: 0.5) { self.redView.move(by: [100,35]) }

        // [...]

        // Add more animations to your chain if you need
        chain = chain.move(layer: self.redView.layer, by: [10, 0])

        // [...]

        // start the animation when you need it
        chain.animate()
    }
}


extension DemoAChain {

    @IBAction func CancelAction(_ sender: Any) {
        showVanishingMessage("Cancelling animation...")
        activeChain?.cancel() ?? showVanishingMessage("No active animation detected...")
    }

    @IBAction func ResetAction(_ sender: Any) {
        showVanishingMessage("Reseting animation...")
        activeChain?.cancel() ?? showVanishingMessage("No active animation detected...")
        self.redView.reset()
    }
}


// MARK: methods for the demo

extension DemoAChain {

    fileprivate func showVanishingMessage(_ message: String) {
        let label = UILabel()
        label.text = message
        label.frame = CGRect(x: 50, y: 500, width: 200, height: 50)
        view.addSubview(label)

//        UIView.chainAnimate(withDuration: 1.5, anim: {
//            label.move(by: CGPoint(x: 0, y: -80))
//            label.alpha = 0.0
//        })
//            .completion({ _ in label.removeFromSuperview()})
//            .animate()

        UIView
            // Step 1
            .AChain(withDuration: 1.5)
            .move(layer: label.layer, by: [0, -80])
            .alpha(view: label, to: 0)

//             Step 2
//            .chain(withDuration: 3.0)
//            .alpha(view: label, to: 1)
//            .rotate(layer: label.layer, by: 45)
//            .scale(layer: label.layer, to: [1.5, 1.5])

            // Completion
            .completion{ _ in label.removeFromSuperview()}
            .animate()
    }
}


