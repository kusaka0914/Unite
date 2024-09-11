import SwiftUI

struct PostDetailView: View {
    @Binding var user: User
    @Environment(\.dismiss) var dismiss
    @Binding var posts: [Post] // すべての投稿を受け取る
    @Binding var selectedPost: Post?

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(posts.reversed()) { post in
                        VStack(alignment: .leading) {
                            HStack {
                                if let iconImageData = user.iconImageData, let uiImage = UIImage(data: iconImageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                }
                                Text(user.username)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding()

                            if !post.images.isEmpty {
                                ForEach(post.images, id: \.self) { imageData in
                                    if let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: UIScreen.main.bounds.width) // 横幅をスマホの横幅に設定
                                    }
                                }
                            } else {
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(height: 300)
                                    .overlay(Text("写真").foregroundColor(.white))
                                    .padding()
                            }

                            VStack(alignment: .leading) {
                                HStack {
                                    Button(action: {
                                        // いいねボタンのアクション
                                    }) {
                                        Image("clap")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                    }
                                    Button(action: {
                                        // コメントボタンのアクション
                                    }) {
                                        Image("comment")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                    }
                                    Spacer()
                                }

                                Text(post.text)
                                    .padding(.bottom, 8)

                                Text("コメントを見る")
                                    .foregroundColor(.blue)
                                    .padding(.bottom, 8)

                                Text("投稿日: \(post.id.uuidString)") // ここは適切な日付フォーマットに変更してください
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                        }
                        .id(post.id) // 各投稿にIDを設定
                    }
                }
            }
            .onAppear {
                if let selectedPost = selectedPost {
                    proxy.scrollTo(selectedPost.id, anchor: .top) // 選択された投稿にスクロール
                }
            }
        }
        .navigationTitle("投稿")
        .navigationBarTitleDisplayMode(.inline)
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

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePost1 = Post(id: UUID(), text: "サンプル投稿1", images: [])
        let samplePost2 = Post(id: UUID(), text: "サンプル投稿2", images: [])
        PostDetailView(user: .constant(User(username: "takumi_140812", university: "弘前大学", posts: [samplePost1, samplePost2], followers: [], following: [], accountname: "たくみ", faculty: "理工学部", department: "電子情報工学科", club: "なし", bio: "23s 電情 && 株式会社Spleanエンジニア", twitterHandle: "@takumi_web_design", email: "takumi@example.com", stories: [], iconImageData: nil)), posts: .constant([samplePost1, samplePost2]), selectedPost: .constant(samplePost1))
    }
}