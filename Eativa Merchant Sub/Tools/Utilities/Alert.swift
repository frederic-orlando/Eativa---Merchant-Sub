//
//  Alert.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 28/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    static func showYesNoAlert(on vc: UIViewController, with title: String, message: String, yesAction: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            yesAction()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
    static func showErrorAlert(on vc: UIViewController, title: String, retryAction: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (_) in
            retryAction()
        }))
        
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
    static func showOKAlert(on vc: UIViewController, title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
}
