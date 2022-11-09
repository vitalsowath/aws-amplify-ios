//
//  ProductGridCell.swift
//  aws-amplify-iso
//
//  Created by Vital SOWATH on 9/11/22.
//

import SwiftUI
import AmplifyImage

struct ProductGridCell: View {
    
    let product: Product
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AmplifyImage(key: product.imageKey)
                .scaleToFillWidth()
            Text("$\(product.price)")
                .bold()
                .foregroundColor(.white)
                .padding(4)
                .background(Color(white: 0.1, opacity: 0.6))
        }
    }
}
