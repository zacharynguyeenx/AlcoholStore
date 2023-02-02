import Kingfisher
import SwiftUI

struct ProductListItemView: View {
    // MARK: - Public

    let item: ProductListItem

    // MARK: - Private properties

    @State private var imageLoaded = false

    // MARK: - View

    var body: some View {
        ZStack {
            Color.moth

            VStack(spacing: 8) {
                image
                texts
                addToCartButton
            }
            .padding()

            toggleFavouriteButton
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Private functions

private extension ProductListItemView {
    var image: some View {
        ZStack {
            KFImage.url(.init(string: item.imageURL))
                .onSuccess { _ in imageLoaded = true }
                .resizable()
                .scaledToFit()
                .frame(height: 150)
            if !imageLoaded {
                ProgressView()
            }
        }
    }

    var texts: some View {
        Group {
            Text(item.brand)
                .font(.system(size: 15, weight: .medium))
                .padding(.top, 16)
            Text(item.title)
                .font(.system(size: 12))
                .opacity(0.7)
            Text(item.price)
                .font(.system(size: 12, weight: .medium))
        }
        .multilineTextAlignment(.center)
    }

    var addToCartButton: some View {
        Button {
            print("Add to cart")
        } label: {
            HStack {
                Spacer()
                Image(systemName: "cart")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 14)
                Text("Add to cart")
                    .font(.system(size: 12, weight: .medium))
                Spacer()
            }
            .padding([.top, .bottom], 8)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.hinterlandsGreen, lineWidth: 1))
        }
        .foregroundColor(Color.hinterlandsGreen)
    }

    var toggleFavouriteButton: some View {
        HStack {
            Spacer()
            VStack {
                Button {
                    withAnimation { item.toggleFavourite() }
                } label: {
                    Image(systemName: item.favouriteIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 12)
                        .foregroundColor(Color.hinterlandsGreen)
                        .padding(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.hinterlandsGreen, lineWidth: 1))
                }
                .padding()
                Spacer()
            }
        }
    }
}

// MARK: - Previews

struct ProductListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let product = Product(id: "", title: "", imageURL: "", price: [], ratingCount: 0, brand: "", purchaseTypes: [], totalReviewCount: 0)
        let successItem = ProductListItem(
            product: product,
            id: "1",
            imageURL: "https://media.danmurphys.com.au/dmo/product/23124-1.png?impolicy=PROD_SM",
            brand: "Rosemount",
            title: "Diamond Label Shiraz",
            price: "$10.18",
            favouriteIcon: "heart.fill",
            toggleFavourite: {}
        )
        let loadingItem = ProductListItem(
            product: product,
            id: "2",
            imageURL: "",
            brand: "Rosemount",
            title: "Diamond Label Shiraz",
            price: "$10.18",
            favouriteIcon: "heart",
            toggleFavourite: {}
        )
        ScrollView {
            VStack(spacing: 10) {
                ProductListItemView(item: successItem).frame(width: 200)
                ProductListItemView(item: loadingItem).frame(width: 200)
            }
        }
    }
}
