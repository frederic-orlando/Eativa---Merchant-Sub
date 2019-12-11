//
//  MasterTableViewController.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 27/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit
import PusherSwift

class MasterViewController: UIViewController {
    var isAfterUpdate : Bool = false
    var isOnScreen : Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedType : MasterViewModelItemType?
    
    fileprivate let viewModel = MasterViewModel()
    var transactions : [[Transaction]] = [[],[],[],[],[]]
    
    var detailViewController : UIViewController? {
        if let vc  = detailNavigationController?.viewControllers.first {
            return vc
        }
        else {
            return nil
        }
    }
    
    var detailNavigationController : UINavigationController? {
        if let splitVCs = splitViewController?.viewControllers, splitVCs.count == 2 {
            return splitVCs[1] as? UINavigationController
        }
        else {
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.vc = self

        selectedType = .transaction
        
        setupPusherChannel()
        
        title = CurrentUser.name
        
        //detailViewController = detailNavigationController!.viewControllers.first!
        
        setupTableView()
        attemptFetchTransactions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isOnScreen = true
        PusherChannels.pusher.connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isOnScreen = false
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
        
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        
        tableView.register(MasterTypeCell.nib, forCellReuseIdentifier: MasterTypeCell.identifier)
        tableView.register(MasterBtnCell.nib, forCellReuseIdentifier: MasterBtnCell.identifier)
        
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
    }
    
    func setupPusherChannel() {
        let _ = PusherChannels.channel.bind(eventName: "Transaction", eventCallback: { (event: PusherEvent) in
            if event.data != nil {
//                print("Realtime ==================")
//                print(event.data)
                if !self.isOnScreen {
                    self.isAfterUpdate = true
                }
                self.attemptFetchTransactions()
                
                DispatchQueue.main.async {
                    for _ in 0...self.navigationController!.viewControllers.count - 1 {
                        self.navigationController?.popViewController(animated: false)
                    }
                }
                
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            }
        })
    }
    
    func attemptFetchTransactions() {
        viewModel.fetchTransactions()
        
        viewModel.updateLoadingStatus = {
            
        }
        
        viewModel.showAlertClosure = {
            if let errorString = self.viewModel.errorString {
                Alert.showErrorAlert(on: self, title: errorString) {
                    self.viewModel.fetchTransactions()
                }
            }
        }
        
        viewModel.didFinishFetch = {
            self.transactions = self.viewModel.transactions
            
            DispatchQueue.main.async {
                self.tableView.reloadDataWithSelection()

                if self.selectedType == .transaction && (self.detailViewController != nil || self.isAfterUpdate) {
//                    let cell = self.tableView.cellForRow(at: self.tableView.indexPathForSelectedRow!) as! MasterTypeCell
                    
                    self.refreshDetail(vc: self.detailViewController!, type: .transaction)
                }
            }
        }
    }
    
    func closeAllDetail() {
        let detailCount = detailNavigationController!.viewControllers.count - 1
        for _ in 0...detailCount {
            detailNavigationController?.popViewController(animated: false)
        }
    }
    
//    func changeDetail(animated : Bool, selectedRow : Int) {
//        let vc = UIStoryboard.getController(from: "Main", withIdentifier: "detailView") as! DetailViewController
//        vc.transactions = transactions[selectedRow]
//        vc.status = selectedRow
//        isAfterRealtime = false
//        navigationController?.pushViewController(vc, animated: animated)
//    }
    
    func changeDetailView(selectedCell cell : MasterTypeCell, type : MasterViewModelItemType) {
        //let row = tableView.indexPathForSelectedRow!.row
        
        closeAllDetail()
        var vc = UIViewController()
        switch type {
        case .transaction:
            vc = UIStoryboard.getController(from: "TransactionDetail", withIdentifier: "TransactionDetail") as! TransactionViewController

        case .menu:
            vc = UIStoryboard.getController(from: "CategoryDetail", withIdentifier: "CategoryDetail") as! CategoryViewController
            
        default:
            break
        }
        
        DispatchQueue.main.async {
            self.detailNavigationController?.viewControllers[0] = vc
            self.detailViewController!.title = cell.typeLbl.text
            self.refreshDetail(vc: self.detailViewController!, type: type)
        }
    }
    
    func refreshDetail(vc: UIViewController, type : MasterViewModelItemType) {
        let row = tableView.indexPathForSelectedRow!.row
        switch type {
        case .transaction:
            let transactionViewController = vc as! TransactionViewController
            
            transactionViewController.transactions = self.transactions[row]
            transactionViewController.status = row
            
            transactionViewController.refreshTableView()
            
            if row == 2 {
                transactionViewController.setupTimer()
            }
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let title = sender as! String
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        let vc = segue.destination
        vc.title = ""
        
        refreshDetail(vc: vc, type: selectedType!)
    }
}

extension MasterViewController : MasterTypeCellDelegate {
    func didSelectCell(cell: MasterTypeCell, type: MasterViewModelItemType) {
        let title = cell.typeLbl.text
        selectedType = type
        
        if detailViewController ==  nil {
            performSegue(withIdentifier: "show\(type.rawValue)", sender: title)
        }
        else {
            changeDetailView(selectedCell: cell, type: type)
        }
    }
}

extension MasterViewController : MasterBtnCellDelegate {
    func didPressBtn() {
        Defaults.clearUserData()
        CurrentUser.reset()
        
        if let navigationVC = UIStoryboard.getController(from: "Login", withIdentifier: "loginVC") as? UINavigationController {
            let loginVC = navigationVC.viewControllers.first as! LoginViewController
            
            UIApplication.changeRoot(to: loginVC)
        }
    }
}
