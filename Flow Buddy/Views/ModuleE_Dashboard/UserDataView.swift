import SwiftUI

struct UserDataView: View {
    var body: some View {
        ContentUnavailableView("User Data", systemImage: "person.text.rectangle", description: Text("Manage your account and data here."))
            .navigationTitle("User Data")
    }
}
