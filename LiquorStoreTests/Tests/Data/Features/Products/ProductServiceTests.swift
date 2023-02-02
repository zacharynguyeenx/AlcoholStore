import Combine
@testable import LiquorStore
import XCTest

final class ProductServiceTests: XCTestCase {
    // MARK: - Private properties

    private var service: ProductServiceProtocol!
    private var mockNetworkManager: MockNetworkManager!
    private var cancellables: Set<AnyCancellable>!

    private let url = "https://run.mocky.io/v3/2f06b453-8375-43cf-861a-06e95a951328"

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        mockNetworkManager = .init()
        service = ProductService(networkManager: mockNetworkManager)
        cancellables = []
    }

    override func tearDown() {
        service = nil
        mockNetworkManager = nil
        cancellables = nil

        super.tearDown()
    }
}

// MARK: - Tests

extension ProductServiceTests {
    func test_getProductList_success() {
        // Given
        mockNetworkManager.responses[url] = ProductList(products: [])
        var productList: ProductList?

        // When
        service.getProductList().sink(
            receiveCompletion: { _ in },
            receiveValue: { productList = $0 }
        )
        .store(in: &cancellables)

        // Then
        XCTAssertEqual(productList, .init(products: []))
    }

    func test_getProductList_failure() {
        // Given
        mockNetworkManager.responses = [:]
        var completion: Subscribers.Completion<NetworkRequestError>?

        // When
        service.getProductList().sink(
            receiveCompletion: { completion = $0 },
            receiveValue: { _ in }
        )
        .store(in: &cancellables)

        // Then
        XCTAssertEqual(completion?.error, .badURL)
    }
}
