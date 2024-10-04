# RevenueCat for SwiftfulPurchasing ✅

Add RevenueCat support to a Swift application through SwiftfulPurchasing framework.

See documentation in the parent repo: https://github.com/SwiftfulThinking/SwiftfulPurchasing.git

## Example configuration:
```swift
// Example
#if DEBUG
let purchaseManager = PurchaseManager(service: MockPurchaseService(activeEntitlements: []))
#else
let purchaseManager = PurchaseManager(service: RevenueCatPurchaseService(apiKey: revenueCatApiKey, productIds: allProductIds, logLevel: .warn))
#endif
```

## Example actions:

You may call identifyUser every app launch.

```swift
try await purchaseManager.getAvailableProducts()
try await purchaseManager.purchaseProduct(productId: String)
try await purchaseManager.restorePurchase()
try await purchaseManager.logIn(userId: String, email: String?)
try await purchaseManager.logOut()
```
