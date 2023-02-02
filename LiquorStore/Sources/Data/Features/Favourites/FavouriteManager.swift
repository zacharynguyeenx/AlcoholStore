import Combine
import Foundation

protocol FavouriteManagerProtocol {
    var favouritesPublisher: AnyPublisher<[String], Never> { get }
    func toggleFavourite(for productID: String)
}

final class FavouriteManager: FavouriteManagerProtocol {
    // MARK: - Private properties

    private let userDefaults: UserDefaultsProtocol
    private let favouritesKey = "favourites"
    private let favouritesSubject: CurrentValueSubject<[String], Never>

    // MARK: - Initialisers

    init(userDefaults: UserDefaultsProtocol) {
        self.userDefaults = userDefaults
        favouritesSubject = .init(userDefaults.stringArray(forKey: favouritesKey) ?? [])
    }

    // MARK: - FavouriteManagerProtocol

    var favouritesPublisher: AnyPublisher<[String], Never> {
        favouritesSubject.eraseToAnyPublisher()
    }

    func toggleFavourite(for productID: String) {
        if favouritesSubject.value.contains(productID) {
            favouritesSubject.value.removeAll { $0 == productID }
        } else {
            favouritesSubject.value.append(productID)
        }
        userDefaults.set(favouritesSubject.value, forKey: favouritesKey)
    }
}
