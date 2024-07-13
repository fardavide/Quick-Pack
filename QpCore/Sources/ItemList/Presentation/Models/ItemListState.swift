import ItemDomain
import Presentation

@frozen public struct ItemListState: Equatable {
  let items: DataLce<[Item]>
}

public extension ItemListState {
  static let initial = ItemListState(items: .loading)
  static let samples = ItemListStateSamples()
}

public final class ItemListStateSamples: Sendable {
  let content = ItemListState(
    items: .content(
      [
        .samples.camera,
        .samples.iPad,
        .samples.nintendoSwitch
      ]
    )
  )
}
