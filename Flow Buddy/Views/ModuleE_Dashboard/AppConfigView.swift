import SwiftUI

struct AppConfigView: View {
    @ObservedObject var appState: AppState
    
    var body: some View {
        Form {
            Section {
                Toggle("Distraction Detection", isOn: $appState.isDistractionDetectionEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
            } header: {
                Text("Smart Features")
            } footer: {
                Text("When enabled, Flow Buddy will periodically analyze your screen to help you stay focused.")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("App Config")
        .padding()
    }
}
