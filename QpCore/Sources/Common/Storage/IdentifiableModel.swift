import SwiftUI

/// SwiftData model that can be described by a String
public protocol IdentifiableModel: Equatable {
  var modelDescription: String { get }
}
