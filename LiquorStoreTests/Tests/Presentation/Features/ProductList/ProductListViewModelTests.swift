import Combine
@testable import LiquorStore
import XCTest

final class ProductListViewModelTests: XCTestCase {
    // MARK: - Private properties

    private var viewModel: ProductListViewModel!
    private var mockProductService: MockProductService!
    private var mockFavouriteManager: MockFavouriteManager!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        mockProductService = .init()
        mockFavouriteManager = .init()
        viewModel = .init(productService: mockProductService, favouriteManager: mockFavouriteManager)
    }

    override func tearDown() {
        viewModel = nil
        mockProductService = nil
        mockFavouriteManager = nil

        super.tearDown()
    }
}

// MARK: - Tests

extension ProductListViewModelTests {
    func test_title() {
        XCTAssertEqual(viewModel.title, "Home")
    }

    func test_tabBarIcon() {
        XCTAssertEqual(viewModel.tabBarIcon, "house.fill")
    }

    func test_getProductList_success() {
        // When
        setUp_getProductList_success()

        // Then
        XCTAssertEqual(viewModel.items.count, 3)
    }

    func test_getProductList_failure() {
        // Given
        mockProductService.getProductListReturnValue = Fail(error: .badURL).eraseToAnyPublisher()
        let expectation = expectation(description: #function)

        // When
        viewModel.getProductList(completion: expectation.fulfill)

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertTrue(viewModel.showingNetworkError)
    }

    func test_toggleFavourite() {
        // Given
        setUp_getProductList_success()

        // When
        viewModel.items.last?.toggleFavourite()

        // Then
        XCTAssertEqual(mockFavouriteManager.toggleFavouriteCallsCount, 1)
        XCTAssertEqual(mockFavouriteManager.toggleFavouriteReceivedProductID, "3")
    }
}

// MARK: - Private functions

private extension ProductListViewModelTests {
    func setUp_getProductList_success() {
        let productList: [Product] = [.mock(id: "1"), .mock(id: "2"), .mock(id: "3")]
        mockProductService.getProductListReturnValue = Just(.mock(products: productList))
            .setFailureType(to: NetworkRequestError.self)
            .eraseToAnyPublisher()
        mockFavouriteManager.favouritesPublisher = Just(["1", "3"]).eraseToAnyPublisher()

        let expectation = expectation(description: #function)

        viewModel.observeFavourites()
        viewModel.getProductList(completion: expectation.fulfill)

        waitForExpectations(timeout: 1)
    }
}
