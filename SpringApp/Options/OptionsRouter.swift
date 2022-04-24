//
//  OptionsRouter.swift
//  SpringApp
//
//  Created by Alexey Efimov on 17.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol OptionsRoutingLogic {
    
}

protocol OptionsDataPassing {
    var dataStore: OptionsDataStore? { get }
}

class OptionsRouter: NSObject, OptionsRoutingLogic, OptionsDataPassing {
    
    weak var viewController: OptionsViewController?
    var dataStore: OptionsDataStore?
}