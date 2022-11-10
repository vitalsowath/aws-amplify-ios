//
//  MessageListCell.swift
//  aws-amplify-iso
//
//  Created by Vital SOWATH on 10/11/22.
//

import SwiftUI

struct MessageListCell: View {
        
    let message: Message
    let sender: User
    
    var senderAvatarKey: String {
        sender.id + ".jpg"
    }
    var sendDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: message.createdAt?.foundationDate ?? .now)
    }
    
    var body: some View {
        HStack {
            AvatarView(state: .remote(avatarKey: senderAvatarKey))
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(sender.username)
                        .bold()
                    Text(sendDate)
                        .font(.footnote)
                    Spacer()
                }
                Text(message.body)
            }
        }
    }
}
