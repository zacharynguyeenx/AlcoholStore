import Combine
@testable import LiquorStore

final class MockNetworkManager: NetworkManagerProtocol {
    var responses: [String: Any] = [:]

    func request<Response>(
        _: Response.Type, url urlString: String
    ) -> AnyPublisher<Response, NetworkRequestError> where Response: Decodable {
        guard let response = responses[urlString] as? Response else {
            return Fail(error: .badURL).eraseToAnyPublisher()
        }
        return Just(response).setFailureType(to: NetworkRequestError.self).eraseToAnyPublisher()
    }
}
