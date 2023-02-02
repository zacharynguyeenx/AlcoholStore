import SwiftUI

@main
struct LiquorStoreApp: App {
    // MARK: - Initialisers

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.cappuccino)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        UITabBar.appearance().barTintColor = UIColor(Color.cappuccino)
    }

    // MARK: - App

    var body: some Scene {
        WindowGroup {
            MainTabView(dependencies: StandardDependencies())
                .preferredColorScheme(.light)
        }
    }
}
