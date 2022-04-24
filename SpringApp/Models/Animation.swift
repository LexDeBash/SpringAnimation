//
//  Animation.swift
//  SpringApp
//
//  Created by Alexey Efimov on 16.04.2022.
//

import Foundation

struct Animation {
    var autostart: Bool
    var autohide: Bool
    
    var title: String
    var curve: String
    
    var force: Double
    var delay: Double
    var duration: Double
    var damping: Double
    var velocity: Double
    var repeatCount: Float
    var x: Double
    var y: Double
    var scaleX: Double
    var scaleY: Double
    var scale: Double
    var rotate: Double
    
    static func getDefaultValues() -> Animation {
        Animation(
            autostart: false,
            autohide: false,
            title: "pop",
            curve: "easeInt",
            force: 1,
            delay: 0,
            duration: 0.7,
            damping: 0.7,
            velocity: 0.7,
            repeatCount: 1,
            x: 1,
            y: 1,
            scaleX: 1,
            scaleY: 1,
            scale: 1,
            rotate: 0
        )
    }
}
