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
                        VStack(alignment: .leading) {
                            Text(notification.message)
                                .font(.headline)
                            Text(notification.date, style: .date)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
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
}

struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleNotification = Notification(id: UUID(), type: .follow, message: "あなたをフォローしました", date: Date())
        NotificationListView(user: .constant(User(username: "takumi_140812", university: "弘前大学", posts: [], followers: [], following: [], accountname: "たくみ", faculty: "理工学部", department: "電子情報工学科", club: "なし", bio: "23s 電情 && 株式会社Spleanエンジニア", twitterHandle: "@takumi_web_design", email: "takumi@example.com", stories: [], iconImageData: nil, notifications: [sampleNotification])))
    }
}