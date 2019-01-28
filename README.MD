![AChain: Easy chaining Swift animations](https://raw.githubusercontent.com/Macistador/AChain/master/Ressources/AChain-logo.png)

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/AChain.svg)](https://img.shields.io/cocoapods/v/AChain.svg)
[![Platform](https://img.shields.io/cocoapods/p/AChain.svg?style=flat)](https://macistador.github.io/AChain)

AChain is a lightweight, syntax-similar to default UIKit, yet powerful animation lib in Swift.
This project is made for simplicity, ease of use and ease of read
![demo](https://raw.githubusercontent.com/Macistador/AChain/master/Ressources/AChain-demo.gif)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Features

- [x] Chainable animations
- [x] Very close to the UIView.animate(...) native API
- [x] Builtin elementary animations (move, rotate, scale, alpha)
- [x] ...
- [x] ...

## Requirements

- iOS 10.0+
- Xcode 10.2+
- Swift 4.2+

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate AChain into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'AChain', '~> 0.0.1'
```

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate AChain into your project manually.

## Usage

### This is how you would do some chained animations with raw UIKit

Classic method 1 with __raw UIKit__
```swift
   UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseIn], animations: {
       var transform = CATransform3DTranslate(view.layer.transform, 100, 35, 0)
       transform = CATransform3DRotate(transform, 30, 0.0, 0.0, 1.0)
       view.layer.transform = transform
   }) { _ in

       UIView.animate(withDuration: 3.0, delay: 0, options: [.curveEaseIn], animations: {
           var transform = CATransform3DTranslate(view.layer.transform, 100, 35, 0)
           transform = CATransform3DRotate(transform, 30, 0.0, 0.0, 1.0)
           view.layer.transform = transform
       }) { _ in

           UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseIn], animations: {
               var transform = CATransform3DTranslate(view.layer.transform, 100, 35, 0)
               transform = CATransform3DRotate(transform, 30, 0.0, 0.0, 1.0)
               view.layer.transform = transform
           })
       }
   }
```

Classic method 2 with __raw UIKit__
```swift
   UIView.animateKeyframes(withDuration: 5, delay: 0, options: .calculationModeCubic, animations: {
       UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
           view.transform = CGAffineTransform(scaleX: 2, y: 2)
       }

       UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
           view.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.maxY)
       }

       UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25) {
           view.center = CGPoint(x: self.view.bounds.width, y: self.view.bounds.height)
       }
   })
```


### Now let's have a look at how *AChain* can make your code cleaner and easier to read :

First sample with 3 chained steps reproducing the same animation in different ways
```swift
// Chain step 1 : Sample with custom animation closure
UIView.chainAnimate(withDuration: 1.0, delay: 0.5, options: [.curveEaseIn], anim: {
       // Any animation code as usual...
        var transform = CATransform3DTranslate(view.layer.transform, 100, 35, 0)
        transform = CATransform3DRotate(transform, 30, 0.0, 0.0, 1.0)
        view.layer.transform = transform
    })

    // Chain step 2 : Sample animation closure with helper methods
    .chain(withDuration: 1.5) {
        view.move(by: [100, 35])
        view.rotate(by: 30)
    }

    // Chain step 3 : Sample with helper methods only
    .chain(withDuration: 3.0, delay: 0.5, options: [.curveEaseOut])
    .move(view.layer, by: [100, 35])
    .rotate(view.layer, by: 30)

    // repeat...
    // .chain(  )
    // [...]

    .animate()
```

> All animations between each chain step are executed simultaneously


By keeping a reference to the chain you can
- add more steps after the initial definition
- start the animation in a different moment
- cancel it anytime

```swift
activeChain = UIView
    .chainAnimate(withDuration: 1.0)
    .move(view.layer, by: [100, 35])
    .rotate(view.layer, by: 30)

    .chain(withDuration: 1.5)
    .move(view.layer, by: [100, 35])
    .rotate(view.layer, by: 30)

// [...]

activeChain = activeChain
    .chain(withDuration: 3.0, delay: 0.5, options: [.curveEaseOut])
    .move(view.layer, by: [100, 35])
    .rotate(view.layer, by: 30)

    .cancelCompletion { print("Animation canceled") }

// [...]

activeChain.animate()
// [...]
activeChain.cancel() // stop the animation, at the end of the current executing chain step
```

## License

AChain is released under the MIT license. [See LICENSE](https://github.com/macistador/achain/blob/master/LICENSE) for details.
