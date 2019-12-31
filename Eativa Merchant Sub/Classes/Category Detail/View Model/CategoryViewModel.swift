//
//  CategoryViewModel.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 06/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation
import UIKit

enum CategoryViewModelItemType : Int {
    case item
    case add
}

protocol CategoryViewModelItem {
    var type : CategoryViewModelItemType { get }
    var rowCount : Int { get }
}

class CategoryViewModelAddItem : CategoryViewModelItem {
    var type: CategoryViewModelItemType {
        return .add
    }
    
    var rowCount: Int {
        return 1
    }
    
    var textField: UITextField!
}

class CategoryViewModelCategoryItem : CategoryViewModelItem {
    var type: CategoryViewModelItemType {
        return .item
    }
    
    var rowCount: Int {
        return categories.count
    }
    
    var categories : [MenuCategory]!
    
    init(categories: [MenuCategory]) {
        self.categories = categories
    }
    
}

protocol CategoryCellDelegate {
    func didSelectCell(category: MenuCategory)
}

class CategoryViewModel: NSObject {
    var items : [CategoryViewModelItem] = []
    
    var delegate : CategoryCellDelegate!
    
    var vc : CategoryViewController! {
        didSet {
            delegate = vc
        }
    }
    
    var isEditting : Bool {
        return vc.isEditingCategory
    }
    
    override init() {
        super.init()
        
        //generate()
    }
    
    var menuCategories : [MenuCategory] = [] {
        didSet {
            self.didFinishFetch?()
            items.append(CategoryViewModelCategoryItem(categories: menuCategories))
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
    
    func fetchCategories() {
        isLoading = true
        
        APIService.getCategoriesWithMenu(merchantId: CurrentUser.id) { (categories, error) in
            if let error = error {
                self.errorString = error.rawValue
                self.isLoading = false
                
                return
            }
            self.errorString = nil
            self.isLoading = false
            
            self.menuCategories = categories!
        }
    }
    
    func generate() {
        let menus1 = [
            Menu(name: "Burger", price: 10000, isAvailable: true),
            Menu(name: "Wing", price: 20000, isAvailable: false)
        ]
        
        let menus2 = [
            Menu(name: "Salad", price: 4000, isAvailable: false),
            Menu(name: "Tahu", price: 5000, isAvailable: false)
        ]
        
        menuCategories.append(MenuCategory(name: "Fast", menus: menus1))
        menuCategories.append(MenuCategory(name: "Healthy", menus: menus2))
        
        items.append(CategoryViewModelCategoryItem(categories: menuCategories))
        //items.append(CategoryViewModelAddItem())
    }
}

extension CategoryViewModel : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var total = 0
        
        for item in items {
            total += item.rowCount
        }
        
        return total
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section < items.first!.rowCount {
            let item = items[0]
            
            if let item = item as? CategoryViewModelCategoryItem, let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell {
                cell.menuCategory = item.categories[indexPath.section]
                
                cell.removeBtn.isHidden = !isEditting
                cell.nameTextField.isUserInteractionEnabled = isEditting
                
                return cell
            }
        }
        else {
            let item = items[1]
            if let item = item as? CategoryViewModelAddItem, let cell = tableView.dequeueReusableCell(withIdentifier: AddCategoryCell.identifier, for: indexPath) as? AddCategoryCell {
                
                cell.textField.isUserInteractionEnabled = isEditting
                item.textField = cell.textField
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

extension CategoryViewModel : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CategoryCell {
            if !isEditting {
                delegate.didSelectCell(category: cell.menuCategory)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
