import SwiftUI
import Combine
import AppKit
import ScreenCaptureKit

class AppState: ObservableObject {
    @Published var flowScore: Double = 85.0
    @Published var isCaptureInterfaceOpen: Bool = false {
        didSet { NotificationCenter.default.post(name: .toggleCaptureWindow, object: nil) }
    }
    @Published var isDistractionDetectionEnabled: Bool = UserDefaults.standard.bool(forKey: "isDistractionDetectionEnabled") {
        didSet {
            UserDefaults.standard.set(isDistractionDetectionEnabled, forKey: "isDistractionDetectionEnabled")
            // If turned off, clear current distraction
            if !isDistractionDetectionEnabled {
                self.currentDistraction = nil
            }
        }
    }
    @Published var currentDistraction: String? = nil
    
    private var distractionTimer: Timer?
    private let analysisService = ScreenAnalysisService()
    private var isAnalyzing = false
    
    static let shared = AppState() // Singleton access
    
    init() {
        // Start periodic context check every 10 seconds
        startMonitoring()
    }
    
    func startMonitoring() {
        distractionTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                await self?.checkContext()
            }
        }
    }
    
    @MainActor
    func checkContext() async {
        guard isDistractionDetectionEnabled else { return }
        guard !isAnalyzing else { return }
        isAnalyzing = true
        defer { isAnalyzing = false }
        
        // 1. Capture Screenshot (ScreenCaptureKit)
        do {
            let content = try await SCShareableContent.current
            guard let display = content.displays.first else { return }
            
            let filter = SCContentFilter(display: display, excludingWindows: [])
            let configuration = SCStreamConfiguration()
            configuration.width = 1920
            configuration.height = 1080
            configuration.showsCursor = false
            
            let cgImage = try await SCScreenshotManager.captureImage(contentFilter: filter, configuration: configuration)
            let image = NSImage(cgImage: cgImage, size: NSSize(width: 1920, height: 1080))
            
            // 2. Ask LLM
            let context = try await analysisService.analyzeScreenContext(image: image)
            print("LLM Analysis: \(context)")
            
            // 3. Update State based on analysis
            if context.status == "distracted" {
                withAnimation {
                    self.currentDistraction = "\(context.app): \(context.summary)"
                }
            } else {
                 withAnimation {
                    self.currentDistraction = nil
                }
            }
        } catch {
            print("Screen Capture or LLM Failed: \(error)")
        }
    }
    
    func resolveDistraction(isTaskRelated: Bool) {
        withAnimation { self.currentDistraction = nil }
    }
}

extension Notification.Name {
    static let toggleCaptureWindow = Notification.Name("toggleCaptureWindow")
}
