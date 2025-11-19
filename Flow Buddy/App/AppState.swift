import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var flowScore: Double = 85.0
    @Published var isCaptureInterfaceOpen: Bool = false {
        didSet { NotificationCenter.default.post(name: .toggleCaptureWindow, object: nil) }
    }
    @Published var currentDistraction: String? = nil
    
    private var distractionTimer: Timer?
    
    static let shared = AppState() // Singleton access
    
    init() {
        // Trigger intervention simulation after 5 seconds (faster for testing)
        distractionTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            withAnimation { self.currentDistraction = "Social Media" }
        }
    }
    
    func resolveDistraction(isTaskRelated: Bool) {
        withAnimation { self.currentDistraction = nil }
    }
}

extension Notification.Name {
    static let toggleCaptureWindow = Notification.Name("toggleCaptureWindow")
}

