//
//  DetailViewController.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 27/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var imageState: UIImageView!
    @IBOutlet weak var titleState: UILabel!
    
    var emptyState = ["ongoing_state","waitingpayment_state","onprocess_state","pickup_state","history_state"]
    var titleEmptyState = ["There are no orders yet","There are no orders yet","There are no orders yet","There are no orders yet","There are no orders yet"]
    
    var transactions : [Transaction] = [] {
        didSet {
            transactionViewModel.transactions = transactions
        }
    }
    
    var status : Int! = 0 {
        didSet {
            transactionViewModel.status = status
        }
    }
    
    var timer: Timer?
    
    var type : MasterViewModelItemType = .transaction
    
    fileprivate let transactionViewModel = TransactionViewModel()
    
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
        
        transactionViewModel.vc = self
        
        if interfaceIdiom == .phone && !hasParentView {
            let vc = UIStoryboard.getController(from: "Main", withIdentifier: "masterView")
            UIApplication.changeRoot(to: vc)
        }
        else {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        }

        setupTableView()
        refreshImageState()
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
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
            
        tableView.dataSource = transactionViewModel
        tableView.delegate = transactionViewModel
        tableView.register(TransactionCell.nib, forCellReuseIdentifier: TransactionCell.identifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView()
        
        refreshTableView()
    }
    
    func refreshImageState() {
        if imageState != nil {
            imageState.image = UIImage(named: emptyState[status])
            titleState.text = titleEmptyState[status]
            
            emptyStateView.isHidden = transactions.count > 0
            
            
        }
    }
    
    func refreshTableView() {
        if tableView != nil {
            tableView.reloadData()

            if !tableView.visibleCells.isEmpty{
                tableView.scrollToTop()
            }
        }
    }
    
    func setupTimer() {
        timer = Timer(fireAt: Date().roundedByTenMinute, interval: 600, target: self, selector: #selector(checkReminder), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
        timer!.tolerance = 0.1
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

extension TransactionViewController : TransactionCellDelegate {
    func didSelectCell(indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: transactions[indexPath.section])
    }
}
