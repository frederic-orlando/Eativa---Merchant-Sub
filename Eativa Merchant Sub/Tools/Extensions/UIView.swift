//
//  UIView.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 04/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func fitTo(view : UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self)
        
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
       let animation = CABasicAnimation(keyPath: "transform.rotation")
       animation.toValue = toValue
       animation.duration = duration
       animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
       self.layer.add(animation, forKey: nil)
    }
    
}
