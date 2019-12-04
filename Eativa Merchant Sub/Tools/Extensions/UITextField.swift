//
//  UITextField.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 01/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func addOneBtnToolBar(btnTitle: String, target: Any?, selector : Selector){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let button: UIBarButtonItem = UIBarButtonItem(title: btnTitle, style: .done, target: target, action: selector)
        let items = [flexSpace, button]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}
