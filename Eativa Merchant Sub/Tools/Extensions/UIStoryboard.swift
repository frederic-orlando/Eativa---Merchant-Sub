//
//  UIStoryboard.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 29/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    static func getController(from storyboard: String, withIdentifier id: String) -> UIViewController{
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: id)
        
        return vc
    }
}
