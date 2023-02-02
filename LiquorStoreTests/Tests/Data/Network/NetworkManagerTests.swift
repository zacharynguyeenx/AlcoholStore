import Combine
@testable import LiquorStore
import XCTest

final class NetworkManagerTests: XCTestCase {
    // MARK: - Private properties

    private var manager: NetworkManagerProtocol!
    private var mockSession: MockURLSession!
    private var cancellables: Set<AnyCancellable>!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        mockSession = .init()
        manager = NetworkManager(session: mockSession)
        cancellables = []
    }

    override func tearDown() {
        mockSession = nil
        manager = nil
        cancellables = nil

        super.tearDown()
    }
}

// MARK: - Tests

extension NetworkManagerTests {
    func test_request_success() {
        // Given
        let url = "https://www.google.com"
        mockSession.responseData[url] = try! JSONEncoder().encode("response")
        var response: String?

        // When
        manager.request(String.self, url: url).sink(
            receiveCompletion: { _ in },
            receiveValue: {
                response = $0
            }
        )
        .store(in: &cancellables)

        // Then
        XCTAssertEqual(response, "response")
    }

    func test_request_failure_badURL() {
        // Given
        var completion: Subscribers.Completion<NetworkRequestError>?

        // When
        manager.request(String.self, url: "").sink(
            receiveCompletion: { completion = $0 },
            receiveValue: { _ in }
        )
        .store(in: &cancellables)

        // Then
        XCTAssertEqual(completion?.error, .badURL)
    }

    func test_request_failure_networkError() {
        // Given
        mockSession.responseData = [:]
        var completion: Subscribers.Completion<NetworkRequestError>?

        // When
        manager.request(String.self, url: "https://www.google.com").sink(
            receiveCompletion: { completion = $0 },
            receiveValue: { _ in }
        )
        .store(in: &cancellables)

        // Then
        XCTAssertEqual(completion?.error, .network(.init(.cancelled)))
    }

    func test_request_failure_jsonDecoding() {
        // Given
        let url = "https://www.google.com"
        mockSession.responseData[url] = Data()
        var completion: Subscribers.Completion<NetworkRequestError>?

        // When
        manager.request(Int.self, url: url).sink(
            receiveCompletion: { completion = $0 },
            receiveValue: { _ in }
        )
        .store(in: &cancellables)

        // Then
        XCTAssertEqual(completion?.error, .jsonDecoding)
    }
}
