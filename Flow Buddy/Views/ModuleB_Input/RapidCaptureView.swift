import SwiftUI
import SwiftData

struct RapidCaptureView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.modelContext) private var modelContext
    @State private var inputText: String = ""
    @FocusState private var isFocused: Bool
    
    @State private var selectedCategory: ThoughtCategory = .auto
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            // Main Input Capsule
            HStack(spacing: 12) {
                Image(systemName: "pencil.and.scribble")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                TextField("Offload thought...", text: $inputText)
                    .textFieldStyle(.plain)
                    .font(.title)
                    .focused($isFocused) // Binds focus to state
                    .onSubmit { submitThought() }
            }
            .padding(16)
            .glassEffectWithFallback(in: Capsule())
            .shadow(radius: 10)
            .frame(width: 600)
            
            HStack(spacing: 8) {
                Button {
                    print("Dashboard button tapped!")
                    // Close capture interface first
                    AppState.shared.isCaptureInterfaceOpen = false
                    
                    // Use notification to open dashboard (same pattern as toggleCaptureWindow)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        NotificationCenter.default.post(name: .openDashboard, object: nil)
                    }
                } label: {
                    Label("Open Dashboard", systemImage: "rectangle.on.rectangle")
                        .labelStyle(.titleAndIcon)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .glassEffectWithFallback(in: Capsule())
                .shadow(radius: 5)
                .contentShape(Capsule())
                
                // Category Dropdown Pill
                Menu {
                    ForEach(ThoughtCategory.allCases, id: \.self) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            if selectedCategory == category {
                                Label(category.rawValue, systemImage: "checkmark")
                            } else {
                                Text(category.rawValue)
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text(selectedCategory.rawValue)
                            .fontWeight(.medium)
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.caption)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .glassEffectWithFallback(in: Capsule())
                    .shadow(radius: 5)
                    .contentShape(Capsule())
                }
                .buttonStyle(.plain)
                .frame(alignment: .trailing)
            }
            
        }
        .onAppear {
            // Force focus when window appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isFocused = true
            }
        }
        // Listen for Escape key
        .background(
            Button("") {
                appState.isCaptureInterfaceOpen = false
                inputText = ""
                selectedCategory = .auto
            }
            .keyboardShortcut(.escape, modifiers: [])
            .hidden()
        )
        .padding(35)
    }
    
    func submitThought() {
        guard !inputText.isEmpty else { return }
        
        // 1. Determine final category for the item
        let finalCategory: ThoughtCategory
        
        switch selectedCategory {
        case .auto:
            // Same logic as before: simple keyword check for "remind"
            finalCategory = inputText.lowercased().contains("remind") ? .reminder : .auto
        default:
            finalCategory = selectedCategory
        }
        
        let newItem = ThoughtItem(text: inputText, category: finalCategory)
        modelContext.insert(newItem)
        
        // 2. Determine if we should run background research
        // Requirement: appState.isBackgroundResearchEnabled MUST be true
        if appState.isBackgroundResearchEnabled {
            var shouldResearch = false
            
            switch selectedCategory {
            case .research:
                shouldResearch = true
            case .auto:
                // Only research if it was NOT detected as a reminder
                // If it stayed .auto (or implicitly research), then yes.
                // If existing auto-logic made it .reminder, then no.
                if finalCategory != .reminder {
                    shouldResearch = true
                }
            case .reminder:
                shouldResearch = false
            }
            
            if shouldResearch {
                let service = BackgroundResearchService()
                let query = inputText
                
                Task {
                    do {
                        let report = try await service.performResearch(for: query)
                        newItem.inferenceReport = report
                    } catch {
                        print("Error performing background research: \(error)")
                    }
                }
            }
        }
        
        inputText = ""
        appState.isCaptureInterfaceOpen = false
    }
}

