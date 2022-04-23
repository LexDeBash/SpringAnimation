//
//  File.swift
//  
//
//  Created by Alexey Efimov on 22.04.2022.
//

import UIKit

/// Animation options
public protocol Springable: AnyObject {
    // Animation properties
    /// Automatic animation start
    var autostart: Bool { get set }
    /// Hides the view
    var autohide: Bool { get set }
    /// Animation name
    var animation: String  { get set }
    /// The of animation
    var force: CGFloat  { get set }
    /// The delay (in seconds) after which the animations begin.
    ///
    /// The default value of this property is 0. When the value is greater than 0, the start of any animations is delayed by the specified amount of time.
    var delay: CGFloat { get set }
    /// The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
    var duration: CGFloat { get set }
    /// Defines how the spring’s motion should be damped due to the forces of friction.
    var damping: CGFloat { get set }
    /// The initial velocity of the object attached to the spring.
    var velocity: CGFloat { get set }
    /// Determines the number of times the animation will repeat.
    var repeatCount: Float { get set }
    /// The x-coordinate of the point.
    var x: CGFloat { get set }
    /// The y-coordinate of the point.
    var y: CGFloat { get set }
    /// A value function scales by the input value along the x-axis. Animations referencing this value transform function must provide a single animation value.
    var scaleX: CGFloat { get set }
    /// A value function scales by the input value along the y-axis. Animations referencing this value function must provide a single animation value.
    var scaleY: CGFloat { get set }
    /// Object rotation
    var rotate: CGFloat { get set }
    ///The opacity of the receiver. Animatable.
    ///
    ///The value of this property must be in the range 0.0 (transparent) to 1.0 (opaque). Values outside that range are clamped to the minimum or maximum. The default value of this property is 1.0.
    var opacity: CGFloat { get set }
    var animateFrom: Bool { get set }
    /// Animation preset
    var curve: String { get set }
    
    // UIView
    var layer : CALayer { get }
    var transform : CGAffineTransform { get set }
    var alpha : CGFloat { get set }
    
    /// Run the animation with the given parameters
    func animate()
    /// Run next animation after complete current animation
    func animateNext(completion: @escaping() -> Void)
    
    func animateTo()
    
    func animateToNext(completion: @escaping () -> ())
}
