import Design
import EditTripPresentation
import Provider
import SwiftUI
import TripDomain
import Undo

public struct TripList: View {
  @StateObject var viewModel: TripListViewModel = getProvider().get()
  
  public init() {}
  
  public var body: some View {
    TripListContent(
      state: viewModel.state,
      undoHandler: viewModel.undoHandler,
      send: viewModel.send,
      edit: viewModel.edit
    )
  }
}

private struct TripListContent: View {
  let state: TripListState
  let undoHandler: UndoHandler
  let send: (TripListAction) -> Void
  let edit: (Trip) -> EditTripViewModel
  
  public var body: some View {
    NavigationSplitView {
      LceView(
        lce: state.trips,
        errorMessage: "Cannot load trips",
        content: { items in
          if !items.isEmpty {
            TripListItems(
              items: items,
              send: send,
              edit: edit
            )
          } else {
            SpecialCaseView.primary(
              title: "No trip found",
              subtitle: "Create your first trip",
              image: .backpack,
              actionText: "Create trip",
              action: { send(.newTrip) }
            )
          }
        }
      )
      .navigationTitle("My Trips")
      .toolbar {
        Button { send(.newTrip) } label: {
          Label("Add Item", systemImage: "plus")
        }
      }

    } detail: {
      SpecialCaseView.primary(
        title: "Select or create a trip",
        image: .backpack
      )
    }
    .undoable(with: undoHandler)
  }
}

private struct TripListItems: View {
  let items: [TripListItemUiModel]
  let send: (TripListAction) -> Void
  let edit: (Trip) -> EditTripViewModel

  var body: some View {
    List(items) { item in
      NavigationLink {
        EditTrip(viewModel: edit(item.domainModel))
      } label: {
        HStack {
          Text(item.name)
          Spacer()
          if let date = item.date {
            Text(date)
          }
        }
        .swipeActions(edge: .trailing) {
          Button {
            send(.deleteTrip(id: item.id))
          } label: {
            Label("Delete", systemSymbol: .trash)
              .tint(.red)
          }
        }
      }
    }
    .animation(.default, value: items)
  }
}

#Preview("With items") {
  return TripListContent(
    state: .samples.content,
    undoHandler: FakeUndoHandler(),
    send: { _ in },
    edit: { _ in .samples.content }
  )
}

#Preview("Zero") {
  getProvider().register { EditTripViewModel.samples.content }
  return TripListContent(
    state: .samples.empty,
    undoHandler: FakeUndoHandler(),
    send: { _ in },
    edit: { _ in .samples.content }
  )
}
