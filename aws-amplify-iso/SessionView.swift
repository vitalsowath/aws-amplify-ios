//
//  SessionView.swift
//  aws-amplify-iso
//
//  Created by Vital SOWATH on 4/11/22.
//

import SwiftUI
import Amplify
import Combine

struct SessionView: View {
    
    @StateObject var userState: UserState = .init()
    @State var isSignedIn: Bool = false
    @State var tokens: Set<AnyCancellable> = []
    
    var body: some View {
        StartingView()
            .environmentObject(userState)
            .onAppear {
                self.getCurrentSession()
                self.observeSession()
            }
    }
    
    @ViewBuilder
    func StartingView() -> some View {
        if isSignedIn {
            Text("Signed in")
        } else {
            LoginView()
        }
    }
    
    func getCurrentSession() {
        Amplify.Auth.fetchAuthSession { result in
            
            switch result {
            case .success(let session):
                if session.isSignedIn {
                    DispatchQueue.main.async {
                        self.isSignedIn = session.isSignedIn
                    }
                }
            default:
                return
            }
            
            guard let authUser = Amplify.Auth.getCurrentUser() else {return}
            self.userState.userId = authUser.userId
            self.userState.username = authUser.username
            
            Amplify.DataStore.query(User.self, byId: self.userState.userId) { result in
                switch result {
                case .success(let user):
                    if let existingUser = user {
                        print("Existing user: \(existingUser)")
                    } else {
                        let newUser = User(
                            id: authUser.userId,
                            username: authUser.username
                        )
                        let savedUser = Amplify.DataStore.save(newUser)
                        print("Created user: \(savedUser)")
                    }
                case .failure(let dataStoreError):
                    print("\(dataStoreError)")
                }
            }
        }
    }
    
    func observeSession() {
        Amplify.Hub.publisher(for: .auth)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { payload in
                    switch payload.eventName {
                    case HubPayload.EventName.Auth.signedIn:
                        self.isSignedIn = true
                        self.getCurrentSession()
                    case HubPayload.EventName.Auth.signedOut, HubPayload.EventName.Auth.sessionExpired:
                        self.isSignedIn = false
                    default:
                        break
                    }
                }
            )
            .store(in: &tokens)
    }
}
