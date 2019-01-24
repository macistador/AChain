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

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var PauseButton: UIButton!
    @IBOutlet weak var RevertButton: UIButton!

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

        UIView.AChain(duration: 1.0, delay: 0, options: [.curveEaseIn], identifier: "red")
            .chain(duration: 0.5) {
                var transform = CATransform3DTranslate(self.redView.layer.transform, 100, 35, 0)
                transform = CATransform3DRotate(transform, 30, 0.0, 0.0, 1.0)
                self.redView.layer.transform = transform
            }
            .chain(duration: 1.5) {
                var transform = CATransform3DTranslate(self.redView.layer.transform, 100, 35, 0)
                transform = CATransform3DRotate(transform, 30, 0.0, 0.0, 1.0)
                self.redView.layer.transform = transform
            }
            .chain(duration: 3.0, delay: 0.5, options: [.curveEaseIn], identifier: "demo") {
                var transform = CATransform3DTranslate(self.redView.layer.transform, 100, 35, 0)
                transform = CATransform3DRotate(transform, 30, 0.0, 0.0, 1.0)
                self.redView.layer.transform = transform
            }
            .animate()
    }
}


// MARK: Samples with AChain and helpers

extension DemoAChain {

    @IBAction func startAction000(_ sender: Any) {

        showVanishingMessage("Animation starts...")

        // Sample 1
        UIView.AChain()
            .chain(duration: 1.5) { self.redView.scale(by: 30) }
            .chain(duration: 0.5) { self.redView.move(by: [100,35]) }
            .chain(duration: 0.2) { self.redView.rotate(by: -30) }
            .animate()


        // Sample 2
        UIView.AChain()
            .chain(duration: 1.5) { self.redView.rotate(by: 30) }

            .chain(duration: 0.5, delay: 0.2) {
                self.redView.move(by: [100,35])
                self.redView.rotate(by: 30)
            }

            .chain(duration: 0.2, delay: 0.2, options: [.curveEaseInOut]) {
                self.redView.rotate(by: -30)
                /* ... */
            }

            .animate()
    }
}


extension DemoAChain {

    @IBAction func PauseAction(_ sender: Any) {

    }

    @IBAction func RevertAction(_ sender: Any) {


    }
}


// MARK: methods for the demo

extension DemoAChain {

    fileprivate func showVanishingMessage(_ message: String) {
        let label = UILabel()
        label.text = message
        label.frame = CGRect(x: 50, y: 500, width: 200, height: 50)
        view.addSubview(label)

        UIView.AChain(duration: 1.5).animation {
            label.move(by: CGPoint(x: 0, y: -80))
            label.alpha = 0.0
            }.completion{ _ in label.removeFromSuperview()}.animate()

        //    UIView.Animator(duration: 1.5).move(layer: label.layer, by: CGPoint(x: 0, y: -80))
        //      .completion{ _ in label.removeFromSuperview(); label.removeFromSuperview()}.animate()
    }
}


