import SwiftUI

struct AnalyticsSidebarRow: View {
    @ObservedObject var appState: AppState
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Session").font(.caption)
                Text(appState.isSessionActive ? "Active" : "Overview")
                    .font(.title2)
                    .bold()
                    .foregroundColor(appState.isSessionActive ? .green : .secondary)
            }
            Spacer()
            if appState.isSessionActive {
                Circle()
                    .fill(Color.green)
                    .frame(width: 10, height: 10)
            }
        }
        .padding(.vertical, 4)
    }
}
