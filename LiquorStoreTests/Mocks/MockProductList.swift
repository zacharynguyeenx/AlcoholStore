import Foundation
@testable import LiquorStore

extension ProductList {
    static func mock(products: [Product] = [.mock()]) -> ProductList {
        .init(products: products)
    }
}

extension Product {
    static func mock(
        id: String = "id",
        title: String = "title",
        imageURL: String = "imageURL",
        price: [Product.Price] = [.mock()],
        ratingCount: Decimal = 1.23,
        brand: String = "brand",
        purchaseTypes: [Product.PurchaseType] = [.mock()],
        totalReviewCount: Int = 1
    ) -> Self {
        .init(
            id: id,
            title: title,
            imageURL: imageURL,
            price: price,
            ratingCount: ratingCount,
            brand: brand,
            purchaseTypes: purchaseTypes,
            totalReviewCount: totalReviewCount
        )
    }
}

extension Product.Price {
    static func mock(
        message: String = "message",
        value: Decimal = 12.34,
        isOfferPrice: Bool = true
    ) -> Self {
        .init(message: message, value: value, isOfferPrice: isOfferPrice)
    }
}

extension Product.PurchaseType {
    static func mock(
        purchaseType: Product.PurchaseType.Kind = .bottle,
        unitPrice: Decimal = 12.34,
        displayName: String = "displayName"
    ) -> Self {
        .init(purchaseType: purchaseType, unitPrice: unitPrice, displayName: displayName)
    }
}
