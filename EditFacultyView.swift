import SwiftUI

struct EditFacultyView: View {
    @Binding var faculty: String
    @Environment(\.presentationMode) var presentationMode

    let faculties = ["理工学部", "農学生命科学部", "人文社会科学部", "教育学部", "医学部"]

    var body: some View {
        Form {
            Section(header: Text("所属学部を編集").foregroundColor(.white)) {
                Picker("所属学部", selection: $faculty) {
                    ForEach(faculties, id: \.self) { faculty in
                        Text(faculty)
                            .foregroundColor(.white) // 文字色を白に設定
                            .tag(faculty)
                    }
                }
                .pickerStyle(MenuPickerStyle()) // ピッカースタイルをメニューに設定
            }
            Section {
                Button(action: {
                    saveFaculty()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("保存")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.white)
                }
            }
        }
        .navigationTitle("所属学部")
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