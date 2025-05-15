import ItemDomain

@usableFromInline struct SearchItemResultModel: Equatable, Sendable {
  let all: [Item]
  let filtered: [Item]
  var hasMore: Bool {
    all.count > filtered.count
  }
}

extension SearchItemResultModel {
  
  static var empty: SearchItemResultModel {
    .init(all: [], filtered: [])
  }
  
  static let samples = SearchItemResultModelSamples()
  
  var isNotEmpty: Bool { !filtered.isEmpty }
}

final class SearchItemResultModelSamples: Sendable {
  
  var cameraOnly: SearchItemResultModel {
    SearchItemResultModel(
      all: [.samples.camera],
      filtered: [.samples.camera]
    )
  }
  
  var withMore: SearchItemResultModel {
    SearchItemResultModel(
      all: [
        .samples.camera,
        .samples.iPad,
        .samples.nintendoSwitch,
        .samples.shoes,
        .samples.tShirt
      ],
      filtered: [
        .samples.camera,
        .samples.iPad,
        .samples.nintendoSwitch
      ]
    )
  }
}
