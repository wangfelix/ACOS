import SwiftUI

struct AnalyticsSidebarRow: View {
    @ObservedObject var appState: AppState
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Flow Score").font(.caption)
                Text("\(Int(appState.flowScore))").font(.title2).bold().foregroundColor(.cyan)
            }
            Spacer()
            // Simple graph
            HStack(alignment: .bottom, spacing: 3) {
                ForEach(0..<8) { _ in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.cyan.opacity(0.6))
                        .frame(width: 4, height: CGFloat.random(in: 10...20))
                }
            }
        }
        .padding(.vertical, 4)
    }
}
