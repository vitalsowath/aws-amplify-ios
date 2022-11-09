//
//  UserProfileView.swift
//  aws-amplify-iso
//
//  Created by Vital SOWATH on 9/11/22.
//

import Amplify
import Combine
import SwiftUI

struct UserProfileView: View {
    
    @EnvironmentObject var userState: UserState
    @State var isImagePickerVisible: Bool = false
    @State var newAvatarImage: UIImage?
    @State var products: [Product] = []
    @State var tokens: Set<AnyCancellable> = []
    
    let columns = Array(repeating: GridItem(.flexible(minimum: 150)), count: 2)
    var avatarState: AvatarState {
        newAvatarImage.flatMap({ AvatarState.local(image: $0) })
        ?? .remote(avatarKey: userState.userAvatarKey)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    isImagePickerVisible = true
                }) {
                    AvatarView(
                        state: avatarState,
                        fromMemoryCache: true
                    )
                    .frame(width: 75, height: 75)
                    .onChange(of: avatarState) { _ in
                        Task {await uploadNewAvatar()}
                    }
                }
                Text(userState.username)
                    .font(.headline)
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(products) { product in
                            ProductGridCell(product: product)
                        }
                    }
                }
            }
            .navigationTitle("My Account")
            .sheet(isPresented: $isImagePickerVisible) {
                ImagePickerView(image: $newAvatarImage)
            }
            .toolbar {
                ToolbarItem {
                    Button(
                        action: {
                            Task {
                                await signOut()
                            }
                        },
                        label: { Image(systemName: "rectangle.portrait.and.arrow.right") }
                    )
                }
            }
        }.onAppear(perform: observeCurrentUsersProducts)
    }
    
    func signOut() async {
        do {
            _ = await Amplify.Auth.signOut()
            print("Signed out")
            _ = try await Amplify.DataStore.clear()
        } catch {
            print(error)
        }
    }
    
    func uploadNewAvatar() async {
        guard let avatarData = newAvatarImage?.jpegData(compressionQuality: 1) else { return }
        do {
            let avatarKey = try await Amplify.Storage.uploadData(
                key: userState.userAvatarKey,
                data: avatarData
            ).value
            print("Finished uploading:", avatarKey)
        } catch {
            print(error)
        }
    }
    
    func observeCurrentUsersProducts() {
        Amplify.Publisher.create(
            Amplify.DataStore.observeQuery(
                for: Product.self,
                where: Product.keys.userId == userState.userId
            )
        )
        .map(\.items)
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { products in
                print("Product count:", products.count)
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
