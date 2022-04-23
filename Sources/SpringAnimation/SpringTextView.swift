//
//  SpringTextView.swift
//  
//
//  Created by Alexey Efimov on 18.04.2022.
//

import UIKit

open class SpringTextView: UITextView, Springable {
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
    public var animateFrom = false
    
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
        springAnimation.animate()
    }
    
    public func animateNext(completion: @escaping() -> Void) {
        springAnimation.animateNext(completion: completion)
    }
    
    public func animateTo() {
        springAnimation.animateTo()
    }
    
    public func animateToNext(completion: @escaping () -> ()) {
        springAnimation.animateToNext(completion: completion)
    }
}
