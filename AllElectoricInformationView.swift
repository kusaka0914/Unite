import SwiftUI
import SwiftData

struct AllElectoricInformationView: View {
    @Binding var user: User
    @State private var users: [User] = []
    @State private var selectedUser: User? = nil
    @State private var isUserProfileViewActive = false
    @Environment(\.dismiss) private var dismiss // dismiss環境変数を追加
    @State private var currentUser: User = User(username: "", university: "", posts: [], followers: [], following: [], accountname: "", faculty: "", department: "", club: "", bio: "", twitterHandle: "", email: "", stories: [], iconImageData: nil)
    @State private var showFollowButton = true
    var body: some View {
        NavigationStack {
            VStack {
                Text("電子情報工学科のユーザー")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach($users) { user in
                            UserRow(user: user, currentUser: $currentUser, showFollowButton: $showFollowButton)
                            Divider().background(Color.white)
                        }
                    }
                }
            }
            .onAppear {
                loadUsers()
                loadCurrentUser()
            }
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .imageScale(.large)
            })
            .background(Color.black)
            .foregroundColor(.white)
        }
    }
    
    private func loadUsers() {
        let allUsers = UserDefaultsHelper.shared.loadUser()
        users = allUsers.filter { $0.department == "電子情報工学科" }
    }
    
    private func loadCurrentUser() {
        // 現在のユーザーをロードする処理
        if let savedCurrentUser = UserDefaultsHelper.shared.loadCurrentUser() {
            currentUser = savedCurrentUser
        } else {
            // ログインしているユーザーが見つからない場合のデフォルト値
            currentUser = User(username: "current_user", university: "弘前大学", posts: [], followers: [], following: [], accountname: "current", faculty: "理工学部", department: "電子情報工学科", club: "なし", bio: "Current User", twitterHandle: "@current_user", email: "current@example.com", stories: [], iconImageData: nil)
        }
    }
}

struct UserRow: View {
    @Binding var user: User
    @Binding var currentUser: User
    @Binding var showFollowButton: Bool
    @State private var isUserProfileViewActive = false
    
    var body: some View {
        NavigationLink(destination: AnotherUserProfileView(user: $user, currentUser: $currentUser)
        .navigationBarBackButtonHidden(true)
        ) {
            HStack {
                if let iconImageData = user.iconImageData, let uiImage = UIImage(data: iconImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)
                }
                VStack(alignment: .leading) {
                    Text(user.username)
                        .font(.headline)
                    Text(user.accountname)
                        .font(.subheadline)
                }
                Spacer()
                if showFollowButton {
                Button(action: {
                    if currentUser.isFollowing(user: user) {
                        UserDefaultsHelper.shared.unfollowUser(follower: currentUser, followee: user)
                        currentUser.following.removeAll { $0 == user.id }
                        user.followers.removeAll { $0 == currentUser.id }
                    } else {
                        UserDefaultsHelper.shared.followUser(follower: currentUser, followee: user)
                        currentUser.following.append(user.id)
                        user.followers.append(currentUser.id)
                    }
                    // 状態を更新
                    reloadUserData()
                }) {
                    Text(currentUser.isFollowing(user: user) ? "フォロー解除" : "フォロー")
                        .font(.subheadline)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(currentUser.isFollowing(user: user) ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                }
            }
            .padding()
        }
    }
    
    private func reloadUserData() {
        // ユーザー情報をリロードする処理
        if let updatedCurrentUser = UserDefaultsHelper.shared.loadUser().first(where: { $0.id == currentUser.id }) {
            currentUser = updatedCurrentUser
        }
        if let updatedUser = UserDefaultsHelper.shared.loadUser().first(where: { $0.id == user.id }) {
            user = updatedUser
        }
        UserDefaultsHelper.shared.saveCurrentUser(currentUser) // 現在のユーザーを保存
    }
}

#Preview {
    AllElectoricInformationView(user: .constant(User(username: "", university: "", posts: [], followers: [], following: [], accountname: "", faculty: "", department: "", club: "", bio: "", twitterHandle: "", email: "", stories: [], iconImageData: nil)))
}