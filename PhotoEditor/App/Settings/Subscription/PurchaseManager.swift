//
//  PurchaseManager.swift
//  PhotoEditor
//

import StoreKit
import SwiftUI

class StoreManager: NSObject, ObservableObject {
    
    static public let shared: StoreManager = .init()
    
    @Published var products: [SKProduct] = []
    @AppStorage("generationsRemaining") public var generationsRemaining: Int = 0
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        self.fetchProducts()
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: ProductConstants.subscriptionIds)
        request.delegate = self
        request.start()
    }
    
    func buyProduct(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func handleTransaction(_ transaction: SKPaymentTransaction) {
        switch transaction.payment.productIdentifier {
        case "com.test.basic": generationsRemaining += 30
        case "com.test.standard": generationsRemaining += 120
        case "com.test.super": generationsRemaining += 400
        default: break
        }
    }
}

extension StoreManager: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products.sorted(by: { $0.price.doubleValue < $1.price.doubleValue })
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                self.handleTransaction(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                if let error = transaction.error {
                    print("Transaction failed: \(error.localizedDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}
