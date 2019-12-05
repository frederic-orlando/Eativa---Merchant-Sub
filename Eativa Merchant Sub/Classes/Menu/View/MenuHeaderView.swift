//
//  MenuHeaderView.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 04/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

protocol MenuHeaderViewDelegate: class {
    func toggleSection(header: MenuHeaderView, section: Int)
}

class MenuHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var container: UIView!
    
    var section  : Int = 0
    
    var item: MenuViewModelItem? {
        didSet {
            guard let item = item else {
                return
            }
            
            title.text = item.title
            setCollapsed(collapsed: item.isCollapsed)
        }
    }
    
    var delegate : MenuHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        container.layer.cornerRadius = 10
        
        container.clipsToBounds = true
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    
    @objc private func didTapHeader() {
        delegate?.toggleSection(header: self, section: section)
    }
    
    func setCollapsed(collapsed: Bool) {
        arrowImageView.rotate(collapsed ? 0.0 : .pi)
        if collapsed == false {
            container.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
