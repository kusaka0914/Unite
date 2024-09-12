import SwiftUI

struct BulltinBoardView: View {
    @Binding var currentUser: User
    @State private var posts: [BulltinBoard] = UserDefaultsHelper.shared.loadBulletinBoardPosts() // 投稿内容を保持する配列
    @State private var isBulltinBoardPostViewActive = false
    @State private var selectedPost: BulltinBoard? = nil

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // 戻るボタンのアクション
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                        .padding()
                }
                Spacer()
                Text("助け合い掲示板")
                    .font(.headline)
                Spacer()
            }
            .padding()

            ScrollView {
                ForEach(posts) { post in
                    VStack(alignment: .leading) {
                        HStack {
                            if let user = UserDefaultsHelper.shared.loadUser().first(where: { $0.id == post.userId }) {
                                if let iconImageData = user.iconImageData, let uiImage = UIImage(data: iconImageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                }
                                VStack(alignment: .leading) {
                                    Text(user.username)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Text(post.isResolved ? "解決済み" : "回答受付中")
                                        .font(.subheadline)
                                        .foregroundColor(post.isResolved ? .green : .red)
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal)

                        Text(post.title)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal)

                        if let postImageData = post.image, let postImage = UIImage(data: postImageData) {
                            Image(uiImage: postImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: UIScreen.main.bounds.width - 40)
                                .padding()
                        }
                    }
                    .padding(.bottom)
                    .onTapGesture {
                        selectedPost = post
                    }
                    .background(
                        NavigationLink(
                            destination: BulltinBoardDetailView(post: post),
                            isActive: Binding(
                                get: { selectedPost == post },
                                set: { if !$0 { selectedPost = nil } }
                            )
                        ) {
                            EmptyView()
                        }
                        .hidden()
                    )
                }
            }

            Spacer()

            Button(action: {
                isBulltinBoardPostViewActive = true
            }) {
                Text("投稿ページへ")
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            .padding()
            .navigationDestination(isPresented: $isBulltinBoardPostViewActive) {
                BulltinBoardPostView(currentUser: $currentUser)
            }
        }
    }
}

struct BulltinBoardView_Previews: PreviewProvider {
    static var previews: some View {
        BulltinBoardView(currentUser: .constant(User(id: UUID(), username: "", university: "", posts: [], followers: [], following: [], accountname: "", faculty: "", department: "", club: "", bio: "", twitterHandle: "", email: "", stories: [])))
    }
}