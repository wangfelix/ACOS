import SwiftUI
import SwiftData

@main
struct FlowBuddyApp: App {
    @StateObject var appState = AppState.shared
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([ThoughtItem.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [modelConfiguration])
    }()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environmentObject(appState)
        }
        .modelContainer(sharedModelContainer)
        .commands {
            CommandMenu("Flow") {
                Button("Trigger Rapid Capture") {
                    appState.isCaptureInterfaceOpen.toggle()
                }
                .keyboardShortcut("k", modifiers: [.command, .shift])
            }
        }
    }
}
