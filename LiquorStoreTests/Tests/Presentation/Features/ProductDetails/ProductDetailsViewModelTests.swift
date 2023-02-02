import Combine
@testable import LiquorStore
import XCTest

final class ProductDetailsViewModelTests: XCTestCase {
    // MARK: - Private properties

    private var viewModel: ProductDetailsViewModel!
    private var mockFavouriteManager: MockFavouriteManager!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        mockFavouriteManager = .init()
        viewModel = .init(product: .mock(), favouriteManager: mockFavouriteManager)
    }

    override func tearDown() {
        viewModel = nil
        mockFavouriteManager = nil

        super.tearDown()
    }
}

// MARK: - Tests

extension ProductDetailsViewModelTests {
    func test_content() {
        XCTAssertEqual(viewModel.imageURL, "imageURL")
        XCTAssertEqual(viewModel.brand, "brand")
        XCTAssertEqual(viewModel.title, "title")
        XCTAssertEqual(viewModel.totalReviewCount, "(1)")
        XCTAssertEqual(viewModel.ratingCount, "1.2")
        XCTAssertEqual(viewModel.mainPriceItem?.unitPrice, "$12.34")
        XCTAssertEqual(viewModel.mainPriceItem?.displayName, "message")
        XCTAssertEqual(viewModel.otherPriceItems.first?.unitPrice, "$12.34")
        XCTAssertEqual(viewModel.otherPriceItems.first?.displayName, "displayName")
    }

    func test_observeFavourite_on() {
        // Given
        mockFavouriteManager.favouritesPublisher = Just(["id"]).eraseToAnyPublisher()

        // When
        viewModel.observeFavourite()

        // Then
        XCTAssertEqual(viewModel.favouriteButtonIcon, "heart.fill")
        XCTAssertEqual(viewModel.favouriteButtonTitle, "Remove from Favourites")
    }

    func test_observeFavourite_off() {
        // Given
        mockFavouriteManager.favouritesPublisher = Just([]).eraseToAnyPublisher()

        // When
        viewModel.observeFavourite()

        // Then
        XCTAssertEqual(viewModel.favouriteButtonIcon, "heart")
        XCTAssertEqual(viewModel.favouriteButtonTitle, "Add to Favourites")
    }

    func test_toggleFavourite() {
        // When
        viewModel.toggleFavourite()

        // Then
        XCTAssertEqual(mockFavouriteManager.toggleFavouriteCallsCount, 1)
        XCTAssertEqual(mockFavouriteManager.toggleFavouriteReceivedProductID, "id")
    }
}
