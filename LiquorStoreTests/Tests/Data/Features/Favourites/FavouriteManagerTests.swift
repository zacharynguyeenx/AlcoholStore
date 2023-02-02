import Combine
@testable import LiquorStore
import XCTest

final class FavouriteManagerTests: XCTestCase {
    // MARK: - Private properties

    private var manager: FavouriteManagerProtocol!
    private var mockUserDefaults: MockUserDefaults!
    private var cancellables: Set<AnyCancellable>!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        mockUserDefaults = .init()
        mockUserDefaults.values["favourites"] = ["1", "2"]

        manager = FavouriteManager(userDefaults: mockUserDefaults)
        cancellables = []
    }

    override func tearDown() {
        mockUserDefaults = nil
        manager = nil
        cancellables = nil

        super.tearDown()
    }
}

// MARK: - Tests

extension FavouriteManagerTests {
    func test_initialFavourites() {
        // Given
        var favourites: [String]?

        // When
        manager.favouritesPublisher
            .sink { favourites = $0 }
            .store(in: &cancellables)

        // Then
        XCTAssertEqual(favourites, ["1", "2"])
    }

    func test_toggleFavourites() {
        // Given
        var favourites: [String]?
        manager.favouritesPublisher
            .sink { favourites = $0 }
            .store(in: &cancellables)

        // When
        manager.toggleFavourite(for: "1")
        manager.toggleFavourite(for: "3")

        // Then
        let expectedFavourites = ["2", "3"]
        XCTAssertEqual(favourites, expectedFavourites)
        XCTAssertEqual(mockUserDefaults.values["favourites"] as? [String], expectedFavourites)
    }
}
