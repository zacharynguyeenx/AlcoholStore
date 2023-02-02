import SwiftUI
import SwiftUIPullToRefresh

struct FavouritesView: View {
    // MARK: - Private properties

    @StateObject private var viewModel: FavouritesViewModel
    private let dependencies: Dependencies

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
                    viewModel.getProductList { showingFullScreenProgress = false }
                    viewDidLoad = true
                }
                viewModel.observeFavourites()
            }
            .onDisappear {
                viewModel.stopObservingFavourites()
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

struct FavouritesViewSuccess_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView(dependencies: MockDependencies())
    }
}

struct FavouritesViewFailure_Previews: PreviewProvider {
    static var previews: some View {
        let dependencies = MockDependencies()
        dependencies._urlSession.responseData = [:]
        return FavouritesView(dependencies: dependencies)
    }
}
