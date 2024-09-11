import SwiftUI

struct EditDepartmentView: View {
    @Binding var department: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("学科を編集")) {
                TextField("学科", text: $department)
                    .disableAutocorrection(true) // 自動修正を無効にする
            }
            Section {
                Button(action: {
                    saveDepartment()
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

    private func saveDepartment() {
        var users = UserDefaultsHelper.shared.loadUser()
        if let userId = UserDefaults.standard.string(forKey: "loggedInUserId"),
           let index = users.firstIndex(where: { $0.id.uuidString == userId }) {
            users[index].department = department
            UserDefaultsHelper.shared.saveUsers(users)
        }
    }   
}

struct EditDepartmentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditDepartmentView(department: .constant("理工学部"))
        }
    }
}