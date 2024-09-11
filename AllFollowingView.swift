//
//  AllFollowingView.swift
//  MySNS
//
//  Created by 日下拓海 on 2024/09/07.
//

import SwiftUI

struct AllFollowingView: View {
    @Binding var user: User
    @Environment(\.dismiss) var dismiss

    var body: some View {
        List(user.following, id: \.self) { followingUserId in
            if let followingUser = UserDefaultsHelper.shared.loadUser().first(where: { $0.id == followingUserId }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(followingUser.username)
                            .font(.headline)
                        Text(followingUser.accountname)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("フォロー中")
        .navigationBarItems(leading: Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .imageScale(.large)
            }
        )
    }
}

#Preview {
    AllFollowingView(user: .constant(User(username: "takumi_140812", university: "弘前大学", posts: [], followers: [], following: [], accountname: "たくみ", faculty: "理工学部", department: "電子情報工学科", club: "なし", bio: "23s 電情 && 株式会社Spleanエンジニア", twitterHandle: "@takumi_web_design", email: "takumi@example.com", stories: [])))
}