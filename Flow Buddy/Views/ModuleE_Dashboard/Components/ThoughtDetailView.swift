import SwiftUI

struct ThoughtDetailView: View {
    let item: ThoughtItem
    @State private var isAnalyzing = false
    @State private var analysisResult: String?
    private let researchService = BackgroundResearchService()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(item.categoryRaw.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(6)
                        .background(Color.cyan.opacity(0.1))
                        .foregroundColor(.cyan)
                        .cornerRadius(6)
                    Spacer()
                    Text(item.timestamp.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(item.text)
                    .font(.title)
                    .textSelection(.enabled)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Actions")
                        .font(.headline)
                    
                    Button("Generate Report") {
                        Task {
                            isAnalyzing = true
                            do {
                                let result = try await researchService.performResearch(for: item.text)
                                print("Research Result: \(result)")
                                analysisResult = result
                            } catch {
                                print("Research Failed: \(error)")
                                analysisResult = "Failed to generate report: \(error.localizedDescription)"
                            }
                            isAnalyzing = false
                        }
                    }
                    .disabled(isAnalyzing)
                    .buttonStyle(.bordered)
                }
                
                if isAnalyzing {
                    ProgressView("Analyzing...")
                        .padding()
                }
                
                if let result = analysisResult {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Research Report")
                            .font(.headline)
                        Text(result)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
