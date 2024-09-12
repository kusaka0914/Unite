import SwiftUI

struct EditDepartmentView: View {
    @Binding var department: String
    @Binding var faculty: String
    @Environment(\.presentationMode) var presentationMode

    let scienceDepartments = ["電子情報工学科", "機械化学科", "数物科学科", "物質創生科学科", "地球環境防災学科", "自然エネルギー学科"]
    let agricultureDepartments = ["生物学科", "分子生命科学科", "農業化学科", "食料資源学科", "国際園芸農学科", "地球環境工学科"]
    let educationDepartments = ["小学校コース", "中学校コース", "特別支援教育専攻"]
    let humanitiesDepartments = ["文化資源学コース", "多文化共生コース", "経済法律コース", "企業戦略コース", "地域行動コース"]
    let medicalDepartments = ["医学科", "保健学科", "心理支援科学科"]

    var body: some View {
        Form {
            Section(header: Text("所属学科を編集").foregroundColor(.white)) {
                Picker("所属学科", selection: $department) {
                    if faculty == "理工学部" {
                        ForEach(scienceDepartments, id: \.self) { department in
                            Text(department)
                                .foregroundColor(.white) // 文字色を白に設定
                                .tag(department)
                        }
                    }
                    if faculty == "農学生命科学部" {
                        ForEach(agricultureDepartments, id: \.self) { department in
                            Text(department)
                                .foregroundColor(.white) // 文字色を白に設定
                                .tag(department)
                        }
                    }
                    if faculty == "教育学部" {
                        ForEach(educationDepartments, id: \.self) { department in
                            Text(department)
                                .foregroundColor(.white) // 文字色を白に設定
                                .tag(department)
                        }
                    }
                    if faculty == "人文社会科学部" {
                        ForEach(humanitiesDepartments, id: \.self) { department in
                            Text(department)
                                .foregroundColor(.white) // 文字色を白に設定
                                .tag(department)
                        }
                    }
                    if faculty == "医学部" {
                        ForEach(medicalDepartments, id: \.self) { department in
                            Text(department)
                                .foregroundColor(.white) // 文字色を白に設定
                                .tag(department)
                        }
                    }
                }
                .pickerStyle(MenuPickerStyle()) // ピッカースタイルをメニューに設定
            }
            Section {
                Button(action: {
                    saveDepartment()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("保存")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.white)
                }
            }
        }
        .navigationTitle("所属学科")
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
            EditDepartmentView(department: .constant("電子情報工学科"), faculty: .constant("理工学部"))
        }
    }
}