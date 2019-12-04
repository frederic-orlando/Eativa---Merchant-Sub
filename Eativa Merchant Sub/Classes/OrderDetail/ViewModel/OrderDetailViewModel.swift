//
//  OrderDetailViewModel.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 29/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation
import UIKit

enum OrderDetailViewModelItemType {
    case detail
    case price
    case picker
    case payment
    case confirmButton
    case readyButton
}

protocol OrderDetailViewModelItem {
    var type : OrderDetailViewModelItemType {get}
    var rowCount : Int {get}
}

class OrderDetailViewModel : NSObject {
    var items = [OrderDetailViewModelItem]()
    var transaction : Transaction! {
        didSet {
            let detailItem = OrderDetailViewModelDetailItem(details: transaction.details!)
            items.append(detailItem)
            
            let prices = [transaction.getSubTotalPrice(), transaction.getTaxPrice(), transaction.total!]
            let priceItem = OrderDetailViewModelPriceItem(prices: prices)
            items.append(priceItem)
            
            let time = transaction.pickUpTime!.time
            let pickerItem = OrderDetailViewModelPickerItem(pickUpTime: time)
            items.append(pickerItem)
            
            let paymentItem = OrderDetailViewModelPaymentItem(paymentMethod: "GO Pay")
            items.append(paymentItem)
            
            switch transaction.status {
            case 0 :
                let confirmItem = OrderDetailViewModelConfirmButtonItem()
                items.append(confirmItem)
            case 2 :
                let readyItem = OrderDetailViewModelReadyButtonItem()
                items.append(readyItem)
            default :
                break
            }
        }
    }
    
    var vc : OrderDetailViewController!
    var pickUpTextField : UITextField!
    var confirmationCell : ConfirmationButtonCell!
}

extension OrderDetailViewModel : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        let row = indexPath.row
        
        switch item.type {
        case .detail:
            if let item = item as? OrderDetailViewModelDetailItem, let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.identifier, for: indexPath) as? DetailCell{
                cell.detail = item.details[row]
            return cell
        }
        case .price:
            if let item = item as? OrderDetailViewModelPriceItem, let cell = tableView.dequeueReusableCell(withIdentifier: TwoLabelCell.identifier, for: indexPath) as? TwoLabelCell{
            
                cell.titleLabel.text = item.labels[row]
                cell.value = item.prices[row].currency
            
            return cell
            }
        case .picker:
            if let item = item as? OrderDetailViewModelPickerItem, let cell = tableView.dequeueReusableCell(withIdentifier: PickerCell.identifier, for: indexPath) as? PickerCell{
                
                cell.delegate = vc
                
                cell.label.text = item.label
                cell.item = item
                
                pickUpTextField = cell.pickUpTextField
                
                return cell
            }
        case .payment:
            if let item = item as? OrderDetailViewModelPaymentItem, let cell = tableView.dequeueReusableCell(withIdentifier: TwoLabelCell.identifier, for: indexPath) as? TwoLabelCell{
            
            cell.titleLabel.text = item.label
            cell.valueLabel.text = item.paymentMethod
            
            return cell
            }
        case .confirmButton:
            if let _ = item as? OrderDetailViewModelConfirmButtonItem, let cell = tableView.dequeueReusableCell(withIdentifier: ConfirmationButtonCell.identifier, for: indexPath) as? ConfirmationButtonCell{
                
                cell.delegate = vc
                confirmationCell = cell
                
                return cell
            }
        case .readyButton:
            if let _ = item as? OrderDetailViewModelReadyButtonItem, let cell = tableView.dequeueReusableCell(withIdentifier: ReadyButtonCell.identifier, for: indexPath) as? ReadyButtonCell{
                
                cell.delegate = vc
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

extension OrderDetailViewModel : UITableViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        vc.isScrolling = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section]
        
        if item.type == .picker {
            pickUpTextField.becomeFirstResponder()
        }
    }
}

class OrderDetailViewModelDetailItem : OrderDetailViewModelItem {
    var type: OrderDetailViewModelItemType {
        return .detail
    }
    
    var rowCount: Int {
        return details.count
    }
    
    var details : [TransactionDetail]!
    
    init(details : [TransactionDetail]) {
        self.details = details
    }
}

class OrderDetailViewModelPriceItem : OrderDetailViewModelItem {
    var type: OrderDetailViewModelItemType {
        return .price
    }
    
    var rowCount: Int {
        return prices.count
    }
    
    var labels : [String]
    var prices : [Int]
    
    init(prices : [Int]) {
        var labels = ["Subtotal", "Tax", "Total"]
        var filteredPrices  = prices
        
        if prices[1] == 0 {
            for _ in 0...1 {
                filteredPrices.remove(at: 0)
                labels.remove(at: 0)
            }
        }
        self.labels = labels
        self.prices = filteredPrices
    }
}

class OrderDetailViewModelPickerItem : OrderDetailViewModelItem {
    var type: OrderDetailViewModelItemType {
        return .picker
    }
    
    var rowCount: Int {
        return 1
    }
    
    var label = "Pick Up Time"
    var pickUpTime : Date
    var newPickUpTime : Date
    
    init(pickUpTime : Date) {
        self.pickUpTime = pickUpTime
        self.newPickUpTime = pickUpTime
    }
}

class OrderDetailViewModelPaymentItem : OrderDetailViewModelItem {
    var type: OrderDetailViewModelItemType {
        return .payment
    }
    
    var rowCount: Int {
        return 1
    }
    
    var label : String
    var paymentMethod : String
    
    init(paymentMethod : String) {

        self.label = "Payment Method"
        self.paymentMethod = paymentMethod
    }
}

class OrderDetailViewModelConfirmButtonItem : OrderDetailViewModelItem {
    var type: OrderDetailViewModelItemType {
        return .confirmButton
    }
    
    var rowCount: Int {
        return 1
    }
}

class OrderDetailViewModelReadyButtonItem : OrderDetailViewModelItem {
    var type: OrderDetailViewModelItemType {
        return .readyButton
    }
    
    var rowCount: Int {
        return 1
    }
}
