import Foundation
import RevenueCat
import SwiftfulPurchasing

public struct RevenueCatPurchaseService: PurchaseService {

    public init(apiKey: String, logLevel: LogLevel = .warn) {
        Purchases.logLevel = logLevel
        Purchases.configure(withAPIKey: apiKey)
        Purchases.shared.attribution.collectDeviceIdentifiers()
    }

    enum Error: LocalizedError {
        case productNotFound
    }

    public func listenForTransactions(onTransactionsUpdated: @escaping ([PurchasedEntitlement]) async -> Void) async {
        for await customerInfo in Purchases.shared.customerInfoStream {
            let entitlements = customerInfo.entitlements.all.asPurchasedEntitlements()
            await onTransactionsUpdated(entitlements)
        }
    }

    public func getProducts(productIds: [String]) async throws -> [AnyProduct] {
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
    
    public func checkTrialEligibility(productId: String) async throws -> Bool {
        let eligibilityDict = await Purchases.shared.checkTrialOrIntroDiscountEligibility(productIdentifiers: [productId])
        guard let eligibility = eligibilityDict[productId] else { return false }
        
        switch eligibility.status {
        case .eligible:
            return true
        case .ineligible, .noIntroOfferExists, .unknown:
            return false
        }
    }

    public func restorePurchase() async throws -> [PurchasedEntitlement] {
        let purchaserInfo = try await Purchases.shared.restorePurchases()
        return purchaserInfo.entitlements.all.asPurchasedEntitlements()
    }

    public func logIn(userId: String) async throws -> [PurchasedEntitlement] {
        // Log in to RevenueCat
        let (purchaserInfo, _) = try await Purchases.shared.logIn(userId)

        // Return purchases
        return purchaserInfo.entitlements.all.asPurchasedEntitlements()
    }
    
    public func updateProfileAttributes(attributes: PurchaseProfileAttributes) async throws {
        if let email = attributes.email {
            Purchases.shared.attribution.setEmail(email)
        }
        if let displayName = attributes.displayName {
            Purchases.shared.attribution.setDisplayName(displayName)
        }
        if let pushToken = attributes.pushToken {
            Purchases.shared.attribution.setPushTokenString(pushToken)
        }
        if let adjustId = attributes.adjustId {
            Purchases.shared.attribution.setAdjustID(adjustId)
        }
        if let appsFlyerId = attributes.appsFlyerId {
            Purchases.shared.attribution.setAppsflyerID(appsFlyerId)
        }
        if let facebookAnonymousId = attributes.facebookAnonymousId {
            Purchases.shared.attribution.setFBAnonymousID(facebookAnonymousId)
        }
        if let mParticleId = attributes.mParticleId {
            Purchases.shared.attribution.setMparticleID(mParticleId)
        }
        if let oneSignalId = attributes.oneSignalId {
            Purchases.shared.attribution.setOnesignalUserID(oneSignalId)
        }
        if let airshipChannelId = attributes.airshipChannelId {
            Purchases.shared.attribution.setAirshipChannelID(airshipChannelId)
        }
        if let cleverAppId = attributes.cleverAppId {
            Purchases.shared.attribution.setCleverTapID(cleverAppId)
        }
        if let kochavaDeviceId = attributes.kochavaDeviceId {
            Purchases.shared.attribution.setKochavaDeviceID(kochavaDeviceId)
        }
        if let mixpanelDistinctId = attributes.mixpanelDistinctId {
            Purchases.shared.attribution.setMixpanelDistinctID(mixpanelDistinctId)
        }
        if let firebaseAppInstanceId = attributes.firebaseAppInstanceId {
            Purchases.shared.attribution.setFirebaseAppInstanceID(firebaseAppInstanceId)
        }
        if let brazeAliasName = attributes.brazeAliasName {
            Purchases.shared.attribution.setAttributes(["$brazeAliasName": brazeAliasName])
        }
        if let brazeAliasLabel = attributes.brazeAliasLabel {
            Purchases.shared.attribution.setAttributes(["$brazeAliasLabel": brazeAliasLabel])
        }
        if let installMediaSource = attributes.installMediaSource {
            Purchases.shared.attribution.setMediaSource(installMediaSource)
        }
        if let installAdGroup = attributes.installAdGroup {
            Purchases.shared.attribution.setAdGroup(installAdGroup)
        }
        if let installAd = attributes.installAd {
            Purchases.shared.attribution.setAd(installAd)
        }
        if let installKeyword = attributes.installKeyword {
            Purchases.shared.attribution.setKeyword(installKeyword)
        }
        if let installCreative = attributes.installCreative {
            Purchases.shared.attribution.setCreative(installCreative)
        }
    }

    public func logOut() async throws {
        _ = try await Purchases.shared.logOut()
    }

}

