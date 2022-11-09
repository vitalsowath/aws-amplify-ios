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
                Task { await getCurrentSession() }
                self.observeSession()
            }
    }
    
    @ViewBuilder
    func StartingView() -> some View {
        if isSignedIn {
            MainTabView()
        } else {
            LoginView()
        }
    }
    
    func getCurrentSession() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            DispatchQueue.main.async {
                self.isSignedIn = session.isSignedIn
            }
            guard session.isSignedIn else { return }
            
            let authUser = try await Amplify.Auth.getCurrentUser()
            self.userState.userId = authUser.userId
            self.userState.username = authUser.username
            
            let user = try await Amplify.DataStore.query(
                User.self,
                byId: authUser.userId
            )
            
            if let existingUser = user {
                print("Existing user: \(existingUser)")
            } else {
                let newUser = User(
                    id: authUser.userId,
                    username: authUser.username
                )
                let savedUser = try await Amplify.DataStore.save(newUser)
                print("Created user: \(savedUser)")
            }
        } catch {
            print(error)
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
                        Task { await getCurrentSession() }
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
