import Combine
import Foundation

#if DEBUG
    final class MockURLSession: URLSessionProtocol {
        var responseData: [String: Data] = [:]

        func dataTaskPublisher(for url: URL) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
            if let data = responseData[url.absoluteString] {
                return Just((data: data, response: URLResponse())).setFailureType(to: URLError.self).eraseToAnyPublisher()
            } else {
                return Fail(error: URLError(.cancelled)).eraseToAnyPublisher()
            }
        }
    }
#endif
