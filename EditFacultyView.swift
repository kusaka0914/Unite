import SwiftUI

struct EditFacultyView: View {
    @Binding var faculty: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("所属学部を編集")) {
                TextField("所属学部", text: $faculty)
                    .disableAutocorrection(true) // 自動修正を無効にする
            }
            Section {
                Button(action: {
                    saveFaculty()
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

    private func saveFaculty() {
        var users = UserDefaultsHelper.shared.loadUser()
        if let userId = UserDefaults.standard.string(forKey: "loggedInUserId"),
           let index = users.firstIndex(where: { $0.id.uuidString == userId }) {
            users[index].faculty = faculty
            UserDefaultsHelper.shared.saveUsers(users)
        }
    }
}

struct EditFacultyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditFacultyView(faculty: .constant("理工学部"))
        }
    }
}