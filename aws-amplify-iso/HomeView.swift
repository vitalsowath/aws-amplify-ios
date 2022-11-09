//
//  HomeView.swift
//  aws-amplify-iso
//
//  Created by Vital SOWATH on 9/11/22.
//

import SwiftUI
import Amplify
import Combine

struct HomeView: View {
    
    @StateObject var navigationCoordinator: HomeNavigationCoordinator = .init()
    @State var products: [Product] = []
    @State var tokens: Set<AnyCancellable> = []
    
    let columns = Array(repeating: GridItem(.flexible(minimum: 150)), count: 2)
    
    var body: some View {
        NavigationStack(path: $navigationCoordinator.routes) {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(products) { product in
                        NavigationLink(value: HomeRoute.productDetails(product)) {
                            ProductGridCell(product: product)
                        }
                    }
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem {
                    Button(
                        action: { navigationCoordinator.routes.append(.postNewProduct) },
                        label: { Image(systemName: "plus") }
                    )
                }
            }
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case .postNewProduct:
                    PostProductView()
                case .productDetails(let product):
                    ProductDetailsView(product: product)
                        .environmentObject(navigationCoordinator)
                }
            }
        }
        .onAppear(perform: observeProducts)
    }
    
    func observeProducts() {
        Amplify.Publisher.create(
            Amplify.DataStore.observeQuery(for: Product.self)
        )
        .map(\.items)
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { products in
                self.products = products.sorted {
                    guard
                        let date1 = $0.createdAt,
                        let date2 = $1.createdAt
                    else { return false }
                    return date1 > date2
                }
            }
        )
        .store(in: &tokens)
    }
}
