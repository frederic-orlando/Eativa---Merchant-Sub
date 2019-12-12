//
//  CategoryViewController.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 06/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    var isEditingCategory : Bool!
    
    fileprivate var viewModel = CategoryViewModel()
    
    var categories : [MenuCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isEditingCategory = false
        
        viewModel.vc = self
        
        setupTableView()
        
        attemptFetchCategories()
    }
    
    func setupTableView() {
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
            
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        
        tableView.register(CategoryCell.nib, forCellReuseIdentifier: CategoryCell.identifier)
        tableView.register(AddCategoryCell.nib, forCellReuseIdentifier: AddCategoryCell.identifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(attemptFetchCategories), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        refreshTableView()
    }
    
    func refreshTableView() {
        if tableView != nil {
            tableView.reloadData()

            if !tableView.visibleCells.isEmpty{
                tableView.scrollToTop()
            }
        }
    }
    
    @objc func attemptFetchCategories() {
        viewModel.fetchCategories()
        
        viewModel.updateLoadingStatus = {
            
        }
        
        viewModel.showAlertClosure = {
            if let errorString = self.viewModel.errorString {
                Alert.showErrorAlert(on: self, title: errorString) {
                    self.viewModel.fetchCategories()
                }
            }
        }
        
        viewModel.didFinishFetch = {
            self.categories = self.viewModel.menuCategories
            
            DispatchQueue.main.async {
                print("finish")
                self.refreshTableView()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if isEditingCategory { // Press Done
            if let item = viewModel.items.last as? CategoryViewModelAddItem {
                if let name = item.textField.text, name != ""  {
                    print("New Category: ", name)
                    
                    let newCategory = MenuCategory(name: name, menus: [])
                    let categoryItem = viewModel.items.first as! CategoryViewModelCategoryItem
                    
                    categoryItem.categories.append(newCategory)
                    item.textField.text = ""
                }
                
                viewModel.items.remove(at: 1)
            }
            
            
        }
        else { // Press Edit
            viewModel.items.append(CategoryViewModelAddItem())
        }
        
        isEditingCategory = !isEditingCategory
        
        editBtn.title = isEditingCategory ? "Done" : "Edit"
        
        tableView.reloadData()
    }
    
    func addNewCategory() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let category = sender as! MenuCategory
        let vc = segue.destination as! MenuCategoryViewController
        vc.menus = category.menus
        vc.categoryId = category.id
    }
}
extension CategoryViewController : CategoryCellDelegate {
    func didSelectCell(category: MenuCategory) {
        performSegue(withIdentifier: "showMenu", sender: category)
    }
}
