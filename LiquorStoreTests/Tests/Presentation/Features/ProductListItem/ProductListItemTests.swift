@testable import LiquorStore
import XCTest

final class ProductListItemTests: XCTestCase {
    // MARK: - Tests

    func test_content() {
        // Given
        let product = Product.mock()

        // When
        let item = ProductListItem(product: product, isFavourite: true, toggleFavourite: {})

        // Then
        XCTAssertEqual(item.product, product)
        XCTAssertEqual(item.id, "id")
        XCTAssertEqual(item.imageURL, "imageURL")
        XCTAssertEqual(item.brand, "brand")
        XCTAssertEqual(item.title, "title")
        XCTAssertEqual(item.price, "$12.34")
    }

    func test_isFavourite_on() {
        // When
        let item = ProductListItem(product: .mock(), isFavourite: true, toggleFavourite: {})

        // Then
        XCTAssertEqual(item.favouriteIcon, "heart.fill")
    }

    func test_isFavourite_off() {
        // When
        let item = ProductListItem(product: .mock(), isFavourite: false, toggleFavourite: {})

        // Then
        XCTAssertEqual(item.favouriteIcon, "heart")
    }

    func test_toggleFavourite() {
        // Given
        var toggleFavouriteCalled = false
        let item = ProductListItem(
            product: .mock(), isFavourite: true, toggleFavourite: {
                toggleFavouriteCalled = true
            }
        )

        // When
        item.toggleFavourite()

        // Then
        XCTAssertTrue(toggleFavouriteCalled)
    }
}
