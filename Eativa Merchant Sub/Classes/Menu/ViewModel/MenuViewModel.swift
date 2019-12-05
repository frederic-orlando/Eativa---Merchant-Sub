//
//  MenuViewModel.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 04/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation
import UIKit

class MenuViewModelItem {
    var title : String!
    var menus : [Menu]!
    var isCollapsed: Bool = true
    
    init(category : MenuCategory) {
        self.title = category.name!
        self.menus = category.menus!
    }
}

class MenuViewModel: NSObject {
    var items : [MenuViewModelItem] = []
    var vc : DetailViewController!
    
    override init() {
        super.init()
        
        generate()
    }
    
    func generate() {
        let menus1 = [
            Menu(name: "Burger", price: 10000),
            Menu(name: "Fries", price: 25000),
            Menu(name: "Chicken", price: 5000)
        ]
        
        let category1 = MenuCategory(name: "Fast", menus: menus1)
        let item1 = MenuViewModelItem(category: category1)
        items.append(item1)
        
        let menus2 = [
            Menu(name: "Salad", price: 100000),
            Menu(name: "Pototo", price: 45000),
            Menu(name: "Cumber", price: 50000)
        ]
        
        let category2 = MenuCategory(name: "Healthy", menus: menus2)
        let item2 = MenuViewModelItem(category: category2)
        items.append(item2)
    }
}

extension MenuViewModel : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return items[section].title
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = items[section]
        if item.isCollapsed {
            return 0
        }
        return items[section].menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier, for: indexPath) as! MenuCell
        
        let item = items[indexPath.section]
        
        cell.menu = item.menus[indexPath.row]
        
        return cell
    }
}

extension MenuViewModel : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MenuHeaderView.identifier) as? MenuHeaderView {
            
            headerView.item = self.items[section]
            headerView.section = section
            headerView.delegate = self
            
            return headerView
        }
        
        return UIView()
    }
}

extension MenuViewModel : MenuHeaderViewDelegate {
    func toggleSection(header: MenuHeaderView, section: Int) {
        let item = items[section]
        
        let collapsed = !item.isCollapsed
        item.isCollapsed = collapsed
        header.setCollapsed(collapsed: collapsed)
        
        vc.tableView.beginUpdates()
        vc.tableView.reloadSections([section], with: .fade)
        vc.tableView.endUpdates()
    }
}
