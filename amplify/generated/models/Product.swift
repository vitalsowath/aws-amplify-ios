// swiftlint:disable all
import Amplify
import Foundation

public struct Product: Model {
  public let id: String
  public var name: String
  public var imageKey: String
  public var productDescription: String?
  public var userId: String
  public var price: Int
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      name: String,
      imageKey: String,
      productDescription: String? = nil,
      userId: String,
      price: Int) {
    self.init(id: id,
      name: name,
      imageKey: imageKey,
      productDescription: productDescription,
      userId: userId,
      price: price,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      name: String,
      imageKey: String,
      productDescription: String? = nil,
      userId: String,
      price: Int,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.name = name
      self.imageKey = imageKey
      self.productDescription = productDescription
      self.userId = userId
      self.price = price
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}