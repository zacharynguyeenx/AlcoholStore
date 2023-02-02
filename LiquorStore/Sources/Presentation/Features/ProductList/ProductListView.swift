import SwiftUI
import SwiftUIPullToRefresh

struct ProductListView: View {
    // MARK: - Private properties

    private let dependencies: Dependencies

    @StateObject private var viewModel: ProductListViewModel

    @State private var viewDidLoad = false
    @State private var showingFullScreenProgress = true

    // MARK: - Initialisers

    init(dependencies: Dependencies) {
        _viewModel = .init(wrappedValue: .init(dependencies: dependencies))
        self.dependencies = dependencies
    }

    // MARK: - View

    var body: some View {
        NavigationView {
            ZStack {
                RefreshableScrollView(loadingViewBackgroundColor: .clear) { done in
                    viewModel.getProductList(completion: done)
                } content: {
                    LazyVGrid(columns: .init(repeating: .init(.flexible()), count: 2)) {
                        ForEach(viewModel.items) { item in
                            NavigationLink {
                                ProductDetailsView(product: item.product, dependencies: dependencies)
                            } label: {
                                ProductListItemView(item: item)
                            }
                            .buttonStyle(.plain)
                            .padding(4)
                        }
                    }
                    .padding()
                }
                .disabled(showingFullScreenProgress)

                if showingFullScreenProgress {
                    ProgressView()
                }
            }
            .background(Color.cappuccino.ignoresSafeArea())
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if !viewDidLoad {
                    viewModel.observeFavourites()
                    viewModel.getProductList { showingFullScreenProgress = false }
                    viewDidLoad = true
                }
            }
            .alert(isPresented: $viewModel.showingNetworkError) {
                Alert(title: Text("Error"), message: Text("There was a problem getting the products."))
            }
        }
        .tabItem {
            Label(viewModel.title, systemImage: viewModel.tabBarIcon)
        }
    }
}

// MARK: - Previews

struct ProductListViewSuccess_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(dependencies: MockDependencies())
    }
}

struct ProductListViewFailure_Previews: PreviewProvider {
    static var previews: some View {
        let dependencies = MockDependencies()
        dependencies._urlSession.responseData = [:]
        return ProductListView(dependencies: dependencies)
    }
}
