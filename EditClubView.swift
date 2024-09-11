import SwiftUI

struct EditClubView: View {
    @Binding var club: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("学科を編集")) {
                TextField("学科", text: $club)
                    .disableAutocorrection(true) // 自動修正を無効にする
            }
            Section {
                Button(action: {
                    saveClub()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("保存")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .navigationTitle("所属学部編集")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func saveClub() {
        var users = UserDefaultsHelper.shared.loadUser()
        if let userId = UserDefaults.standard.string(forKey: "loggedInUserId"),
           let index = users.firstIndex(where: { $0.id.uuidString == userId }) {
            users[index].club = club
            UserDefaultsHelper.shared.saveUsers(users)
        }
    }   
}

struct EditClubView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditClubView(club: .constant("バスケットボール部"))
        }
    }
}