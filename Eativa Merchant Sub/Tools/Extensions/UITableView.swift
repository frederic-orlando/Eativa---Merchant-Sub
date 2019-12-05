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
    var isScrollable : Bool {
        if self.contentSize.height > self.frame.height - self.contentInset.bottom{
            return true
        }
        else {
            return false
        }
    }
    func reloadDataWithSelection() {
        let selectedRow = indexPathForSelectedRow
        
        reloadData()
        
        selectRow(at: selectedRow, animated: false, scrollPosition: .none)
    }
    
    func scrollToBottom() {
        let maxContentOffsetY = contentSize.height - frame.height + contentInset.bottom
        setContentOffset(CGPoint(x: 0, y: maxContentOffsetY), animated: true)
    }
    
    func scrollToTop() {
        self.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
}
