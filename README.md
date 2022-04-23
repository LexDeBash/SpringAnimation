# SpringAnimation

## Requirements
Requires Xcode 13 and Swift 5.6

## Installation
### Swift Package Manager
Copy framework url to clipboard:

![image](https://user-images.githubusercontent.com/18059014/164895275-4f3ece51-f201-4c92-9a14-f5e49607eedb.png)

Open your project in Xcode and go to the "Frameworks, Libraries and Embedded Content" section in the general project settings, then click on the add new library button:

![image](https://user-images.githubusercontent.com/18059014/164894607-c9b92f73-b900-4d9b-ab28-0b7d475eab5b.png)

Then select "Add Other..." -> "Add Package Dependency...":

![image](https://user-images.githubusercontent.com/18059014/164894764-2c961e46-1d0b-4b8d-9e08-7b47f43e63ca.png)

In the window that opens, go to the search bar and paste the url ```https://github.com/LexDeBash/SpringAnimation.git```
Then press the button "Add Package":

![image](https://user-images.githubusercontent.com/18059014/164895127-a6e388b6-4bdb-4fa8-a232-21ad7aff1ab7.png)

In the package selection window, check the SptingAnimation and press "Add Package":

![image](https://user-images.githubusercontent.com/18059014/164895029-a2c066e5-38c4-4826-b1f7-4775b03ac05c.png)


## Usage with Storyboard
In Identity Inspector, connect the UIView to SpringView Class and set the animation properties in Attribute Inspector.

![image](https://user-images.githubusercontent.com/18059014/164895509-feb27e48-23ad-41bf-b435-67fde2c3c2f8.png)

## Usage with Code
    springView.animation = "squeezeDown"
    springView.animate()

## Chaining Animations
    springView.y = -50
    animateToNext {
      springView.animation = "fall"
      springView.animateTo()
    }

## Functions
    animate()
    animateNext { ... }
    animateTo()
    animateToNext { ... }

## Animations
    pop
    slideLeft
    slideRight
    slideDown
    slideUp
    squeezeLeft
    squeezeRight
    squeezeDown
    squeezeUp
    fadeIn
    fadeOut
    fadeOutIn
    fadeInLeft
    fadeInRight
    fadeInDown
    fadeInUp
    zoomIn
    zoomOut
    fall
    shake
    flipX
    flipY
    morph
    squeeze
    flash
    wobble
    swing

## Curves
    easeIn
    easeOut
    easeInOut
    linear
    spring
    easeInSine
    easeOutSine
    easeInOutSine
    easeInQuad
    easeOutQuad
    easeInOutQuad
    easeInCubic
    easeOutCubic
    easeInOutCubic
    easeInQuart
    easeOutQuart
    easeInOutQuart
    easeInQuint
    easeOutQuint
    easeInOutQuint
    easeInExpo
    easeOutExpo
    easeInOutExpo
    easeInCirc
    easeOutCirc
    easeInOutCirc
    easeInBack
    easeOutBack
    easeInOutBack

## Properties
    autostart
    autohide

    title
    curve

    force
    delay
    duration
    damping
    velocity
    repeatCount
    x
    y
    scaleX
    scaleY
    scale
    rotate

## Autostart
Allows you to animate without code. Don't need to use this if you plan to start the animation in code.

## Autohide
Saves you the hassle of adding a line "springView.alpha = 0" in viewDidLoad().

## Known issue


## License

