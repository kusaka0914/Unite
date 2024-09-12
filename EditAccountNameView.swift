import SwiftUI

struct EditAccountNameView: View {
    @Binding var accountname: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("アカウント名を編集")) {
                TextField("アカウント名", text: $accountname)
                    .disableAutocorrection(true) // 自動修正を無効にする
            }
            Section {
                Button(action: {
                    saveAccountName()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("保存")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.white)
                }
            }
        }
        .navigationTitle("アカウント名")
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

    private func saveAccountName() {
        var users = UserDefaultsHelper.shared.loadUser()
        if let userId = UserDefaults.standard.string(forKey: "loggedInUserId"),
           let index = users.firstIndex(where: { $0.id.uuidString == userId }) {
            users[index].accountname = accountname
            UserDefaultsHelper.shared.saveUsers(users)
        }
    }   
}

struct EditAccountNameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditAccountNameView(accountname: .constant("takumi_140812"))
        }
    }
}