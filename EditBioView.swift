import SwiftUI

struct EditBioView: View {
    @Binding var bio: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("自己紹介を編集")) {
                TextField("自己紹介", text: $bio)
                    .disableAutocorrection(true) // 自動修正を無効にする
            }
            Section {
                Button(action: {
                    saveBio()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("保存")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.white)
                }
            }
        }
        .navigationTitle("自己紹介")
        
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

    private func saveBio() {
        var users = UserDefaultsHelper.shared.loadUser()
        if let userId = UserDefaults.standard.string(forKey: "loggedInUserId"),
           let index = users.firstIndex(where: { $0.id.uuidString == userId }) {
            users[index].bio = bio
            UserDefaultsHelper.shared.saveUsers(users)
        }
    }   
}

struct EditBioView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditBioView(bio: .constant("こんにちは"))
        }
    }
}