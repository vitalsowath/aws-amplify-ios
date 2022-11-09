//
//  HomeRoute.swift
//  aws-amplify-iso
//
//  Created by Vital SOWATH on 9/11/22.
//

import Foundation

enum HomeRoute: Hashable {
    case productDetails(Product)
    case postNewProduct
}

class HomeNavigationCoordinator: ObservableObject {
    @Published var routes: [HomeRoute] = []
}
