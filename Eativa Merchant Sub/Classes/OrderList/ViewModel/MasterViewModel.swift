//
//  ItemViewModel.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 27/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation
import UIKit

let transactionString = ["Pending", "Payment", "On Process", "Ready", "Complete"]
let menuString = ["Menu"]

enum MasterViewModelItemType {
    case transaction
    case menu
    case button
}

protocol MasterViewModelItem {
    var type : MasterViewModelItemType { get }
    var sectionTitle : String { get }
    var rowCount : Int { get }
}

protocol MasterTypeCellDelegate {
    func didSelectCell(cell: MasterTypeCell, type: MasterViewModelItemType)
}

class MasterViewModel: NSObject {
    var items = [MasterViewModelItem]()
    
    var delegate : MasterTypeCellDelegate!
    
    var vc : MasterViewController! {
        didSet {
            delegate = vc
        }
    }
    
    var transactions : [[Transaction]] = [[],[],[],[],[]] {
        didSet {
            self.didFinishFetch?()
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
    
    override init() {
        super.init()
        
        let transactionCell = MasterViewModelTransactionItem(labels: transactionString)
        items.append(transactionCell)
        
        let menuCell = MasterViewModelMenuItem(labels: menuString)
        items.append(menuCell)
        
        let buttonCell = MasterViewModelButtonItem()
        items.append(buttonCell)
    }
    
    func fetchTransactions() {
        for status in APIService.TransactionStatus.allCases {
            
            isLoading = true
            APIService.getTransactions(status: status) { (transactions, error) in
                if let error = error {
                self.errorString = error.rawValue
                self.isLoading = false
                return
                }
                self.errorString = nil
                self.isLoading = false
                
                var tempTransactions : [Transaction]
                
                tempTransactions = transactions ?? [Transaction]()
                
                self.transactions[status.rawValue] = tempTransactions
            }
        }
    }
}

extension MasterViewModel : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        
        switch item.type {
        case .transaction:
            if let item = item as? MasterViewModelTransactionItem, let cell = tableView.dequeueReusableCell(withIdentifier: MasterTypeCell.identifier, for: indexPath) as? MasterTypeCell {
                let row = indexPath.row
                cell.typeLbl!.text = item.labelTexts[row]
                
                cell.badgeLbl.isHidden = false
                
                if transactions.count > row {
                    cell.badgeLbl.text = String(transactions[row].count)
                }
                
                if indexPath.row == item.labelTexts.count - 1 || transactions[row].count == 0{
                    cell.badgeLbl.isHidden = true
                }
                
                return cell
            }
        case .menu:
            if let item = item as? MasterViewModelMenuItem, let cell = tableView.dequeueReusableCell(withIdentifier: MasterTypeCell.identifier, for: indexPath) as? MasterTypeCell {
                cell.typeLbl!.text = item.labelTexts[indexPath.row]
                cell.badgeLbl.isHidden = true
                return cell
            }
        case .button:
            if let cell = tableView.dequeueReusableCell(withIdentifier: MasterBtnCell.identifier, for: indexPath) as? MasterBtnCell {
                
                cell.delegate = vc
                cell.button.setTitle("Log Out", for: .normal)
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }
}

extension MasterViewModel : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MasterTypeCell {
            let type = items[indexPath.section].type
            delegate.didSelectCell(cell: cell, type: type)
        }
    }
}

class MasterViewModelTransactionItem : MasterViewModelItem {
    var type: MasterViewModelItemType {
        return .transaction
    }
    
    var sectionTitle: String {
        return "Transaction"
    }
    
    var rowCount: Int {
        return labelTexts.count
    }
    
    var labelTexts: [String]
    
    init(labels: [String]) {
        self.labelTexts = labels
    }
}

class MasterViewModelMenuItem : MasterViewModelItem {
    var type: MasterViewModelItemType {
        return .menu
    }
    
    var sectionTitle: String {
        return "Menu"
    }
    
    var rowCount: Int {
        return menuString.count
    }
    
    var labelTexts: [String]
    
    init(labels: [String]) {
        self.labelTexts = labels
    }
}

class MasterViewModelButtonItem : MasterViewModelItem {
    var type: MasterViewModelItemType {
        return .button
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return 1
    }
}
