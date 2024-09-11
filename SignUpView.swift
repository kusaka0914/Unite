import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = "エラー" // アラートのタイトルを管理する変数を追加
    @State private var alertMessage: String = ""
    @State private var showLogin: Bool = false
    @State private var showFirstSetting: Bool = false
    @AppStorage("registeredEmails") private var registeredEmailsData: String = "[]"
    @AppStorage("registeredPasswords") private var registeredPasswordsData: String = "[]"
    @Binding var isLoggedIn: Bool
    @Binding var user: User

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("アカウント作成")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 40)
                HStack {
                    Text("メールアドレス")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.leading, 40)
                TextField("メールアドレス", text: $email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .foregroundColor(.white) // 文字色を黒に設定
                    .frame(width: 300)
                    .padding(.horizontal, 53)
                HStack {
                    Text("パスワード")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.leading, 40)
                SecureField("パスワード", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .foregroundColor(.white) // 文字色を黒に設定
                    .frame(width: 300)
                HStack {
                    Text("パスワード確認")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.leading, 40)
                SecureField("パスワード確認", text: $confirmPassword)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .foregroundColor(.white) // 文字色を黒に設定
                    .frame(width: 300)
                
                Button(action: {
                    signUp()
                }) {
                    Text("サインアップ")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 150, height: 40)
                        .background(Color.black)
                        .border(Color.white, width: 1)
                }
                .padding(.bottom, 20)
                
                Button(action: {
                    showLogin = true
                }) {
                    VStack {
                        Text("既にアカウントをお持ちですか?")
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                        Text("ログイン")
                            .foregroundColor(.white)
                    }
                }
                .navigationDestination(isPresented: $showLogin) {
                    LoginView(
                        isLoggedIn: $isLoggedIn,
                        user: $user
                    )
                    .navigationBarBackButtonHidden(true)
                }
                .navigationDestination(isPresented: $showFirstSetting) {
                    FirstSettingView(
                        user: $user
                    )
                    .navigationBarBackButtonHidden(true) // Backボタンを非表示にする
                }
                
                Spacer()
            }
            .padding()
            .background(Color.black) // 背景色を黒に設定
            .foregroundColor(.white) // テキスト色を白に設定
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .background(Color.black) // 余白の背景色を黒に設定
        .edgesIgnoringSafeArea(.all) // 余白を無視して全体を黒に設定
    }
    
    private func signUp() {
        // サインアップ処理をここに実装
        if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            alertTitle = "エラー"
            alertMessage = "全てのフィールドを入力してください。"
            showAlert = true
        } else if password != confirmPassword {
            alertTitle = "エラー"
            alertMessage = "パスワードが一致しません。"
            showAlert = true
        } else {
            // 既存の登録データをデコード
            var registeredEmails = decodeJSON(from: registeredEmailsData) ?? []
            var registeredPasswords = decodeJSON(from: registeredPasswordsData) ?? []
            
            if registeredEmails.contains(email) {
                alertTitle = "エラー"
                alertMessage = "このメールアドレスは既に登録されています。"
                showAlert = true
            } else {
                // サインアップ成功時の処理
                registeredEmails.append(email)
                registeredPasswords.append(password)
                
                // データをエンコードして保存
                registeredEmailsData = encodeJSON(from: registeredEmails) ?? "[]"
                registeredPasswordsData = encodeJSON(from: registeredPasswords) ?? "[]"
                
                // 新しいユーザーを作成して保存
                let newUser = User(
                    username: email,
                    university: "",
                    posts: [],
                    followers: [],
                    following: [],
                    accountname: "",
                    faculty: "",
                    department: "",
                    club: "",
                    bio: "",
                    twitterHandle: "",
                    email: email,
                    stories: []
                )
                UserDefaultsHelper.shared.saveUser(newUser)
                
                alertTitle = "成功"
                alertMessage = "サインアップ成功！"
                showAlert = true
                
                // 2秒後に詳細設定画面に自動遷移
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    user = newUser
                    showFirstSetting = true
                }
            }
        }
    }
    
    private func encodeJSON(from array: [String]) -> String? {
        if let data = try? JSONEncoder().encode(array) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    private func decodeJSON(from string: String) -> [String]? {
        if let data = string.data(using: .utf8) {
            return try? JSONDecoder().decode([String].self, from: data)
        }
        return nil
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(isLoggedIn: .constant(false), user: .constant(User(username: "", university: "", posts: [], followers: [], following: [], accountname: "", faculty: "", department: "", club: "", bio: "", twitterHandle: "", email: "", stories: [])))
    }
}