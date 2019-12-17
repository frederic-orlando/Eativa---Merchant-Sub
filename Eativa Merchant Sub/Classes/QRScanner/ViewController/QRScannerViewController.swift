//
//  QRScannerViewController.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 02/12/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController {
    @IBOutlet weak var scannerView: QRScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }
    
    var transactionId : String? = nil {
        didSet {
            if transactionId != nil {
                attemptFetchTransaction(transactionId: transactionId!)
            }
        }
    }
    
    let viewModel = QRScannerViewModel()
    
    var transaction : Transaction! {
        didSet{
            if transaction != nil {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                if transaction.merchantId == CurrentUser.id {
                    DispatchQueue.main.async {
                        let vc = UIStoryboard.getController(from: "OrderDetail", withIdentifier: "orderDetail") as! OrderDetailViewController
                        
                        let parameter = ["status" : 5]
                        APIService.put(.transactions, id: self.transaction.id!, parameter: parameter)
                        
                        self.transaction.status = 5
                        vc.transaction = self.transaction
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                            self.parentVC.navigationController?.pushViewController(vc, animated: true)
                        })
                    }
                } else {
                    Alert.showOKAlert(on: self, title: "Transaction is not found")
                }
                
            }
        }
    }
    
    var parentVC : TransactionViewController!
    
    var captureVideoOrientation : AVCaptureVideoOrientation? {
        let statusBarOrientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        
        return AVCaptureVideoOrientation(rawValue: statusBarOrientation!.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scannerView.layer.connection?.videoOrientation = captureVideoOrientation!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)

        if !scannerView.isRunning {
            scannerView.startScanning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
    }
    
    func attemptFetchTransaction(transactionId id : String) {
        viewModel.fetchTransactionDetail(id: id)
        
        viewModel.updateLoadingStatus = {
            
        }
        
        viewModel.showAlertClosure = {
            if let errorString = self.viewModel.errorString {
                Alert.showErrorAlert(on: self, title: errorString) {
                    self.viewModel.fetchTransactionDetail(id: id)
                }
            }
        }
        
        viewModel.didFinishFetch = {
            if let transaction = self.viewModel.transaction {
                self.transaction = transaction
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            self.scannerView.layer.connection?.videoOrientation = self.captureVideoOrientation!
        })
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension QRScannerViewController : QRScannerViewDelegate {
    func qrScanningDidStop() {
        
    }

    func qrScanningDidFail() {
        Alert.showOKAlert(on: self, title: "Scanning Failed")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        transactionId = str
    }
}
