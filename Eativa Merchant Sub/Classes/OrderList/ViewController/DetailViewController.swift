//
//  DetailViewController.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 27/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var transactions : [Transaction] = [] {
        didSet {
            viewModel.transactions = transactions
        }
    }
    var status : Int! {
        didSet {
            viewModel.status = status
        }
    }
    
    fileprivate let viewModel = DetailViewModel()
    
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
        if let vc = navigationController?.viewControllers.first as? MasterViewController {
            return true
        }
        else {
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let interfaceIdiom = UIDevice.current.userInterfaceIdiom
        
        if interfaceIdiom == .phone && !hasParentView {
            let vc = UIStoryboard.getController(from: "Main", withIdentifier: "masterView")
            print(CurrentUser.name)
            vc.title = CurrentUser.name
            UIApplication.changeRoot(to: vc)
        }
        else {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        }
        
        setupTableView()
        view.layoutIfNeeded()
    }
    
    func setupTableView() {
        tableView.dataSource = viewModel
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView()
        tableView.register(TransactionCell.nib, forCellReuseIdentifier: TransactionCell.identifier)
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

extension DetailViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: transactions[indexPath.section])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cell = tableView.cellForRow(at: indexPath) as! TransactionCell
        
        if cell.transaction.isOnReminder && cell.transaction.status == 2{
            let contextItem = UIContextualAction(style: .normal, title: "Dismiss") { (contextualAction, view, completion) in
                
                cell.transaction.isOnReminder = false
                cell.refreshColor()
                
                completion(true)
            }
            
            contextItem.backgroundColor = .systemRed

            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

            //swipeActions.performsFirstActionWithFullSwipe = false
            
            return swipeActions
        }

        return nil
    }
}
