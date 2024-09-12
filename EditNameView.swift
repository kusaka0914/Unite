import SwiftUI

struct EditNameView: View {
    @Binding var username: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("ユーザーネームを編集")) {
                TextField("ユーザーネーム", text: $username)
                    .disableAutocorrection(true) // 自動修正を無効にする
            }
            Section {
                Button(action: {
                    saveName()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("保存")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.white)
                }
            }
        }
        .navigationTitle("ユーザーネーム")
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .imageScale(.large)
            }
        )
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