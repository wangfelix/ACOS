import SwiftUI
import SwiftData

struct DashboardView: View {
    @EnvironmentObject var appState: AppState
    @Query(sort: \ThoughtItem.timestamp, order: .reverse) var thoughts: [ThoughtItem]
    
    var body: some View {
        NavigationView {
            List {
                Section("Analytics") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Flow Score").font(.caption)
                            Text("\(Int(appState.flowScore))").font(.largeTitle).bold().foregroundColor(.cyan)
                        }
                        Spacer()
                        // Simple graph
                        HStack(alignment: .bottom, spacing: 4) {
                            ForEach(0..<8) { _ in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.cyan.opacity(0.6))
                                    .frame(width: 6, height: CGFloat.random(in: 10...30))
                            }
                        }
                    }
                }
                Section("Inbox") {
                    ForEach(thoughts) { item in
                        HStack {
                            Image(systemName: "circle.fill").font(.caption2).foregroundColor(.cyan)
                            VStack(alignment: .leading) {
                                Text(item.text).fontWeight(.medium)
                                Text(item.categoryRaw).font(.caption).foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Flow Buddy")
            .toolbar {
                ToolbarItem {
                    Button(action: { appState.isCaptureInterfaceOpen.toggle() }) {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
        }
    }
}

