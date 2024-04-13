import SwiftUI
#if canImport(UIKit)
import UIKit

extension UIDevice {
  static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

extension UIWindow {
  open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
    }
  }
}

struct DeviceShakeViewModifier: ViewModifier {
  let action: () -> Void
  
  func body(content: Content) -> some View {
    content
      .onAppear()
      .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
        action()
      }
  }
}
#endif

public extension View {
  
  /// Setup an `action` to be performed when the devices is shaked, on supported devices
  func onShake(perform action: @escaping () -> Void) -> some View {
    #if canImport(UIKit)
    modifier(DeviceShakeViewModifier(action: action))
    #else
    self
    #endif
  }
}

/// Returns `true` if the device can react to shake gestures
public func canShake() -> Bool {
  #if canImport(UIKit)
  return true
  #else
  return false
  #endif
}
