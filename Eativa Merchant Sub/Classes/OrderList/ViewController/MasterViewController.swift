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
    
    fileprivate let viewModel = MasterViewModel()
    var transactions : [[Transaction]] = [[],[],[],[],[]]
    
    var detailViewController : DetailViewController? {
        if let splitVCs = splitViewController?.viewControllers, splitVCs.count == 2 {
            let navigationController = splitViewController?.viewControllers[1] as! UINavigationController
            return navigationController.viewControllers.first as? DetailViewController
        }
        else {
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.vc = self
        
        setupPusherChannel()
        
        print(CurrentUser.name)
        title = CurrentUser.name
        
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

                if self.detailViewController != nil || self.isAfterUpdate {
                    let cell = self.tableView.cellForRow(at: self.tableView.indexPathForSelectedRow!) as! MasterTypeCell
                    self.refreshDetail(selectedCell: cell, type: .transaction)
                }
            }
        }
    }
    
//    func refreshDetail(indexPath : IndexPath?) {
//        let indexPath = indexPath ?? tableView.indexPathForSelectedRow!
//        let selectedSection = indexPath.section
//        let selectedRow = indexPath.row
//        let cell = self.tableView.cellForRow(at: indexPath) as! MasterTypeCell
//
//        if let vc = detailViewController {
//            DispatchQueue.main.async {
//                self.closeDetail()
//
//                let transactions = self.transactions[selectedRow]
//                vc.transactions = transactions
//                vc.status = selectedRow
//                vc.title = cell.typeLbl.text
//                vc.tableView.reloadData()
//
//                if transactions.count > 0 {
//                    vc.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
//                }
//            }
//        }
//        else {
//            DispatchQueue.main.async {
//                self.changeDetail(animated: !self.isAfterRealtime, selectedRow: selectedRow)
//            }
//        }
//    }
    
    func closeDetail() {
        detailViewController!.navigationController?.popViewController(animated: true)
    }
    
//    func changeDetail(animated : Bool, selectedRow : Int) {
//        let vc = UIStoryboard.getController(from: "Main", withIdentifier: "detailView") as! DetailViewController
//        vc.transactions = transactions[selectedRow]
//        vc.status = selectedRow
//        isAfterRealtime = false
//        navigationController?.pushViewController(vc, animated: animated)
//    }
    
    func refreshDetail(selectedCell cell : MasterTypeCell, type : MasterViewModelItemType) {
        let row = tableView.indexPathForSelectedRow!.row
        
        if let vc = detailViewController {
            print("Refresh Detail ========")
            switch type {
            case .transaction:
                let transactions = self.transactions[row]
                vc.transactions = transactions
                vc.status = row
            case .menu:
                break
                
            default:
                break
            }
            
            DispatchQueue.main.async {
                vc.title = cell.typeLbl.text
                vc.type = type
                vc.setupTableView()
                
                if type == .transaction && row == 2{
                    vc.setupTimer()
                }
            }
        }
    }
}

extension MasterViewController : MasterTypeCellDelegate {
    func didSelectCell(cell: MasterTypeCell, type: MasterViewModelItemType) {
        refreshDetail(selectedCell: cell, type: type)
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
