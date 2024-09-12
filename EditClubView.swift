import SwiftUI

struct EditClubView: View {
    @Binding var club: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("サークルを編集")) {
                TextField("サークル", text: $club)
                    .disableAutocorrection(true) // 自動修正を無効にする
            }
            Section {
                Button(action: {
                    saveClub()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("保存")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.white)
                }
            }
        }
        .navigationTitle("サークル")
        
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