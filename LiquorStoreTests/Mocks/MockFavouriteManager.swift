import Combine
@testable import LiquorStore

final class MockFavouriteManager: FavouriteManagerProtocol {
    var favouritesPublisher: AnyPublisher<[String], Never> = Just([]).eraseToAnyPublisher()

    private(set) var toggleFavouriteCallsCount = 0
    private(set) var toggleFavouriteReceivedProductID: String?

    func toggleFavourite(for productID: String) {
        toggleFavouriteCallsCount += 1
        toggleFavouriteReceivedProductID = productID
    }
}
