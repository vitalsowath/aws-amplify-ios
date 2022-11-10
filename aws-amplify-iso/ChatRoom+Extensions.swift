//
//  ChatRoom+Extensions.swift
//  aws-amplify-iso
//
//  Created by Vital SOWATH on 10/11/22.
//

extension ChatRoom: Identifiable {}

extension ChatRoom: Hashable {
    public static func == (lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        lhs.id == rhs.id &&
        lhs.memberIDs == rhs.memberIDs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(memberIDs)
    }
}

extension ChatRoom {
    func otherMemberId(currentUser id: String) -> String {
        let otherMemberId = self.memberIDs?.first {
            $0 != id
        }
        return otherMemberId ?? ""
    }
}
