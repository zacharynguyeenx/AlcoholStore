import Combine
import SwiftUI

final class ProductDetailsViewModel: ObservableObject {
    // MARK: - Private properties

    private let product: Product
    private let favouriteManager: FavouriteManagerProtocol

    @Published private var isFavourite = false

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle

    init(product: Product, favouriteManager: FavouriteManagerProtocol) {
        self.product = product
        self.favouriteManager = favouriteManager
    }

    convenience init(product: Product, dependencies: Dependencies) {
        self.init(product: product, favouriteManager: dependencies.favouriteManager)
    }

    // MARK: - Public

    var imageURL: String { product.imageURL }
    var brand: String { product.brand }
    var title: String { product.title }
    var totalReviewCount: String { "(\(product.totalReviewCount.description))" }
    var favouriteButtonIcon: String { isFavourite ? "heart.fill" : "heart" }
    var favouriteButtonTitle: String { isFavourite ? "Remove from Favourites" : "Add to Favourites" }

    var ratingCount: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter.string(from: product.ratingCount as NSDecimalNumber) ?? "-"
    }

    var mainPriceItem: PriceItem? {
        product.price.first.map { .init(unitPrice: $0.value, displayName: $0.message) }
    }

    var otherPriceItems: [PriceItem] {
        product.purchaseTypes.map { .init(unitPrice: $0.unitPrice, displayName: $0.displayName) }
    }

    func observeFavourite() {
        favouriteManager.favouritesPublisher.sink { [weak self] in
            guard let self else { return }
            self.isFavourite = $0.contains(self.product.id)
        }
        .store(in: &cancellables)
    }

    func toggleFavourite() { favouriteManager.toggleFavourite(for: product.id) }
}

// MARK: - Models

extension ProductDetailsViewModel {
    struct PriceItem: Identifiable {
        let id = UUID()
        let unitPrice: String
        let displayName: String

        init(unitPrice: Decimal, displayName: String) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            self.unitPrice = numberFormatter.string(from: unitPrice as NSDecimalNumber) ?? "-"
            self.displayName = displayName
        }
    }
}
