import SwiftUI
import SwiftData

@main
struct FlowBuddyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
        .commands {
            CommandMenu("Flow") {
                Button("Trigger Rapid Capture") {
                    AppState.shared.isCaptureInterfaceOpen.toggle()
                }
                .keyboardShortcut("k", modifiers: [.command, .shift])
            }
        }
    }
}
