import Combine

extension Subscribers.Completion {
    var error: Failure? {
        guard case let .failure(error) = self else { return nil }
        return error
    }
}
