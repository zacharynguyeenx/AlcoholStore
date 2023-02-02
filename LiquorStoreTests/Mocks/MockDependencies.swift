import Foundation

#if DEBUG
    final class MockDependencies: Dependencies {
        var urlSession: URLSessionProtocol { _urlSession }
        var userDefaults: UserDefaultsProtocol { _userDefaults }
        var favouriteManager: FavouriteManagerProtocol { _favouriteManager }

        private(set) lazy var _urlSession = {
            let session = MockURLSession()
            session.responseData["https://run.mocky.io/v3/2f06b453-8375-43cf-861a-06e95a951328"] = Bundle.main
                .url(forResource: "product-list", withExtension: "json")
                .flatMap { try? Data(contentsOf: $0) }
            return session
        }()

        let _userDefaults = MockUserDefaults()

        private(set) lazy var _favouriteManager = {
            let manager = FavouriteManager(userDefaults: userDefaults)
            ["322002", "346878", "27703", "723049", "750048"].forEach(manager.toggleFavourite(for:))
            return manager
        }()
    }
#endif
