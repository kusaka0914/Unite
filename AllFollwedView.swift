//
//  AllFollwedView.swift
//  MySNS
//
//  Created by 日下拓海 on 2024/09/07.
//

import SwiftUI

struct AllFollwedView: View {
    @Binding var user: User
    @State private var isUserProfileViewActive = false

    var body: some View {
        List(user.followers, id: \.self) { followerUserId in
            if let followerUser = UserDefaultsHelper.shared.loadUser().first(where: { $0.id == followerUserId }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(followerUser.username)
                            .font(.headline)
                        Text(followerUser.accountname)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("フォロワー")
        .navigationBarItems(leading: Button(action: {
                isUserProfileViewActive = true
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .imageScale(.large)
            }
        )
        .navigationDestination(isPresented: $isUserProfileViewActive) {
            UserProfileView(user: $user)
        }
    }
}

#Preview {
    AllFollwedView(user: .constant(User(username: "takumi_140812", university: "弘前大学", posts: [], followers: [], following: [], accountname: "たくみ", faculty: "理工学部", department: "電子情報工学科", club: "なし", bio: "23s 電情 && 株式会社Spleanエンジニア", twitterHandle: "@takumi_web_design", email: "takumi@example.com", stories: [])))
}