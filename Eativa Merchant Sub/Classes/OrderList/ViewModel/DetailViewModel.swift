//
//  DetailViewModel.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 28/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation
import UIKit

enum DetailViewModelItemType : Int {
    case pending
    case waiting
    case onProcess
    case ready
    case complete
}

class DetailViewModelItem {
    var type : DetailViewModelItemType!
}

class DetailViewModel: NSObject {
    var transactions : [Transaction]!
    var item = DetailViewModelItem()
    var status : Int! {
        didSet {
            item.type = DetailViewModelItemType(rawValue: status)
        }
    }
    var rowCount : Int {
        return transactions!.count
    }
}

extension DetailViewModel : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if transactions == nil {
            return 0
        }
        else {
            return transactions.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.identifier, for: indexPath) as! TransactionCell
        let transaction = transactions![indexPath.section]
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
