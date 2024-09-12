import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var user: User
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showSignUp: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @AppStorage("registeredEmails") private var registeredEmailsData: String = "[]"
    @AppStorage("registeredPasswords") private var registeredPasswordsData: String = "[]"

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                HStack(spacing: 10) { // ここでスペーシングを調整
                    Image("Sphere")
                        .resizable()
                        .frame(width: 35, height: 35)
                    Text("Unite")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .padding(.bottom, 40)
                
                TextField("メールアドレス", text: $email)
                    .frame(width: 250)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                SecureField("パスワード", text: $password)
                    .frame(width: 250)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .padding(.bottom, 40)
                
                Button(action: {
                    login()
                }) {
                    Text("ログイン")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 180, height: 50)
                        .background(Color.black)
                        .border(Color.white, width: 1)
                }
                
                Button(action: {
                    showSignUp = true
                }) {
                    Text("アカウントを作成")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 180, height: 50)
                        .background(Color.black)
                        .padding(2)
                }
                .navigationDestination(isPresented: $showSignUp) {
                    SignUpView(isLoggedIn: $isLoggedIn, user: $user)
                        .navigationBarBackButtonHidden(true) // Backボタンを非表示にする
                }
                
                Spacer()
            }
            .padding(100)
            .background(Color.black) // 背景色を黒に設定
            .foregroundColor(.white) // テキスト色を白に設定
            .alert(isPresented: $showAlert) {
                Alert(title: Text("エラー"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                UserProfileView(
                    user: $user
                )
                .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    private func login() {
        // ログイン処理をここに実装
        if email.isEmpty || password.isEmpty {
            alertMessage = "メールアドレスとパスワードを入力してください。"
            showAlert = true
        } else {
            // 既存の登録データをデコード
            let registeredEmails = decodeJSON(from: registeredEmailsData) ?? []
            let registeredPasswords = decodeJSON(from: registeredPasswordsData) ?? []
            
            if let index = registeredEmails.firstIndex(of: email), registeredPasswords[index] == password {
                isLoggedIn = true
                loadUserData(email: email)
                print("Logged in user: \(user)")
                // ログイン成功時の処理
            } else {
                alertMessage = "メールアドレスまたはパスワードが間違っています。"
                showAlert = true
            }
        }
    }

    private func loadUserData(email: String) {
        let users = UserDefaultsHelper.shared.loadUser()
        if let loadedUser = users.first(where: { $0.email == email }) {
            user = loadedUser
            UserDefaults.standard.set(loadedUser.id.uuidString, forKey: "loggedInUserId")
            UserDefaultsHelper.shared.saveCurrentUser(loadedUser) // 現在のユーザーを保存
        }
    }
    
    private func decodeJSON(from string: String) -> [String]? {
        if let data = string.data(using: .utf8) {
            return try? JSONDecoder().decode([String].self, from: data)
        }
        return nil
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false), user: .constant(User(username: "", university: "", posts: [], followers: [], following: [], accountname: "", faculty: "", department: "", club: "", bio: "", twitterHandle: "", email: "", stories: [])))
    }
}