import Foundation

struct ProductListItem: Identifiable {
    let product: Product
    let id: String
    let imageURL: String
    let brand: String
    let title: String
    let price: String
    let favouriteIcon: String
    let toggleFavourite: () -> Void

    init(product: Product, id: String, imageURL: String, brand: String, title: String, price: String, favouriteIcon: String, toggleFavourite: @escaping () -> Void) {
        self.product = product
        self.id = id
        self.imageURL = imageURL
        self.brand = brand
        self.title = title
        self.price = price
        self.favouriteIcon = favouriteIcon
        self.toggleFavourite = toggleFavourite
    }
}

extension ProductListItem {
    init(product: Product, isFavourite: Bool, toggleFavourite: @escaping () -> Void) {
        let price = product.price.first.flatMap {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            return formatter.string(from: $0.value as NSDecimalNumber)
        } ?? ""
        self.init(
            product: product,
            id: product.id,
            imageURL: product.imageURL,
            brand: product.brand,
            title: product.title,
            price: price,
            favouriteIcon: isFavourite ? "heart.fill" : "heart",
            toggleFavourite: toggleFavourite
        )
    }
}
