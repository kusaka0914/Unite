import SwiftUI

struct EditNameView: View {
    @Binding var username: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("名前を編集")) {
                TextField("名前", text: $username)
                    .disableAutocorrection(true) // 自動修正を無効にする
            }
            Section {
                Button(action: {
                    saveName()
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

    private func saveName() {
        var users = UserDefaultsHelper.shared.loadUser()
        if let userId = UserDefaults.standard.string(forKey: "loggedInUserId"),
           let index = users.firstIndex(where: { $0.id.uuidString == userId }) {
            users[index].username = username
            UserDefaultsHelper.shared.saveUsers(users)
        }
    }   
}

struct EditNameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditNameView(username: .constant("takumi_140812"))
        }
    }
}