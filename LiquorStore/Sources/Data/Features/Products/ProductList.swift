import Foundation

struct ProductList: Codable, Equatable {
    let products: [Product]
}

struct Product: Codable, Equatable {
    let id: String
    let title: String
    let imageURL: String
    let price: [Price]
    let ratingCount: Decimal
    let brand: String
    let purchaseTypes: [PurchaseType]
    let totalReviewCount: Int
}

extension Product {
    struct Price: Codable, Equatable {
        let message: String
        let value: Decimal
        let isOfferPrice: Bool
    }

    struct PurchaseType: Codable, Equatable {
        let purchaseType: Kind
        let unitPrice: Decimal
        let displayName: String

        enum Kind: String, Codable {
            case bottle = "Bottle"
            case `case` = "Case"
        }
    }
}
