import SwiftUI

struct NotificationListView: View {
    @Binding var user: User
    @Environment(\.dismiss) var dismiss
    @State var isHomeViewActive: Bool = false

    var body: some View {
        NavigationView {
            List {
                if user.notifications.isEmpty {
                    Text("通知がありません")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.vertical, 8)
                } else {
                    ForEach(Array(user.notifications.reversed())) { notification in
                        HStack {
                            if let sender = findUser(by: notification.senderId) {
                                if let iconImageData = sender.iconImageData, let uiImage = UIImage(data: iconImageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .padding(.leading, 20)
                                } else {
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .padding(.leading, 20)
                                }
                            }
                            VStack(alignment: .leading) {
                                Text(notification.message)
                                    .font(.subheadline)
                                Text(formatDate(notification.date))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            if notification.type == .follow {
                                Button(action: {
                                    // フォロー/フォロー解除のアクション
                                    toggleFollow(senderId: notification.senderId)
                                }) {
                                    Text(isFollowing(senderId: notification.senderId) ? "フォロー中" : "フォロー")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(isFollowing(senderId: notification.senderId) ? Color.gray : Color.blue)
                                        .cornerRadius(5)
                                }.padding(.trailing, 20)
                            }
                        }
                        .padding(.vertical, 8)
                    }.listRowBackground(Color.clear) // 行の背景色を透明に設定
                    .listRowInsets(EdgeInsets()) // 行のインセットを削除
                }
            }.listStyle(PlainListStyle())

            .navigationTitle("通知")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                isHomeViewActive = true
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .imageScale(.large)
            }.navigationDestination(isPresented: $isHomeViewActive) {
                HomeView(currentUser: $user) // 遷移先のビュー
                    .navigationBarBackButtonHidden(true)
            })
        }
    }

    private func findUser(by id: UUID) -> User? {
        return UserDefaultsHelper.shared.loadUser().first { $0.id == id }
    }

    private func isFollowing(senderId: UUID) -> Bool {
        return user.following.contains(senderId)
    }

    private func toggleFollow(senderId: UUID) {
        if isFollowing(senderId: senderId) {
            if let sender = findUser(by: senderId) {
                UserDefaultsHelper.shared.unfollowUser(follower: user, followee: sender)
                user.following.removeAll { $0 == senderId }
            }
        } else {
            if let sender = findUser(by: senderId) {
                UserDefaultsHelper.shared.followUser(follower: user, followee: sender)
                user.following.append(senderId)
            }
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.minute, .hour, .day]
        formatter.maximumUnitCount = 1
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false
        formatter.calendar?.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date, to: Date()) ?? ""
    }
}

struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleNotification = Notification(id: UUID(), type: .follow, message: "sthkr_1368があなたをフォローしました。", date: Date(), senderId: UUID())
        NotificationListView(user: .constant(User(id: UUID(), username: "takumi_140812", university: "弘前大学", posts: [], followers: [], following: [], accountname: "たくみ", faculty: "理工学部", department: "電子情報工学科", club: "なし", bio: "23s 電情 && 株式会社Spleanエンジニア", twitterHandle: "@takumi_web_design", email: "takumi@example.com", stories: [], iconImageData: nil, notifications: [sampleNotification])))
    }
}