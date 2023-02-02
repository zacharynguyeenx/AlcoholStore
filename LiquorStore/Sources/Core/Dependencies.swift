import Foundation

protocol Dependencies {
    var urlSession: URLSessionProtocol { get }
    var userDefaults: UserDefaultsProtocol { get }
    var favouriteManager: FavouriteManagerProtocol { get }
}

final class StandardDependencies: Dependencies {
    let urlSession: URLSessionProtocol
    let userDefaults: UserDefaultsProtocol
    let favouriteManager: FavouriteManagerProtocol

    init() {
        urlSession = URLSession.shared
        userDefaults = UserDefaults.standard
        favouriteManager = FavouriteManager(userDefaults: userDefaults)
    }
}
