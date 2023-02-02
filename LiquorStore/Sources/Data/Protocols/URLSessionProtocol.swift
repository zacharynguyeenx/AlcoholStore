import Combine
import Foundation

protocol URLSessionProtocol {
    func dataTaskPublisher(for url: URL) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
}

extension URLSession: URLSessionProtocol {
    func dataTaskPublisher(for url: URL) -> AnyPublisher<DataTaskPublisher.Output, DataTaskPublisher.Failure> {
        let publisher: URLSession.DataTaskPublisher = dataTaskPublisher(for: url)
        return publisher.eraseToAnyPublisher()
    }
}
