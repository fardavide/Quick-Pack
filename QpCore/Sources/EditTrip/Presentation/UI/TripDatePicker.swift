import DateUtils
import SwiftUI
import TripDomain

struct TripDatePicker: View {
  private let titleKey: LocalizedStringKey
  private let onChange: (TripDate?) -> Void
  
  @State private var isOpen = false
  @State private var tripDate: TripDate?
  @State private var precision: TripDate.Precision
  
  private let years = 2023...2100
  
  init(
    _ titleKey: LocalizedStringKey,
    tripDate _tripDate: TripDate?,
    onChange: @escaping (TripDate?) -> Void
  ) {
    self.titleKey = titleKey
    self.onChange = onChange
    self.tripDate = _tripDate
    self.precision = _tripDate?.precision ?? .exact
  }
  
  var body: some View {
    HStack {
      Text(titleKey)
      Spacer()
      Text(tripDate?.shortFormatted ?? "-")
        .frame(minWidth: 40)
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(FillShapeStyle().tertiary, in: .buttonBorder)   
    }
    .onTapGesture { isOpen = true }
    .sheet(isPresented: $isOpen) {
      NavigationStack {
        VStack {
          
          Picker("Type", selection: $precision) {
            ForEach(TripDate.Precision.allCases) { precision in
              Text("\(precision)".capitalizedFirst)
            }
          }
          .pickerStyle(.segmented)
          .padding(.vertical)
          
          switch precision {
          case .exact: exactPicker()
          case .month: monthPicker()
          case .year: yearPicker()
          }
          
          Spacer()

          Button { tripDate = nil } label: {
            Text("Remove date")
              .tint(.red)
          }
          
        }
        .navigationTitle("Select a date")
      }
      .presentationDetents([.medium])
      .padding()
    }
    .onChange(of: tripDate) { _, tripDate in onChange(tripDate) }
    .onChange(of: precision) { _, precision in tripDate = tripDate?.withPrecision(precision) }
  }
  
  func exactPicker() -> some View {
    let binding = Binding(
      get: { tripDate?.value ?? .now },
      set: { newDate in tripDate = TripDate(newDate) }
    )
    return DatePicker("Exact date", selection: binding, displayedComponents: .date)
  }
  
  func yearPicker() -> some View {
    let binding = Binding(
      get: { tripDate?.value.year ?? Date.now.year },
      set: { newYear in tripDate = TripDate(year: newYear) }
    )
    return Picker("Year", selection: binding) {
      ForEach(years, id: \.self) { year in
        Text(String(year))
      }
    }
#if !os(macOS)
    .pickerStyle(.wheel)
#endif
  }
  
  func monthPicker() -> some View {
    var year = tripDate?.year ?? Date.now.year
    var month = tripDate?.month ?? Date.now.month
    let yearBinding = Binding(
      get: { year },
      set: { newYear in
        year = newYear
        tripDate = TripDate(year: year, month: month)
      }
    )
    let monthBinding = Binding(
      get: { month },
      set: { newMonth in
        month = newMonth
        tripDate = TripDate(year: year, month: month)
      }
    )
    return HStack {
      Picker("Month", selection: monthBinding) {
        ForEach(Month.allCases) { month in
          Text("\(month)".capitalizedFirst)
        }
      }
      Picker("Year", selection: yearBinding) {
        ForEach(years, id: \.self) { year in
          Text(String(year))
        }
      }
    }
#if !os(macOS)
    .pickerStyle(.wheel)
#endif
  }
}

#Preview("Exact") {
  @State var date: TripDate? = TripDate(year: 2024, month: .dec, day: 25)
  return Form {
    TripDatePicker(
      "Date",
      tripDate: date,
      onChange: { newDate in date = newDate }
    )
  }
}

#Preview("Month") {
  @State var date: TripDate? = TripDate(year: 2024, month: .dec)
  return Form {
    TripDatePicker(
      "Date",
      tripDate: date,
      onChange: { newDate in date = newDate }
    )
  }
}

#Preview("Year") {
  @State var date: TripDate? = TripDate(year: 2024)
  return Form {
    TripDatePicker(
      "Date",
      tripDate: date,
      onChange: { newDate in date = newDate }
    )
  }
}

#Preview("Empty") {
  @State var date: TripDate?
  return Form {
    TripDatePicker(
      "Date",
      tripDate: date,
      onChange: { newDate in date = newDate }
    )
  }
}
