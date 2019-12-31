//
//  MenuCategoryViewModel.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 09/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation
import UIKit

protocol MenuCategoryCellDelegate {
    func didSelectCell(menu: Menu)
}

class MenuCategoryViewModel: NSObject {
    var vc : MenuCategoryViewController! {
        didSet {
            delegate = vc
        }
    }
    
    var delegate : MenuCategoryCellDelegate!
    
    var rowCount : Int {
        return menus.count
    }
    
    var menus : [Menu] = [] {
        didSet {
            self.didFinishFetch?()
        }
    }
    
    var errorString : String? {
        didSet {
            self.showAlertClosure?()
        }
    }

    var isLoading : Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }

    // Closures for callback
    var showAlertClosure : (() -> ())?
    var updateLoadingStatus : (() -> ())?
    var didFinishFetch : (() -> ())?
    
    func fetchMenus(categoryId : String) {
        isLoading = true
        
        APIService.getMenus(categoryId: categoryId) { (menus, error) in
            if let error = error {
                self.errorString = error.rawValue
                self.isLoading = false
                
                return
            }
            self.errorString = nil
            self.isLoading = false
            
            self.menus = menus!
        }
    }
    
    
}

extension MenuCategoryViewModel : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier, for: indexPath) as! MenuCell
        let menu = menus[indexPath.section]
        
        cell.menu = menu
        
        return cell
    }
}

extension MenuCategoryViewModel : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectCell(menu: menus[indexPath.section])
    }
}
