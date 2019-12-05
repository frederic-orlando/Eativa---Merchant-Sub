//
//  OrderDetailViewController.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 28/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    var isKeyboardShowing : Bool = false
    var isScrolling : Bool = false
    var tableContentInitialHeight : CGFloat = 0
    
    var transactionStatus = ["Waiting for Confirmation",
                             "Waiting for Payment",
                             "On Process",
                             "Ready to Pick Up",
                             "Complete"]
    var transaction : Transaction! {
        didSet {
            viewModel.transaction = transaction
        }
    }
    
    fileprivate let viewModel = OrderDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.vc = self
        
        setupContainerView()
        setupHeaderView()
        setupTableView()
        setupObserver()
        
        view.layoutIfNeeded()
    }
    
    func setupContainerView() {
        let layer = containerView.layer
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        containerView.clipsToBounds = true
    }
    
    func setupHeaderView() {
        let customer = transaction.customer!
        
        headerView.namePhoneLbl.text = "\(customer.name!) - \(customer.phone!)"
        headerView.pickupTimeLbl.text = "Pick Up Time : \(transaction.pickUpTime!.timeString)"
        headerView.creationDateLbl.text = transaction.createdAt?.creationDate ?? ""
        headerView.statusLbl.text = transactionStatus[transaction.status!]
    }
    
    func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.contentInset.bottom = 30
        
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        
        tableView.register(DetailCell.nib, forCellReuseIdentifier: DetailCell.identifier)
        tableView.register(TwoLabelCell.nib, forCellReuseIdentifier: TwoLabelCell.identifier)
        tableView.register(PickerCell.nib, forCellReuseIdentifier: PickerCell.identifier)
        tableView.register(ConfirmationButtonCell.nib, forCellReuseIdentifier: ConfirmationButtonCell.identifier)
        tableView.register(ReadyButtonCell.nib, forCellReuseIdentifier: ReadyButtonCell.identifier)
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification : Notification) {
        if !isKeyboardShowing {
            isScrolling = false
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            {
                let keyboardHeight = keyboardSize.height + 50
                tableContentInitialHeight = tableView.contentSize.height
                
                tableView.contentSize.height +=  keyboardHeight
                if tableView.isScrollable {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.tableView.scrollToBottom()
                    }
                }
                
                isKeyboardShowing = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification : Notification) {
        tableView.contentSize.height = tableContentInitialHeight
        if !isScrolling && tableView.isScrollable {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.tableView.scrollToBottom()
            }
        }
        isKeyboardShowing = false
    }
}

extension OrderDetailViewController : PickerCellDelegate {
    func didChangePickUpTime(newTime: Date) {
        let isSuggestingValidTime = newTime > Date()
        viewModel.confirmationCell.isSuggestingNewTime = isSuggestingValidTime
    }
}

extension OrderDetailViewController : ConfirmationCellDelegate {
    func didPressSendSuggestion() {
        let parameter = ["status" : 1]
        APIService.put(.transactions, id: transaction.id!, parameter: parameter)
        navigationController?.popViewController(animated: true)
    }
    
    func didPressAccept() {
        let parameter = ["status" : 1]
        APIService.put(.transactions, id: transaction.id!, parameter: parameter)
        navigationController?.popViewController(animated: true)
    }
    
    func didPressDecline() {
        let parameter = ["status" : 6]
        APIService.put(.transactions, id: transaction.id!, parameter: parameter)
        navigationController?.popViewController(animated: true)
    }
    
    func didPressSuggestTime() {
        viewModel.pickUpTextField.becomeFirstResponder()
    }
}

extension OrderDetailViewController : FoodReadyCellDelegate {
    func didPressReady() {
        let parameter = ["status" : 3]
        APIService.put(.transactions, id: transaction.id!, parameter: parameter)
        navigationController?.popViewController(animated: true)
    }
}
