//
//  MenuDetailViewModel.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 10/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation
import UIKit

enum MenuDetailViewModelItemType {
    case detail
    case switchControl
    case deleteButton
}

protocol MenuDetailViewModelItem {
    var type : MenuDetailViewModelItemType {get}
    var rowCount : Int {get}
}

class MenuDetailViewModel : NSObject {
    var items = [MenuDetailViewModelItem]()
    var menu : Menu! {
        didSet {
            let detailItem = MenuDetailViewModelDetailItem(name: menu.name!, price: menu.price!, desc: nil)
            items.append(detailItem)
            
            let switchItem = MenuDetailViewModelSwitchItem(isAvailable: menu.isAvailable)
            items.append(switchItem)
            
            if menu != nil {
                let buttonItem = MenuDetailViewModelButtonItem(menuId: menu.id!)
                items.append(buttonItem)
            }
        }
    }
    
    var vc : MenuDetailViewController!
}

extension MenuDetailViewModel : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        let row = indexPath.row
        
        switch item.type {
        case .detail:
            if let item = item as? MenuDetailViewModelDetailItem, let cell = tableView.dequeueReusableCell(withIdentifier: MenuTwoTextCell.identifier, for: indexPath) as? MenuTwoTextCell {
                
                cell.label.text = item.labels[row]
                cell.textField.text = item.details[row]
                
                cell.textField.tag = row
                cell.textField.delegate = vc
                
                if row == 1 {
                    cell.textField.keyboardType = .numberPad
                }
                
                return cell
            }
        case .switchControl:
            if let item = item as? MenuDetailViewModelSwitchItem, let cell = tableView.dequeueReusableCell(withIdentifier: MenuTextSwitchCell.identifier, for: indexPath) as? MenuTextSwitchCell {
                
                cell.switchControl.isOn = item.isAvailable
                
                return cell
            }
        case .deleteButton:
            if let item = item as? MenuDetailViewModelButtonItem, let cell = tableView.dequeueReusableCell(withIdentifier: MenuButtonCell.identifier, for: indexPath) as? MenuButtonCell {
                
                cell.menuId = item.menuId
                cell.delegate = vc
                
                return cell
            }
            
        }
        
        return UITableViewCell()
    }
}

extension MenuDetailViewModel : UITableViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        vc.isScrolling = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let item = items[indexPath.section]
    }
}

class MenuDetailViewModelDetailItem : MenuDetailViewModelItem {
    var type: MenuDetailViewModelItemType {
        return .detail
    }
    
    var rowCount: Int {
        return labels.count
    }
    
    var labels = ["Menu Name", "Price", "Deskripsi"]
    
    var details : [String] = []
    
    init(name: String, price: Int, desc: String?) {
        details.append(name)
        details.append("\(price)")
        
        let desc = desc ?? "None"
        details.append(desc)
    }
}

class MenuDetailViewModelSwitchItem : MenuDetailViewModelItem {
    var type: MenuDetailViewModelItemType {
        return .switchControl
    }
    
    var rowCount: Int {
        return 1
    }
    
    var isAvailable : Bool!
    
    init(isAvailable : Bool?) {
        self.isAvailable = isAvailable ?? false
    }
}

class MenuDetailViewModelButtonItem : MenuDetailViewModelItem {
    var type: MenuDetailViewModelItemType {
        return .deleteButton
    }
    
    var rowCount: Int {
        return 1
    }
    
    var menuId : String!
    
    init(menuId : String) {
        self.menuId = menuId
    }
}
