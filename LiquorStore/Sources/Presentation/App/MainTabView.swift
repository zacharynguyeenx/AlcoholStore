import SwiftUI

struct MainTabView: View {
    // MARK: - Public properties

    let dependencies: Dependencies

    // MARK: - View

    var body: some View {
        TabView {
            ProductListView(dependencies: dependencies)
            FavouritesView(dependencies: dependencies)
        }
        .accentColor(Color.hinterlandsGreen)
    }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(dependencies: MockDependencies())
    }
}
