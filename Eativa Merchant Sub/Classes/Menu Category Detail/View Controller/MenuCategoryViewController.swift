//
//  MenuCategoryViewController.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 09/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

class MenuCategoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var  viewModel = MenuCategoryViewModel()
    
    var menus : [Menu]! {
        didSet {
            viewModel.menus = menus
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.vc = self
        
        setupTableView()
    }

    func setupTableView() {
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
            
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        tableView.register(MenuCell.nib, forCellReuseIdentifier: MenuCell.identifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView()
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let menu = sender as! Menu
        if let vc = segue.destination as? MenuDetailViewController {
            vc.menu = menu
        }
    }
}

extension MenuCategoryViewController : MenuCategoryCellDelegate {
    func didSelectCell(menu: Menu) {
        performSegue(withIdentifier: "toMenuDetail", sender: menu)
    }
}
