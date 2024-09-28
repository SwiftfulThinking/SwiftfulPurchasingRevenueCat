import Foundation
import RevenueCat
import SwiftfulPurchasing

public struct RevenueCatPurchaseService: PurchaseService {
    let productIds: [String]

    public init(apiKey: String, productIds: [String], logLevel: LogLevel = .warn) {
        self.productIds = productIds

        Purchases.logLevel = logLevel
        Purchases.configure(withAPIKey: apiKey)
        Purchases.shared.attribution.collectDeviceIdentifiers()
    }

    enum Error: LocalizedError {
        case productNotFound
    }

    public func listenForTransactions(onTransactionsUpdated: @escaping () async -> Void) async {
        for await _ in Purchases.shared.customerInfoStream {
            await onTransactionsUpdated()
        }
    }

    public func getAvailableProducts() async throws -> [AnyProduct] {
        let products = await Purchases.shared.products(productIds)
        return products.map({ AnyProduct(revenueCatProduct: $0) })
    }

    public func getUserEntitlements() async throws -> [PurchasedEntitlement] {
        let customerInfo = try await Purchases.shared.customerInfo()
        return customerInfo.entitlements.all.asPurchasedEntitlements()
    }

    public func purchaseProduct(productId: String) async throws -> [PurchasedEntitlement] {
        guard let product = await Purchases.shared.products([productId]).first else {
            throw Error.productNotFound
        }
        let purchaserInfo = try await Purchases.shared.purchase(product: product)
        return purchaserInfo.customerInfo.entitlements.all.asPurchasedEntitlements()
    }

    public func restorePurchase() async throws -> [PurchasedEntitlement] {
        let purchaserInfo = try await Purchases.shared.restorePurchases()
        return purchaserInfo.entitlements.all.asPurchasedEntitlements()
    }

    public func logIn(userId: String, email: String?) async throws -> [PurchasedEntitlement] {
        // Log in to RevenueCat
        let (purchaserInfo, _) = try await Purchases.shared.logIn(userId)

        // Set user email
        Purchases.shared.attribution.setEmail(email)

        // Return purchases
        return purchaserInfo.entitlements.all.asPurchasedEntitlements()
    }

    public func logOut() async throws {
        _ = try await Purchases.shared.logOut()
    }

}

