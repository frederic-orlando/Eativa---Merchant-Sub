//
//  DetailViewController.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 27/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    //@IBOutlet weak var tableView: UITableView!
    var tableView : UITableView!
    
    var transactions : [Transaction] = [] {
        didSet {
            transactionViewModel.transactions = transactions
        }
    }
    
    var status : Int! {
        didSet {
            transactionViewModel.status = status
        }
    }
    
    var timer: Timer?
    
    var type : MasterViewModelItemType?
    
    fileprivate let transactionViewModel = DetailViewModel()
    fileprivate let menuViewModel = MenuViewModel()
    
    var masterViewController : MasterViewController? {
        let splitVC = splitViewController!.viewControllers.count
        if splitVC == 2 {
            let navigationController = splitViewController?.viewControllers.first as! UINavigationController
            return navigationController.viewControllers.first as? MasterViewController
        }
        else {
            return nil
        }
    }
    
    var hasParentView : Bool {
        if (navigationController?.viewControllers.first as? MasterViewController) != nil {
            return true
        }
        else {
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if type == nil {
            type = .transaction
        }
        
        transactionViewModel.vc = self
        menuViewModel.vc = self
        
        if interfaceIdiom == .phone && !hasParentView {
            let vc = UIStoryboard.getController(from: "Main", withIdentifier: "masterView")
            UIApplication.changeRoot(to: vc)
        }
        else {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        }
        
        setupTableView()
        setupTimer()
        view.layoutIfNeeded()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if timer != nil {
            timer!.invalidate()
        }
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        
        tableView.fitTo(view: view)

        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        switch type {
        case .transaction:
            
            tableView.dataSource = transactionViewModel
            tableView.delegate = transactionViewModel
            tableView.register(TransactionCell.nib, forCellReuseIdentifier: TransactionCell.identifier)
        case .menu:
            tableView.dataSource = menuViewModel
            tableView.delegate = menuViewModel
            
            tableView.register(MenuHeaderView.nib, forHeaderFooterViewReuseIdentifier: MenuHeaderView.identifier)
            tableView.register(MenuCell.nib, forCellReuseIdentifier: MenuCell.identifier)
        default:
            break
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView()
        tableView.reloadData()

        if !tableView.visibleCells.isEmpty{
            tableView.scrollToTop()
        }
    }
    
    func setupTimer() {
        print(self.title)
        if type == .transaction && self.title == "On Process" {
            timer = Timer(fireAt: Date().roundedByTenMinute, interval: 600, target: self, selector: #selector(checkReminder), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .common)
            timer!.tolerance = 0.1
        }
    }
    
    @objc func checkReminder() {
        guard let visibleIndexPaths = tableView.indexPathsForVisibleRows else {
            return
        }
        
        for indexPath in visibleIndexPaths {
            if let cell = tableView.cellForRow(at: indexPath) as? TransactionCell {
                if !cell.transaction.isOnReminder {
                    cell.checkReminder()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showDetail":
            if let vc = segue.destination as? OrderDetailViewController {
                vc.transaction = (sender as! Transaction)
            }
        case "toScannerView":
            if let vc = segue.destination as? QRScannerViewController {
                vc.parentVC = self
            }
        default:
            break
        }
    }
}

extension DetailViewController : TransactionCellDelegate {
    func didSelectCell(indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: transactions[indexPath.section])
    }
}
