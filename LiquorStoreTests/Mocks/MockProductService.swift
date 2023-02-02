import Combine
@testable import LiquorStore

final class MockProductService: ProductServiceProtocol {
    private(set) var getProductListCallsCount = 0
    var getProductListReturnValue: AnyPublisher<ProductList, NetworkRequestError>!

    func getProductList() -> AnyPublisher<ProductList, NetworkRequestError> {
        getProductListCallsCount += 1
        return getProductListReturnValue
    }
}
