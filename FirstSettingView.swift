import SwiftUI

struct FirstSettingView: View {
    @Binding var user: User
    @State private var showUserProfile: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    // 選択肢のデータ
    let faculties = ["理工学部", "農学生命科学部", "教育学部", "人文社会科学部", "医学部"]
    let scienceDepartments = ["電子情報工学科", "機械化学科", "数物科学科", "物質創生科学科", "地球環境防災学科", "自然エネルギー学科"]
    let agricultureDepartments = ["生物学科", "分子生命科学科", "農業化学科", "食料資源学科", "国際園芸農学科", "地球環境工学科"]
    let educationDepartments = ["小学校コース", "中学校コース", "特別支援教育専攻"]
    let humanitiesDepartments = ["文化資源学コース", "多文化共生コース", "経済法律コース", "企業戦略コース", "地域行動コース"]
    let medicalDepartments = ["医学科", "保健学科", "心理支援科学科"]
    let clubs = ["無所属","サッカー部", "テニス部", "バスケットボール部"]

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("繋がりを広げよう")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 40)
                    .padding(.horizontal,40)
                HStack {
                    Text("ユーザー名")
                            .font(.headline)
                            .foregroundColor(.white)
                        .padding(.bottom, 10)
                    Spacer()
                }.padding(.leading,40)
                TextField("ユーザー名", text: $user.username)
                    .frame(width: 250)
                    .padding(.horizontal)
                    .padding(.vertical,8)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .foregroundColor(.white) // 文字色を黒に設定
                HStack {
                    Text("所属学部")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                    Spacer()
                }.padding(.leading,40)
                HStack {
                    Picker("学部", selection: $user.faculty) {
                        ForEach(faculties, id: \.self) { faculty in
                            Text(faculty)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                .padding(.bottom, 20)
                    Spacer()
                }.padding(.leading,40)
                HStack {
                    Text("所属学科")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                    Spacer()
                }.padding(.leading,40)
                if user.faculty == "理工学部" {
                    HStack {
                        Picker("学科", selection: $user.department) {
                            ForEach(scienceDepartments, id: \.self) { scienceDepartment in
                                Text(scienceDepartment)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5.0)
                    .padding(.bottom, 20)
                        Spacer()
                    }.padding(.leading,40)
                } else if user.faculty == "農学生命科学部" {
                    HStack {
                        Picker("学科", selection: $user.department) {
                            ForEach(agricultureDepartments, id: \.self) { agricultureDepartment in
                                Text(agricultureDepartment)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5.0)
                    .padding(.bottom, 20)
                        Spacer()
                    }.padding(.leading,40)
                } else if user.faculty == "教育学部" {
                    HStack {
                        Picker("学科", selection: $user.department) {
                            ForEach(educationDepartments, id: \.self) { educationDepartment in
                                Text(educationDepartment)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5.0)
                    .padding(.bottom, 20)
                        Spacer()
                    }.padding(.leading,40)
                } else if user.faculty == "人文社会科学部" {
                    HStack {
                        Picker("学科", selection: $user.department) {
                            ForEach(humanitiesDepartments, id: \.self) { humanitiesDepartment in
                                Text(humanitiesDepartment)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5.0)
                    .padding(.bottom, 20)
                        Spacer()
                    }.padding(.leading,40)
                } else if user.faculty == "医学部" {
                    HStack {
                        Picker("学科", selection: $user.department) {
                            ForEach(medicalDepartments, id: \.self) { medicalDepartment in
                                Text(medicalDepartment)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5.0)
                    .padding(.bottom, 20)
                        Spacer()
                    }.padding(.leading,40)
                } else {
                    HStack {
                        Text("学科を選択してください")
                            
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(5.0)
                        .padding(.bottom, 20)
                        Spacer()
                    }.padding(.leading,40)
                }
                HStack {
                    Text("所属サークル")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                    Spacer()
                }.padding(.leading,40)
                HStack {
                    Picker("サークル", selection: $user.club) {
                        ForEach(clubs, id: \.self) { club in
                            Text(club)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                .padding(.bottom, 30)
                    Spacer()
                }.padding(.leading,40)
                
                Button(action: {
                    if user.username.isEmpty || user.faculty.isEmpty || user.department.isEmpty || user.club.isEmpty {
                        alertMessage = "全てのフィールドを入力してください。"
                        showAlert = true
                    } else {
                        UserDefaultsHelper.shared.saveUser(user)
                        print("User to be saved: \(user)") // ここでユーザー情報をprint
                        showUserProfile = true
                    }
                }) {
                    Text("保存")
                        .font(.headline)
                        .foregroundColor(.white)
                        
                        .frame(width: 100, height: 40)
                        .background(Color.black)
                        .border(Color.white)
                }
                .padding(.bottom, 20)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("エラー"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .navigationDestination(isPresented: $showUserProfile) {
                        UserProfileView(
                            user: $user
                        ).navigationBarBackButtonHidden(true)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.black) // 背景色を黒に設定
            .foregroundColor(.white) // テキスト色を白に設定
        }
        .background(Color.black) // 余白の背景色を黒に設定
    }
}

struct FirstSettingView_Previews: PreviewProvider {
    static var previews: some View {
        FirstSettingView(
            user: .constant(User(username: "", university: "", posts: [], followers: [], following: [], accountname: "", faculty: "", department: "", club: "", bio: "", twitterHandle: "", email: "", stories: []))
        )
    }
}