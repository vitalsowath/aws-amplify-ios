//
//  AvatarView.swift
//  aws-amplify-iso
//
//  Created by Vital SOWATH on 9/11/22.
//

import AmplifyImage
import SwiftUI

enum AvatarState: Equatable {
    case remote(avatarKey: String)
    case local(image: UIImage)
}
struct AvatarView: View {
    
    let state: AvatarState
    let fromMemoryCache: Bool
    
    init(state: AvatarState, fromMemoryCache: Bool = false) {
        self.state = state
        self.fromMemoryCache = fromMemoryCache
    }
    
    var body: some View {
        switch state {
        case .remote(let avatarKey):
            
            AmplifyImage(key: avatarKey)
                .kfImage
                .placeholder {
                    Image(systemName: "person")
                        .resizable()
                        .foregroundColor(.purple)
                        .padding(8)
                        .background(Color.init(white: 0.9))
                        .clipShape(Circle())
                }
                .fromMemoryCacheOrRefresh(fromMemoryCache)
                .scaleToFillWidth()
                .clipShape(Circle())
        case .local(let image):
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
        }
    }
}


