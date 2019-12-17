//
//  MenuDetailViewController.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 10/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

class MenuDetailViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var isKeyboardShowing : Bool = false
    var isScrolling : Bool = false
    var tableContentInitialHeight : CGFloat = 0
    
    var isMenuEditing : Bool = false
    
    var categoryId : String! {
        didSet {
            print("Category Id: ", categoryId)
        }
    }
    
    var menu : Menu? {
        didSet {
            viewModel.menu = menu
        }
    }
    
    fileprivate var viewModel = MenuDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.vc = self
        
        setupTableView()
        setupObserver()
        hideKeyboardWhenTapped()
    }
    
    func setupTableView() {
        //tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.contentInset.bottom = 30
        
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        
        tableView.register(MenuTwoTextCell.nib, forCellReuseIdentifier: MenuTwoTextCell.identifier)
        tableView.register(MenuTextSwitchCell.nib, forCellReuseIdentifier: MenuTextSwitchCell.identifier)
        tableView.register(MenuButtonCell.nib, forCellReuseIdentifier: MenuButtonCell.identifier)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = view.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            
        }

        return true
    }
}

extension MenuDetailViewController : MenuButtonDelegate {
    func didPressButton(menuId: String) {
        //delete menu
        print("delete menu :", menuId)
    }
    
    
}
