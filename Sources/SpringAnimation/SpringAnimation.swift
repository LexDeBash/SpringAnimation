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
}

public final class SpringAnimation {
    private unowned var view: Springable
    private var shouldAnimateAfterActive = false
    private var shouldAnimateInLayoutSubviews = true
    
    init(view: Springable) {
        self.view = view
        commonInit()
    }
    
    public func customAwakeFromNib() {
        if view.autohide {
            view.alpha = 0
        }
    }
    
    public func customLayoutSubviews() {
        if shouldAnimateInLayoutSubviews {
            shouldAnimateInLayoutSubviews = false
            if view.autostart {
                if UIApplication.shared.applicationState != .active {
                    shouldAnimateAfterActive = true
                    return
                }
                view.alpha = 0
                view.animate()
            }
        }
    }
    
    private func commonInit() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didBecomeActiveNotification),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc private func didBecomeActiveNotification(_ notification: NSNotification) {
        if shouldAnimateAfterActive {
            view.alpha = 0
            view.animate()
            shouldAnimateAfterActive = false
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func animationPreset() {
        view.alpha = 0.99
        if let animation = AnimationPreset(rawValue: view.animation) {
            switch animation {
            case .slideLeft:
                view.x = 300 * view.force
            case .slideRight:
                view.x = -300 * view.force
            case .slideDown:
                view.y = -300 * view.force
            case .slideUp:
                view.y = 300 * view.force
            case .squeezeLeft:
                view.x = 300
                view.scaleX = 3 * view.force
            case .squeezeRight:
                view.x = -300
                view.scaleX = 3 * view.force
            case .squeezeDown:
                view.y = -300
                view.scaleY = 3 * view.force
            case .squeezeUp:
                view.y = 300
                view.scaleY = 3 * view.force
            case .fadeIn:
                view.opacity = 0
            case .fadeOut:
                view.animateFrom = false
                view.opacity = 0
            case .fadeOutIn:
                let animation = CABasicAnimation()
                animation.keyPath = "opacity"
                animation.fromValue = 1
                animation.toValue = 0
                animation.timingFunction = getTimingFunction(with: view.curve)
                animation.duration = CFTimeInterval(view.duration)
                animation.beginTime = CACurrentMediaTime() + CFTimeInterval(view.delay)
                animation.autoreverses = true
                view.layer.add(animation, forKey: "fade")
            case .fadeInLeft:
                view.opacity = 0
                view.x = 300 * view.force
            case .fadeInRight:
                view.x = -300 * view.force
                view.opacity = 0
            case .fadeInDown:
                view.y = -300 * view.force
                view.opacity = 0
            case .fadeInUp:
                view.y = 300 * view.force
                view.opacity = 0
            case .zoomIn:
                view.opacity = 0
                view.scaleX = 2 * view.force
                view.scaleY = 2 * view.force
            case .zoomOut:
                view.animateFrom = false
                view.opacity = 0
                view.scaleX = 2 * view.force
                view.scaleY = 2 * view.force
            case .fall:
                view.animateFrom = false
                view.rotate = 15 * (CGFloat.pi / 180)
                view.y = 600 * view.force
            case .shake:
                let animation = CAKeyframeAnimation()
                animation.keyPath = "position.x"
                animation.values = [0,3 * view.force, -30 * view.force, 30 * view.force, 0]
                animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                animation.timingFunction = getTimingFunction(with: view.curve)
                animation.duration = CFTimeInterval(view.duration)
                animation.isAdditive = true
                animation.repeatCount = view.repeatCount
                animation.beginTime = CACurrentMediaTime() + CFTimeInterval(view.delay)
                view.layer.add(animation, forKey: "shake")
            case .pop:
                let animation = CAKeyframeAnimation()
                animation.keyPath = "transform.scale"
                animation.values = [0, 0.2 * view.force, -0.2 * view.force, 0.2 * view.force, 0]
                animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                animation.timingFunction = getTimingFunction(with: view.curve)
                animation.duration = CFTimeInterval(view.duration)
                animation.isAdditive = true
                animation.repeatCount = view.repeatCount
                animation.beginTime = CACurrentMediaTime() + CFTimeInterval(view.delay)
                view.layer.add(animation, forKey: "pop")
            case .flipX:
                view.rotate = 0
                view.scaleX = 1
                view.scaleY = 1
                var perspective = CATransform3DIdentity
                perspective.m34 = -1.0 / view.layer.frame.size.width / 2
                
                let animation = CABasicAnimation()
                animation.keyPath = "transform"
                animation.fromValue = NSValue(caTransform3D: CATransform3DMakeRotation(0, 0, 0, 0))
                animation.toValue = NSValue(
                    caTransform3D: CATransform3DConcat(
                        perspective,
                        CATransform3DMakeRotation(CGFloat.pi, 0, 1, 0)
                    )
                )
                animation.duration = CFTimeInterval(view.duration)
                animation.repeatCount = view.repeatCount
                animation.beginTime = CACurrentMediaTime() + CFTimeInterval(view.delay)
                animation.timingFunction = getTimingFunction(with: view.curve)
                view.layer.add(animation, forKey: "3d")
            case .flipY:
                var perspective = CATransform3DIdentity
                perspective.m34 = -1.0 / view.layer.frame.size.width / 2
                
                let animation = CABasicAnimation()
                animation.keyPath = "transform"
                animation.fromValue = NSValue(caTransform3D: CATransform3DMakeRotation(0, 0, 0, 0))
                animation.toValue = NSValue(
                    caTransform3D: CATransform3DConcat(
                        perspective,
                        CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0)
                    )
                )
                animation.duration = CFTimeInterval(view.duration)
                animation.repeatCount = view.repeatCount
                animation.beginTime = CACurrentMediaTime() + CFTimeInterval(view.delay)
                animation.timingFunction = getTimingFunction(with: view.curve)
                view.layer.add(animation, forKey: "3d")
            case .morph:
                let morphX = CAKeyframeAnimation()
                morphX.keyPath = "transform.scale.x"
                morphX.values = [1, 1.3 * view.force, 0.7, 1.3 * view.force, 1]
                morphX.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                morphX.timingFunction = getTimingFunction(with: view.curve)
                morphX.duration = CFTimeInterval(view.duration)
                morphX.repeatCount = view.repeatCount
                morphX.beginTime = CACurrentMediaTime() + CFTimeInterval(view.delay)
                view.layer.add(morphX, forKey: "morphX")
                
                let morphY = CAKeyframeAnimation()
                morphY.keyPath = "transform.scale.y"
                morphY.values = [1, 0.7, 1.3 * view.force, 0.7, 1]
                morphY.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                morphY.timingFunction = getTimingFunction(with: view.curve)
                morphY.duration = CFTimeInterval(view.duration)
                morphY.repeatCount = view.repeatCount
                morphY.beginTime = CACurrentMediaTime() + CFTimeInterval(view.delay)
                view.layer.add(morphY, forKey: "morphY")
            case .squeeze:
                let morphX = CAKeyframeAnimation()
                morphX.keyPath = "transform.scale.x"
                morphX.values = [1, 1.5 * view.force, 0.5, 1.5 * view.force, 1]
                morphX.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                morphX.timingFunction = getTimingFunction(with: view.curve)
                morphX.duration = CFTimeInterval(view.duration)
                morphX.repeatCount = view.repeatCount
                morphX.beginTime = CACurrentMediaTime() + CFTimeInterval(view.delay)
                view.layer.add(morphX, forKey: "morphX")
                
                let morphY = CAKeyframeAnimation()
                morphY.keyPath = "transform.scale.y"
                morphY.values = [1, 0.5, 1, 0.5, 1]
                morphY.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                morphY.timingFunction = getTimingFunction(with: view.curve)
                morphY.duration = CFTimeInterval(view.duration)
                morphY.repeatCount = view.repeatCount
                morphY.beginTime = CACurrentMediaTime() + CFTimeInterval(view.delay)
                view.layer.add(morphY, forKey: "morphY")
            case .flash:
                let animation = CABasicAnimation()
                animation.keyPath = "opacity"
                animation.fromValue = 1
                animation.toValue = 0
                animation.duration = CFTimeInterval(view.duration)
                animation.repeatCount = view.repeatCount * 2.0
                animation.autoreverses = true
                animation.beginTime = CACurrentMediaTime() + CFTimeInterval(view.delay)
                view.layer.add(animation, forKey: "flash")
            case .wobble:
                let animation = CAKeyframeAnimation()
                animation.keyPath = "transform.rotation"
                animation.values = [0, 0.3 * view.force, -0.3 * view.force, 0.3 * view.force, 0]
                animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                animation.duration = CFTimeInterval(view.duration)
                animation.isAdditive = true
                animation.beginTime = CACurrentMediaTime() + CFTimeInterval(view.delay)
                view.layer.add(animation, forKey: "wobble")
                
                let x = CAKeyframeAnimation()
                x.keyPath = "position.x"
                x.values = [0, 30 * view.force, -30 * view.force, 30 * view.force, 0]
                x.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                x.timingFunction = getTimingFunction(with: view.curve)
                x.duration = CFTimeInterval(view.duration)
                x.isAdditive = true
                x.repeatCount = view.repeatCount
                x.beginTime = CACurrentMediaTime() + CFTimeInterval(view.delay)
                view.layer.add(x, forKey: "x")
            case .swing:
                let animation = CAKeyframeAnimation()
                animation.keyPath = "transform.rotation"
                animation.values = [0, 0.3 * view.force, -0.3 * view.force, 0.3 * view.force, 0]
                animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                animation.duration = CFTimeInterval(view.duration)
                animation.isAdditive = true
                animation.repeatCount = view.repeatCount
                animation.beginTime = CACurrentMediaTime() + CFTimeInterval(view.delay)
                view.layer.add(animation, forKey: "swing")
            }
        }
    }
    
    func setView(completion: @escaping() -> Void) {
        if view.animateFrom {
            let translate = CGAffineTransform(translationX: view.x, y: view.y)
            let scale = CGAffineTransform(scaleX: view.scaleX, y: view.scaleY)
            let rotate = CGAffineTransform(rotationAngle: view.rotate)
            let translateAndScale = translate.concatenating(scale)
            view.transform = rotate.concatenating(translateAndScale)
            
            view.alpha = view.opacity
        }
        
        UIView.animate(
            withDuration: TimeInterval(view.duration),
            delay: TimeInterval(view.delay),
            usingSpringWithDamping: view.damping,
            initialSpringVelocity: view.velocity,
            options: [
                getAnimationOptions(with: view.curve),
                UIView.AnimationOptions.allowUserInteraction
            ],
            animations: { [weak self] in
                guard let self = self else { return }
                if self.view.animateFrom {
                    self.view.transform = CGAffineTransform.identity
                    self.view.alpha = 1
                } else {
                    let translate = CGAffineTransform(translationX: self.view.x, y: self.view.y)
                    let scale = CGAffineTransform(scaleX: self.view.scaleX, y: self.view.scaleY)
                    let rotate = CGAffineTransform(rotationAngle: self.view.rotate)
                    let translateAndScale = translate.concatenating(scale)
                    self.view.transform = rotate.concatenating(translateAndScale)
                    self.view.alpha = self.view.opacity
                }
            },
            completion: { [weak self] _ in
                completion()
                self?.resetAll()
            }
        )
        
    }
    
    private func getTimingFunction(with curve: String) -> CAMediaTimingFunction {
        if let curve = AnimationCurve(rawValue: curve) {
            switch curve {
            case .easeIn: return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            case .easeOut: return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            case .easeInOut: return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            case .linear: return CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            case .spring: return CAMediaTimingFunction(controlPoints: 0.5, 1.1 + Float(view.force / 3), 1, 1)
            case .easeInSine: return CAMediaTimingFunction(controlPoints: 0.47, 0, 0.745, 0.715)
            case .easeOutSine: return CAMediaTimingFunction(controlPoints: 0.39, 0.575, 0.565, 1)
            case .easeInOutSine: return CAMediaTimingFunction(controlPoints: 0.445, 0.05, 0.55, 0.95)
            case .easeInQuad: return CAMediaTimingFunction(controlPoints: 0.55, 0.085, 0.68, 0.53)
            case .easeOutQuad: return CAMediaTimingFunction(controlPoints: 0.25, 0.46, 0.45, 0.94)
            case .easeInOutQuad: return CAMediaTimingFunction(controlPoints: 0.455, 0.03, 0.515, 0.955)
            case .easeInCubic: return CAMediaTimingFunction(controlPoints: 0.55, 0.055, 0.675, 0.19)
            case .easeOutCubic: return CAMediaTimingFunction(controlPoints: 0.215, 0.61, 0.355, 1)
            case .easeInOutCubic: return CAMediaTimingFunction(controlPoints: 0.645, 0.045, 0.355, 1)
            case .easeInQuart: return CAMediaTimingFunction(controlPoints: 0.895, 0.03, 0.685, 0.22)
            case .easeOutQuart: return CAMediaTimingFunction(controlPoints: 0.165, 0.84, 0.44, 1)
            case .easeInOutQuart: return CAMediaTimingFunction(controlPoints: 0.77, 0, 0.175, 1)
            case .easeInQuint: return CAMediaTimingFunction(controlPoints: 0.755, 0.05, 0.855, 0.06)
            case .easeOutQuint: return CAMediaTimingFunction(controlPoints: 0.23, 1, 0.32, 1)
            case .easeInOutQuint: return CAMediaTimingFunction(controlPoints: 0.86, 0, 0.07, 1)
            case .easeInExpo: return CAMediaTimingFunction(controlPoints: 0.95, 0.05, 0.795, 0.035)
            case .easeOutExpo: return CAMediaTimingFunction(controlPoints: 0.19, 1, 0.22, 1)
            case .easeInOutExpo: return CAMediaTimingFunction(controlPoints: 1, 0, 0, 1)
            case .easeInCirc: return CAMediaTimingFunction(controlPoints: 0.6, 0.04, 0.98, 0.335)
            case .easeOutCirc: return CAMediaTimingFunction(controlPoints: 0.075, 0.82, 0.165, 1)
            case .easeInOutCirc: return CAMediaTimingFunction(controlPoints: 0.785, 0.135, 0.15, 0.86)
            case .easeInBack: return CAMediaTimingFunction(controlPoints: 0.6, -0.28, 0.735, 0.045)
            case .easeOutBack: return CAMediaTimingFunction(controlPoints: 0.175, 0.885, 0.32, 1.275)
            case .easeInOutBack: return CAMediaTimingFunction(controlPoints: 0.68, -0.55, 0.265, 1.55)
            }
        }
        return CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
    }
    
    private func getAnimationOptions(with curve: String) -> UIView.AnimationOptions {
        if let curve = AnimationCurve(rawValue: curve) {
            switch curve {
            case .easeIn: return UIView.AnimationOptions.curveEaseIn
            case .easeOut: return UIView.AnimationOptions.curveEaseOut
            case .easeInOut: return UIView.AnimationOptions()
            default: break
            }
        }
        return UIView.AnimationOptions.curveLinear
    }
    
    private func resetAll() {
        view.x = 0
        view.y = 0
        view.animation = ""
        view.opacity = 1
        view.scaleX = 1
        view.scaleY = 1
        view.rotate = 0
        view.damping = 0.7
        view.velocity = 0.7
        view.repeatCount = 1
        view.delay = 0
        view.duration = 0.7
    }
}
