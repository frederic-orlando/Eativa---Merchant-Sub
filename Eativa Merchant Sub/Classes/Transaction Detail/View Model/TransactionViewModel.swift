//
//  DetailViewModel.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 28/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation
import UIKit

enum TransactionViewModelItemType : Int {
    case pending
    case waiting
    case onProcess
    case ready
    case complete
}

protocol TransactionCellDelegate {
    func didSelectCell(indexPath: IndexPath)
}

class TransactionViewModelItem {
    var type : TransactionViewModelItemType!
}

class TransactionViewModel: NSObject {
    var vc : TransactionViewController! {
        didSet {
            delegate = vc
        }
    }
    
    var delegate : TransactionCellDelegate!
    var transactions : [Transaction] = []
    var item = TransactionViewModelItem()
    var status : Int! {
        didSet {
            item.type = TransactionViewModelItemType(rawValue: status)
        }
    }
    var rowCount : Int {
        return transactions.count
    }
}

extension TransactionViewModel : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
            return transactions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.identifier, for: indexPath) as! TransactionCell
        let transaction = transactions[indexPath.section]
        var color : UIColor = .systemGray4
        switch item.type {
        case .pending, .waiting:
            color = .systemOrange
        case .onProcess:
            if transaction.isOnReminder {
                color = .systemRed
            }
        case .ready:
            color = .systemGreen
        case .complete, .none:
            break
        }
        cell.transaction = transaction
        cell.colorView.backgroundColor = color
        
        return cell
    }
}

extension TransactionViewModel : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cell = tableView.cellForRow(at: indexPath) as! TransactionCell
        
        if cell.transaction.isOnReminder && cell.transaction.status == 2{
            let contextItem = UIContextualAction(style: .normal, title: "Dismiss") { (contextualAction, view, completion) in
                
                cell.transaction.isOnReminder = false
                cell.transaction.isReminderDismiss = true
                
                APIService.put(.transactions, id: cell.transaction.id!, parameter: [
                    "isReminderDismiss" : true
                ])
                
                cell.refreshColor()
                
                completion(true)
            }
            
            contextItem.backgroundColor = .systemRed

            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
            
            return swipeActions
        }

        return nil
    }
}
