import Combine
import SwiftUI

final class FavouritesViewModel: ObservableObject {
    // MARK: - Private properties

    private let productService: ProductServiceProtocol
    private let favouriteManager: FavouriteManagerProtocol

    @Published private var products: [Product] = []
    @Published private var favourites: [String] = []

    private var productListCancellable: AnyCancellable?
    private var favouritesCancellable: AnyCancellable?

    // MARK: - Initialisers

    init(productService: ProductServiceProtocol, favouriteManager: FavouriteManagerProtocol) {
        self.productService = productService
        self.favouriteManager = favouriteManager
    }

    convenience init(dependencies: Dependencies) {
        self.init(productService: ProductService(dependencies: dependencies), favouriteManager: dependencies.favouriteManager)
    }

    // MARK: - Public

    let title = "Favourites"
    let tabBarIcon = "heart.fill"

    @Published var showingNetworkError = false

    var items: [ProductListItem] {
        favourites
            .reversed()
            .compactMap { favourite in
                products.first { $0.id == favourite }
            }
            .map { product in
                ProductListItem(
                    product: product,
                    isFavourite: true,
                    toggleFavourite: { [weak self] in self?.favouriteManager.toggleFavourite(for: product.id) }
                )
            }
    }

    func getProductList(completion: @escaping () -> Void) {
        productListCancellable = productService.getProductList()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] in
                    if case .failure = $0 { self?.showingNetworkError = true }
                    completion()
                },
                receiveValue: { [weak self] in self?.products = $0.products }
            )
    }

    func observeFavourites() {
        favouritesCancellable = favouriteManager.favouritesPublisher.sink { [weak self] in self?.favourites = $0 }
    }

    func stopObservingFavourites() {
        favouritesCancellable = nil
    }
}
