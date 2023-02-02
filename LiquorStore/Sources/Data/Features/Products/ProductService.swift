import Combine
import Foundation

protocol ProductServiceProtocol {
    func getProductList() -> AnyPublisher<ProductList, NetworkRequestError>
}

struct ProductService: ProductServiceProtocol {
    // MARK: - Private properties

    private let networkManager: NetworkManagerProtocol

    // MARK: - Initialisers

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    init(dependencies: Dependencies) {
        self.init(networkManager: NetworkManager(dependencies: dependencies))
    }

    // MARK: - ProductServiceProtocol

    func getProductList() -> AnyPublisher<ProductList, NetworkRequestError> {
        networkManager.request(ProductList.self, url: "https://run.mocky.io/v3/2f06b453-8375-43cf-861a-06e95a951328")
    }
}
