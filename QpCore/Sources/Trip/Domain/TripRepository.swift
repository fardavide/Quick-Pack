import Combine
import QpUtils

public protocol TripRepository {
  
  var trips: any DataPublisher<[Trip]> { get }
}
