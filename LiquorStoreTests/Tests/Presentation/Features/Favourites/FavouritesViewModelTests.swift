import Combine
@testable import LiquorStore
import XCTest

final class FavouritesViewModelTests: XCTestCase {
    // MARK: - Private properties

    private var viewModel: FavouritesViewModel!
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

extension FavouritesViewModelTests {
    func test_title() {
        XCTAssertEqual(viewModel.title, "Favourites")
    }

    func test_tabBarIcon() {
        XCTAssertEqual(viewModel.tabBarIcon, "heart.fill")
    }

    func test_getProductList_success() {
        // When
        setUp_getProductList_success()

        // Then
        XCTAssertEqual(viewModel.items.count, 2)
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
        XCTAssertEqual(mockFavouriteManager.toggleFavouriteReceivedProductID, "1")
    }
}

// MARK: - Private functions

private extension FavouritesViewModelTests {
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
