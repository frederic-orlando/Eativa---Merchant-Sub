//
//  QRScannerViewModel.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 03/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import Foundation

class QRScannerViewModel{
    var transaction : Transaction? {
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

    //Network call
    func fetchTransactionDetail(id : String) {
        isLoading = true

        APIService.getDetail(.transactions, id: id) { (transaction, error) in
            if let error = error {
                self.errorString = error.rawValue
                self.isLoading = false
                return
            }
            self.errorString = nil
            self.isLoading = false
            self.transaction = transaction as? Transaction
        }
    }
}
