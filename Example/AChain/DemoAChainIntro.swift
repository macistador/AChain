//
//  DemoAChainIntro.swift
//  AChain
//
//  Created by Michel-Andre Chirita on 27/01/2019.
//  Copyright © 2019 PagesJaunes. All rights reserved.
//

import UIKit

/*
 AChain demo

 This class presents some animations with AChain

 */

final class DemoAChainIntro: UIViewController {

    lazy var referencePoints = ReferencePoints()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.subviews.forEach(clean)
    }

    func clean(_ view: UIView) {
        view.removeFromSuperview()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureViews()
    }

    /// Configuring the animable views
    private func configureViews() {

        let label1 = self.makeLabel(with: "Welcome")
        let label2 = self.makeLabel(with: "to this demo")
        let label3 = makeLabel(with: "AChain helps you")
        let label4 = makeLabel(with: "chaining animations")
        let label5 = makeLabel(with: "Have fun ;)")

        UIView
            .chainAnimate(withDuration: 3.0, delay: 1.0, options: [.curveEaseOut]) {
                label1.rotate(by: Float(90.degreesToRadians))
                label1.move(by: [0, 70])
                label1.alpha = 1
            }
            .chain(withDuration: 3.0, delay: 0)
            .alpha(label3, to: 1)
            .rotate(label3.layer, by: -90.degreesToRadians)
            .move(label3.layer, by: [-20, 50])

            .animate()

        UIView
            .AChain()
            .chain(withDuration: 3.0, delay: 2.0)
            .alpha(label2, to: 1)
            .rotate(label2.layer, by: 90.degreesToRadians)
            .move(label2.layer, by: [100, 120])

            .chain(withDuration: 3.0, delay: 0.5)
            .alpha(label4, to: 1)
            .rotate(label4.layer, by: -90.degreesToRadians)
            .move(label4.layer, by: [-100, 90])

            .chain(withDuration: 0)
            .move(label5.layer, by: [0, 250])

            .chain(withDuration: 4.0, options: [.curveEaseOut])
            .alpha(label5, to: 1)
            .move(label5.layer, by: [0, 100])
            .scale(label5.layer, to: [1.1, 1.1])

            .animate()

//        let colorView1 = makeView(with: .blue)
//        let colorView2 = makeView(with: .green)
//        let colorView3 = makeView(with: .green)
//        let colorView4 = makeView(with: .green)
//        let colorView5 = makeView(with: .green)

//        animation1(labelView: label1)
    }
}

// MARK: Samples with AChain and helpers

extension DemoAChainIntro {

    fileprivate func animation1(labelView: UIView) {

        // Sample 1
        // ....
        UIView.AChain()
            .chain(withDuration: 1.5) { labelView.scale(by: 30) }
            .chain(withDuration: 0.5) { labelView.move(by: [100,35]) }
            .chain(withDuration: 0.2) { labelView.rotate(by: -30) }
            .animate()
    }

    fileprivate func animation2(labelView: UIView) {

        // Sample 2 with separate declaration and start
        UIView.AChain()
            .chain(withDuration: 1.5) { labelView.rotate(by: 30) }

            .chain(withDuration: 0.5, delay: 0.2) {
                labelView.move(by: [100,35])
                labelView.rotate(by: 30)
            }

            .chain(withDuration: 0.2, delay: 0.2, options: [.curveEaseInOut]) {
                labelView.rotate(by: -30)
                /* ... */
            }
            .completion{ _ in
                // [...]
            }
            .animate()
    }

    fileprivate func animation3(labelView: UIView) {

        // Sample 3
        //
        UIView.AChain()
            // Step 1: define any animation you want to happen simultaneously
            .chain(withDuration: 0.5)
            .move(labelView.layer, by: [100,35])
            .alpha(labelView, to: 0)

            // Step 2: define animations which will happen once the previous step is finished
            .chain(withDuration: 2.5)
            .move(labelView.layer, by: [100,35])
            .alpha(labelView, to: 1)

            // Step 3 (with custom animation and delay)
            .chain(withDuration: 0.5, delay: 0.5) {
                // [...]
            }
            .animate()
    }

    fileprivate func animation4(labelView: UIView) {

        // Sample 4 with separate declaration and start
        // Declare the animation
        var chain = UIView.AChain()
            .chain(withDuration: 0.5) { labelView.move(by: [100,35]) }

        // [...]

        // Add more animations to your chain if you need
        chain = chain.move(labelView.layer, by: [10, 0])

        // [...]

        // start the animation when you need it
        chain.animate()
    }
}


// MARK: UI config

extension DemoAChainIntro {

    /// Shows a little message for clarity
    fileprivate func showVanishing(message: String) {
        AChain.showVanishing(message: message, in: view, at: [50, 500])
    }

    fileprivate func makeLabel(with message: String) -> UILabel {
        let label = UILabel()
        let width = (message.count > 30) ? 500 : 300
        label.frame = CGRect(x: 50, y: 200, width: width, height: 150)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 100, weight: .black)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        //        label.minimumScaleFactor = 0.1
        label.text = message
        label.alpha = 0
        view.addSubview(label)
        return label
    }

    fileprivate func makeView(with color: UIColor) -> UIView {
        let newView = UIView()
        newView.frame = CGRect(x: 0, y: 0, width: 93, height: 85)
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.backgroundColor = color
        view.addSubview(newView)
        return newView
    }

    /// @discuss: embed in the lib ?
    struct ReferencePoints {
        private let hMargin : CGFloat = 10
        private let vMargin : CGFloat = 20

        lazy var center: CGPoint = {
            return [UIScreen.main.bounds.midX, UIScreen.main.bounds.midY]
        }()
        lazy var topLeft: CGPoint = {
            return [hMargin, vMargin]
        }()
        lazy var bottomRight: CGPoint = {
            let right = UIScreen.main.bounds.width - hMargin * 2
            let bottom = UIScreen.main.bounds.height - vMargin * 2
            return [right, bottom]
        }()
    }
}

