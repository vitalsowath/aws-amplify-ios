// swiftlint:disable all
import Amplify
import Foundation

public struct ChatRoom: Model {
  public let id: String
  public var memberIDs: [String]?
  public var untitledfield: String?
  public var lastMessage: LastMessage?
  public var messages: List<Message>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      memberIDs: [String]? = nil,
      untitledfield: String? = nil,
      lastMessage: LastMessage? = nil,
      messages: List<Message>? = []) {
    self.init(id: id,
      memberIDs: memberIDs,
      untitledfield: untitledfield,
      lastMessage: lastMessage,
      messages: messages,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      memberIDs: [String]? = nil,
      untitledfield: String? = nil,
      lastMessage: LastMessage? = nil,
      messages: List<Message>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.memberIDs = memberIDs
      self.untitledfield = untitledfield
      self.lastMessage = lastMessage
      self.messages = messages
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}