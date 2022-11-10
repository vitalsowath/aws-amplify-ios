//
//  InboxView.swift
//  aws-amplify-iso
//
//  Created by Vital SOWATH on 10/11/22.
//

import SwiftUI
import Amplify
import Combine


struct InboxView: View {
    
    @EnvironmentObject var userState: UserState
    @State var chatRooms: [ChatRoom] = []
    @State var users: [User] = []
    @State var tokens: Set<AnyCancellable> = []
    
    var chatRoomAndMemberList: [(chatRoom: ChatRoom, user: User)] {
        let pairs = chatRooms.compactMap { chatRoom -> (ChatRoom, User)? in
            let otherUserId = chatRoom.otherMemberId(
                currentUser: userState.userId
            )
            guard let user = users.first(where: {$0.id == otherUserId}) else { return nil }
            return (chatRoom, user)
        }
        return pairs
    }
    
    var body: some View {
        NavigationStack {
            List(chatRoomAndMemberList, id: \.0.id) { pair in
                NavigationLink(value: ChatRoute.chatRoom(pair.chatRoom, pair.user)) {
                    if let lastMessage = pair.chatRoom.lastMessage {
                        InboxListCell(
                            otherChatRoomMember: pair.user,
                            lastMessage: lastMessage
                        )
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Inbox")
            .navigationDestination(for: ChatRoute.self) { route in
                switch route {
                case .chatRoom(let chatRoom, let user):
                    MessagesView(chatRoom: chatRoom, otherUser: user)
                }
            }
        }
        .onAppear(perform: getChatRoomsAndUsers)
    }
    
    func getChatRoomsAndUsers() {
        Amplify.Publisher.create(
            Amplify.DataStore.observeQuery(
                for: ChatRoom.self,
                where: ChatRoom.keys.memberIDs.contains(userState.userId)
            )
        )
        .map(\.items)
        .flatMap({ chatRooms -> AnyPublisher<(chatRooms: [ChatRoom], users: [User]), Error> in
            let ids: [String] = chatRooms.map {
                $0.otherMemberId(currentUser: userState.userId)
            }
            
            let predicates: [QueryPredicate] = ids.map {
                User.keys.id == $0
            }
            
            let predicateGroup = QueryPredicateGroup(type: .or, predicates: predicates)
            
            return Amplify.Publisher.create {
                try await Amplify.DataStore.query(User.self, where: predicateGroup)
            }
            .map { (chatRooms, $0) }
            .eraseToAnyPublisher()
        })
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion:  { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            },
            receiveValue: { results in
                self.chatRooms = results.chatRooms
                self.users = results.users
            }
        )
        .store(in: &tokens)
    }
}

