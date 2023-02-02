import Kingfisher
import SwiftUI

struct ProductDetailsView: View {
    // MARK: - Private properties

    @StateObject private var viewModel: ProductDetailsViewModel

    @Environment(\.presentationMode) private var presentationMode

    @State private var viewDidLoad = false
    @State private var imageLoaded = false

    // MARK: - Initialisers

    init(product: Product, dependencies: Dependencies) {
        _viewModel = StateObject(wrappedValue: ProductDetailsViewModel(product: product, dependencies: dependencies))
    }

    // MARK: - View

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 8) {
                    image
                    info
                    mainPrice
                    otherPrices
                }
                .padding()
            }
            Spacer()

            toggleFavouriteButton
        }
        .background(Color.moth.ignoresSafeArea())
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden()
        .toolbar { backButton }
        .onAppear {
            if !viewDidLoad {
                viewModel.observeFavourite()
                viewDidLoad = true
            }
        }
    }
}

// MARK: - Private functions

private extension ProductDetailsView {
    var image: some View {
        ZStack {
            KFImage.url(.init(string: viewModel.imageURL))
                .onSuccess { _ in imageLoaded = true }
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 300)
            if !imageLoaded {
                ProgressView()
            }
        }
        .padding()
    }

    @ViewBuilder var info: some View {
        HStack {
            Text(viewModel.brand)
                .font(.system(size: 28, weight: .semibold))
            Spacer()
        }
        HStack(spacing: 2) {
            Text(viewModel.title)
                .opacity(0.9)
            Spacer()
            Image(systemName: "star.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.hinterlandsGreen)
                .frame(height: 14)
            Text(viewModel.ratingCount).bold()
            Text(viewModel.totalReviewCount)
                .opacity(0.9)
        }
        .font(.system(size: 15))
        .padding(.bottom, 12)
    }

    @ViewBuilder var mainPrice: some View {
        if let mainPriceItem = viewModel.mainPriceItem {
            HStack {
                Text(mainPriceItem.unitPrice)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Color.raceCarRed)
                Text(mainPriceItem.displayName)
                    .foregroundColor(Color.moth)
                    .bold()
                    .padding([.top, .bottom], 4)
                    .padding([.leading, .trailing], 12)
                    .background(Color.raceCarRed)
                    .clipShape(Capsule())
                Spacer()
            }
        }
    }

    var otherPrices: some View {
        ForEach(viewModel.otherPriceItems) { item in
            HStack(spacing: 0) {
                Text(item.unitPrice).bold()
                Text(" \(item.displayName)")
                Spacer()
            }
        }
    }

    var toggleFavouriteButton: some View {
        Button {
            viewModel.toggleFavourite()
        } label: {
            HStack {
                Spacer()
                Image(systemName: viewModel.favouriteButtonIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 14)
                Text(viewModel.favouriteButtonTitle)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding([.top, .bottom], 16)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.hinterlandsGreen, lineWidth: 1))
        }
        .padding()
        .foregroundColor(Color.hinterlandsGreen)
    }

    var backButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.left").foregroundColor(.black)
            }
        }
    }
}

// MARK: - Previews

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            let product = Product(
                id: "1",
                title: "Koonunga Hill Cabernet Sauvignon",
                imageURL: "https://media.danmurphys.com.au/dmo/product/906199-1.png?impolicy=PROD_SM",
                price: [.init(message: "in any six", value: 9.40, isOfferPrice: false)],
                ratingCount: 4.4167,
                brand: "Penfolds",
                purchaseTypes: [
                    .init(purchaseType: .bottle, unitPrice: 10.18, displayName: "per bottle"),
                    .init(purchaseType: .case, unitPrice: 56.85, displayName: "per case of 6"),
                ],
                totalReviewCount: 11
            )
            ProductDetailsView(product: product, dependencies: MockDependencies())
        }
    }
}
