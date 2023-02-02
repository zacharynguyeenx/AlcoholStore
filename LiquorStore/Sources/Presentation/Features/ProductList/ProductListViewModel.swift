import Combine
import SwiftUI

final class ProductListViewModel: ObservableObject {
    // MARK: - Private properties

    private let productService: ProductServiceProtocol
    private let favouriteManager: FavouriteManagerProtocol

    @Published private var products: [Product] = []
    @Published private var favourites: [String] = []

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialisers

    init(productService: ProductServiceProtocol, favouriteManager: FavouriteManagerProtocol) {
        self.productService = productService
        self.favouriteManager = favouriteManager
    }

    convenience init(dependencies: Dependencies) {
        self.init(productService: ProductService(dependencies: dependencies), favouriteManager: dependencies.favouriteManager)
    }

    // MARK: - Public

    let title = "Home"
    let tabBarIcon = "house.fill"

    @Published var showingNetworkError = false

    var items: [ProductListItem] {
        products.map { product in
            ProductListItem(
                product: product,
                isFavourite: favourites.contains(product.id),
                toggleFavourite: { [weak self] in self?.favouriteManager.toggleFavourite(for: product.id) }
            )
        }
    }

    func getProductList(completion: @escaping () -> Void) {
        productService.getProductList()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] in
                    if case .failure = $0 { self?.showingNetworkError = true }
                    completion()
                },
                receiveValue: { [weak self] in self?.products = $0.products }
            )
            .store(in: &cancellables)
    }

    func observeFavourites() {
        favouriteManager.favouritesPublisher
            .sink { [weak self] in self?.favourites = $0 }
            .store(in: &cancellables)
    }
}
