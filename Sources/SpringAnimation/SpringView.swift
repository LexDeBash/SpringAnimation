//
//  File.swift
//  
//
//  Created by Alexey Efimov on 13.04.2022.
//

import UIKit

open class SpringView: UIView, Springable {
    @IBInspectable public var autostart: Bool = false
    @IBInspectable public var autohide: Bool = false
    @IBInspectable public var animation: String = ""
    @IBInspectable public var force: CGFloat = 1
    @IBInspectable public var delay: CGFloat = 0
    @IBInspectable public var duration: CGFloat = 0.7
    @IBInspectable public var damping: CGFloat = 0.7
    @IBInspectable public var velocity: CGFloat = 0.7
    @IBInspectable public var repeatCount: Float = 1
    @IBInspectable public var x: CGFloat = 0
    @IBInspectable public var y: CGFloat = 0
    @IBInspectable public var scaleX: CGFloat = 1
    @IBInspectable public var scaleY: CGFloat = 1
    @IBInspectable public var rotate: CGFloat = 0
    @IBInspectable public var curve: String = ""
    public var opacity: CGFloat = 1
    public var animateFrom: Bool = false
    
    lazy private var springAnimation = SpringAnimation(view: self)
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        springAnimation.customAwakeFromNib()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        springAnimation.customLayoutSubviews()
    }
    
    public func animate() {
        animateFrom = true
        springAnimation.animationPreset()
        springAnimation.setView {}
    }
    
    public func animateNext(completion: @escaping() -> Void) {
        animateFrom = true
        springAnimation.animationPreset()
        springAnimation.setView {
            completion()
        }
    }
    
    public func animateTo() {
        animateFrom = false
        springAnimation.animationPreset()
        springAnimation.setView {}
    }
    
    public func animateToNext(completion: @escaping () -> ()) {
        animateFrom = false
        springAnimation.animationPreset()
        springAnimation.setView {
            completion()
        }
    }
}
