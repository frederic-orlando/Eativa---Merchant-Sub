//
//  UITableView.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 28/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func reloadDataWithSelection() {
        let selectedRow = indexPathForSelectedRow
        
        reloadData()
        
        selectRow(at: selectedRow, animated: false, scrollPosition: .none)
    }
    
    func scrollToBottom() {
        let maxContentOffsetY = contentSize.height - frame.height + contentInset.bottom
        setContentOffset(CGPoint(x: 0, y: maxContentOffsetY), animated: true)
    } 
}
