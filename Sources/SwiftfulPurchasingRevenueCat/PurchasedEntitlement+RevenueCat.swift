//
//  PurchasedEntitlement+RevenueCat.swift
//  SwiftfulPurchasingRevenueCat
//
//  Created by Nick Sarno on 9/28/24.
//
import SwiftfulPurchasing
import RevenueCat

extension Dictionary where Key == String, Value == EntitlementInfo {
    func asPurchasedEntitlements() -> [PurchasedEntitlement] {
        compactMap({ PurchasedEntitlement(entitlement: $0.value) })
    }
}

extension PurchasedEntitlement {

    init(entitlement: EntitlementInfo) {
        self.init(
            id: entitlement.id,
            productId: entitlement.productIdentifier,
            expirationDate: entitlement.expirationDate,
            isActive: entitlement.isActive,
            originalPurchaseDate: entitlement.originalPurchaseDate,
            latestPurchaseDate: entitlement.latestPurchaseDate,
            ownershipType: EntitlementOwnershipOption(type: entitlement.ownershipType),
            isSandbox: entitlement.isSandbox,
            isVerified: entitlement.verification.isVerified
        )
    }
}

extension EntitlementOwnershipOption {

    init(type: PurchaseOwnershipType) {
        switch type {
        case .purchased:
            self = .purchased
        case .familyShared:
            self = .familyShared
        case .unknown:
            self = .unknown
        }
    }
}
