//
//  User+Extensions.swift
//  aws-amplify-iso
//
//  Created by Vital SOWATH on 10/11/22.
//

import Foundation

extension User: Hashable {
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id &&
        lhs.username == rhs.username
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(username)
    }
}
