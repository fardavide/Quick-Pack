import SwiftUI

/// SwiftData model that can be described by a String
public protocol IdentifiableModel: Equatable {
  static var typeDescription: String { get }
  var modelDescription: String { get }
}
