// swiftlint:disable all
import Amplify
import Foundation

extension ChatRoom {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case memberIDs
    case untitledfield
    case lastMessage
    case messages
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let chatRoom = ChatRoom.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "ChatRooms"
    
    model.fields(
      .id(),
      .field(chatRoom.memberIDs, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .field(chatRoom.untitledfield, is: .optional, ofType: .string),
      .field(chatRoom.lastMessage, is: .optional, ofType: .embedded(type: LastMessage.self)),
      .hasMany(chatRoom.messages, is: .optional, ofType: Message.self, associatedWith: Message.keys.chatroomID),
      .field(chatRoom.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(chatRoom.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}