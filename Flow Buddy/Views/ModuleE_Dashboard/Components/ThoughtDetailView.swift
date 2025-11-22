import SwiftUI

struct ThoughtDetailView: View {
    let item: ThoughtItem
    
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
                        // Placeholder for agent action
                    }
                    .buttonStyle(.bordered)
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
