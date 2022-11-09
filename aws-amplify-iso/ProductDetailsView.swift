//
//  ProductDetailsView.swift
//  aws-amplify-iso
//
//  Created by Vital SOWATH on 9/11/22.
//

import Amplify
import AmplifyImage
import SwiftUI

struct ProductDetailsView: View {
    
    @EnvironmentObject var userState: UserState
    @Environment(\.dismiss) var dismiss
    
    let product: Product
    
    var body: some View {
        ScrollView {
            VStack {
                AmplifyImage(key: product.imageKey)
                    .scaleToFillWidth()
                
                Text("$\(product.price)")
                    .font(.largeTitle)
                
                product.productDescription.flatMap(Text.init)
                
                if userState.userId != product.userId {
                    Button("Chat", action: {})
                } else {
                    Button("Delete product", action: {
                        Task { await deleteProduct() }
                    })
                }
            }
            .navigationTitle(product.name ?? "")
        }
    }
    
    func deleteProduct() async {
        do {
            try await Amplify.DataStore.delete(product)
            print("Deleted product \(product.id)")
            
            let productImageKey = product.id + ".jpg"
            try await Amplify.Storage.remove(key: productImageKey)
            print("Deleted file: \(productImageKey)")
            
            dismiss.callAsFunction()
        } catch {
            print(error)
        }
    }
}
