import SwiftUI

struct AnalyticsDetailView: View {
    @ObservedObject var appState: AppState
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 10) {
                    Text("Today's Flow")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("\(Int(appState.flowScore))")
                        .font(.system(size: 80, weight: .bold, design: .rounded))
                        .foregroundColor(.cyan)
                    Text("Excellent focus level")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recent Activity")
                        .font(.title2)
                        .bold()
                    
                    Text("Detailed usage graphs and reports will appear here.")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(nsColor: .controlBackgroundColor))
                        .cornerRadius(12)
                }
                .padding()
                
                Spacer()
            }
            .padding()
        }
    }
}
