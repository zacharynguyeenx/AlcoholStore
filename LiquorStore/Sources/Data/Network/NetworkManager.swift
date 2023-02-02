import Combine
import Foundation

protocol NetworkManagerProtocol {
    func request<Response>(
        _ type: Response.Type,
        url urlString: String
    ) -> AnyPublisher<Response, NetworkRequestError> where Response: Decodable
}

struct NetworkManager: NetworkManagerProtocol {
    // MARK: - Private properties

    private let session: URLSessionProtocol

    // MARK: - Initialisers

    init(session: URLSessionProtocol) {
        self.session = session
    }

    init(dependencies: Dependencies) {
        self.init(session: dependencies.urlSession)
    }

    // MARK: - NetworkManagerProtocol

    func request<Response>(
        _: Response.Type,
        url urlString: String
    ) -> AnyPublisher<Response, NetworkRequestError> where Response: Decodable {
        guard let url = URL(string: urlString) else {
            return Fail(error: .badURL).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: url)
            .mapError { .network($0) }
            .flatMap { output -> AnyPublisher<Response, NetworkRequestError> in
                guard let response = try? JSONDecoder().decode(Response.self, from: output.data) else {
                    return Fail(error: .jsonDecoding).eraseToAnyPublisher()
                }
                return Just(response).setFailureType(to: NetworkRequestError.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Models

enum NetworkRequestError: Error, Equatable {
    case badURL
    case jsonDecoding
    case network(URLError)
}
