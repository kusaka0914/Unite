//
//  AllFollwedView.swift
//  MySNS
//
//  Created by 日下拓海 on 2024/09/07.
//

import SwiftUI

struct AllFollwedView: View {
    @Binding var user: User
    @State private var users: [User] = []
    @State private var isUserProfileViewActive = false
    @Environment(\.dismiss) private var dismiss // dismiss環境変数を追加
    @State private var currentUser: User = User(username: "", university: "", posts: [], followers: [], following: [], accountname: "", faculty: "", department: "", club: "", bio: "", twitterHandle: "", email: "", stories: [], iconImageData: nil)
    @State private var showFollowButton = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("フォロワー")
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
        users = allUsers.filter { user.followers.contains($0.id) }
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



#Preview {
    AllFollwedView(user: .constant(User(username: "takumi_140812", university: "弘前大学", posts: [], followers: [], following: [], accountname: "たくみ", faculty: "理工学部", department: "電子情報工学科", club: "なし", bio: "23s 電情 && 株式会社Spleanエンジニア", twitterHandle: "@takumi_web_design", email: "takumi@example.com", stories: [])))
}