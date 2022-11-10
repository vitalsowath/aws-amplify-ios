//
//  MessagesView.swift
//  aws-amplify-iso
//
//  Created by Vital SOWATH on 10/11/22.
//

import SwiftUI
import Amplify
import Combine

struct MessagesView: View {
    
    @EnvironmentObject var userState: UserState
    @State var messages: [Message] = []
    @State var messageBody: String = ""
    @State var tokens: Set<AnyCancellable> = []
    
    let chatRoom: ChatRoom
    let otherUser: User
    let productId: String?
    
    init(chatRoom: ChatRoom, otherUser: User, productId: String? = nil) {
        self.chatRoom = chatRoom
        self.otherUser = otherUser
        self.productId = productId ?? chatRoom.lastMessage?.productId
    }
    
    var body: some View {
        VStack {
            List(messages) { message in
                let sender = message.messageSenderId == userState.userId
                ? User(id: userState.userId, username: userState.username)
                : otherUser
                MessageListCell(message: message, sender: sender)
                    .flip()
            }
            .listStyle(.plain)
            .flip()
            
            HStack {
                TextField("Message", text: $messageBody)
                Button("Send", action: {
                    Task { await sendMessage() }
                })
            }
            .padding()
        }
        .navigationTitle(otherUser.username)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: getMessages)
    }
    
    func getMessages() {
        Amplify.Publisher.create(
            Amplify.DataStore.observeQuery(
                for: Message.self,
                where: Message.keys.chatroomID == chatRoom.id
            )
        )
        .map(\.items)
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: {
                self.messages = $0.sorted(by: { $0.dateTime > $1.dateTime })
            }
        )
        .store(in: &tokens)
    }
    
    func sendMessage() async {
        do {
            let message = Message(
                body: messageBody,
                dateTime: .now(),
                sender: User(
                    id: userState.userId,
                    username: userState.username
                ),
                chatroomID: chatRoom.id,
                messageSenderId: userState.userId
            )
            try await Amplify.DataStore.save(message)
            
            let lastMessage = LastMessage(
                body: messageBody,
                dateTime: .now(),
                productId: productId ?? ""
            )
            var updatedChatRoom = chatRoom
            updatedChatRoom.lastMessage = lastMessage
            try await Amplify.DataStore.save(updatedChatRoom)
            
            messageBody.removeAll()
        } catch {
            print(error)
        }
    }
}
extension View {
    func flip() -> some View {
        return self
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}
