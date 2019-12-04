//
//  UIApplication.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 29/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    static func changeRoot(to vc : UIViewController) {
        self.shared.windows.first?.rootViewController = vc
    }
}
