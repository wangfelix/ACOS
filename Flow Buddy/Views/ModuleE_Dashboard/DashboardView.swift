import SwiftUI
import SwiftData

// Define selection type for the Sidebar
enum DashboardSelection: Hashable {
    case analytics
    case thought(ThoughtItem)
    
    static func == (lhs: DashboardSelection, rhs: DashboardSelection) -> Bool {
        switch (lhs, rhs) {
        case (.analytics, .analytics): return true
        case (.thought(let t1), .thought(let t2)): return t1.id == t2.id
        default: return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .analytics:
            hasher.combine(0)
        case .thought(let item):
            hasher.combine(1)
            hasher.combine(item.id)
        }
    }
}

struct DashboardView: View {
    @EnvironmentObject var appState: AppState
    @Query(sort: \ThoughtItem.timestamp, order: .reverse) var thoughts: [ThoughtItem]
    
    @State private var selection: DashboardSelection? = .analytics
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                Section("Analytics") {
                    NavigationLink(value: DashboardSelection.analytics) {
                        AnalyticsSidebarRow(appState: appState)
                    }
                }
                
                Section("Inbox") {
                    ForEach(thoughts) { item in
                        NavigationLink(value: DashboardSelection.thought(item)) {
                            ThoughtSidebarRow(item: item)
                        }
                    }
                }
            }
            .listStyle(.sidebar) // This gives the proper transparent sidebar look
            .navigationTitle("Flow Buddy")
            .toolbar {
                ToolbarItem {
                    Button(action: { appState.isCaptureInterfaceOpen.toggle() }) {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
        } detail: {
            switch selection {
            case .analytics:
                AnalyticsDetailView(appState: appState).background(Color.blue.opacity(0.3))
            case .thought(let item):
                ThoughtDetailView(item: item)
            case nil:
                Text("Select an item to view details")
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Sidebar Components
// Components have been moved to the Components folder
