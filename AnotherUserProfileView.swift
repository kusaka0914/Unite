import SwiftUI
import SwiftData

struct AnotherUserProfileView: View {
    @Binding var user: User
    @Binding var currentUser: User // 現在のユーザー
    @State private var isEditProfileViewActive = false
    @State private var isSearchViewActive = false
    @Environment(\.dismiss) private var dismiss // dismiss環境変数を追加
    @State private var reloadTrigger = false // リロードトリガー
    @State private var iconImage: UIImage? = nil // アイコン画像の状態を追加
    @State private var selectedPost: Post? = nil
    @State private var isPostDetailViewActive = false

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView { // ScrollViewでラップ
                    VStack {
                        HStack {
                            Text(user.username)
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.leading)
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Text("弘前大学")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.leading, 20)
                                .underline()
                            Spacer()
                        }
                        .padding(.leading, 16)
                        .padding(.top, 16)
                        
                        VStack {
                            HStack {
                                if let iconImage = iconImage {
                                    Image(uiImage: iconImage)
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .padding(.trailing, 24)
                                } else if let iconImageData = user.iconImageData, let uiImage = UIImage(data: iconImageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .padding(.trailing, 24)
                                } else {
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .padding(.trailing, 24)
                                }
                                VStack(alignment: .center) {
                                    Text("投稿").font(.subheadline)
                                    Text("\(user.posts.count)")
                                }
                                VStack(alignment: .center) {
                                    Text("フォロワー").font(.subheadline)
                                    Text("\(user.followers.count)")
                                }
                                .padding(.leading, 4)
                                .padding(.trailing, 4)
                                VStack(alignment: .center) {
                                    Text("フォロー中").font(.subheadline)
                                    Text("\(user.following.count)")
                                }
                                Spacer()
                            }
                            .padding(.leading, 16)
                            
                            if user.accountname != "" {
                                HStack {
                                    Text(user.accountname)
                                        .font(.body)
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                .padding(.leading, 16)
                                .padding(.top, 4)
                                .padding(.bottom, 8)
                            } else {
                                HStack {
                                    Text(user.username)
                                    Spacer()
                                }
                                .padding(.leading, 16)
                                .padding(.top, 4)
                                .padding(.bottom, 8)
                            }
                            
                            HStack {
                                Text(user.faculty + " " + user.department)
                                Spacer()
                            }
                            .padding(.leading, 16)
                            .padding(.bottom, 4)
                            
                            HStack {
                                Text("所属サークル: " + user.club)
                                Spacer()
                            }
                            .padding(.leading, 16)
                            .padding(.bottom, 16)
                            
                            if user.bio != "" {
                                HStack {
                                    Text(user.bio)
                                    + Text(" " + user.twitterHandle)
                                        .foregroundColor(.blue)
                                    Spacer()
                                }
                                .padding(.leading, 16)
                                .padding(.bottom, 24)
                            }
                            
                            HStack {
                                if currentUser.isFollowing(user: user) {
                                    Button(action: {
                                        UserDefaultsHelper.shared.unfollowUser(follower: currentUser, followee: user)
                                        currentUser.following.removeAll { $0 == user.id }
                                        user.followers.removeAll { $0 == currentUser.id }
                                        reloadUserData() // 状態を更新
                                        reloadTrigger.toggle() // リロードトリガーをトグル
                                    }) {
                                        Text("フォロー解除")
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(Color.gray)
                                            .foregroundColor(.white)
                                            .cornerRadius(5)
                                    }
                                } else {
                                    Button(action: {
                                        print("自分: ",currentUser.username)
                                        print("相手: ",user.username)
                                        UserDefaultsHelper.shared.followUser(follower: currentUser, followee: user)
                                        currentUser.following.append(user.id)
                                        user.followers.append(currentUser.id)
                                        reloadUserData() // 状態を更新
                                        reloadTrigger.toggle() // リロードトリガーをトグル
                                    }) {
                                        Text("フォロー")
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(5)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.leading)
                            .padding(.bottom,24)
                            
                            // 投稿のサムネイルを表示するGrid
                            if user.posts.isEmpty {
                                Text("投稿がありません")
                                    .foregroundColor(.gray)
                                    .padding(.top, 20)
                            } else {
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 0) {
                                    ForEach(user.posts.reversed()) { post in // 逆順に表示
                                        PostThumbnailView(post: post)
                                            .onTapGesture {
                                                selectedPost = post
                                                isPostDetailViewActive = true
                                            }
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        .padding(.leading, 16)
                    }
                }
                
                Spacer() // これにより、ナビゲーションバーが最下部に配置されます
                
                HStack {
                    Spacer()
                    Image(systemName: "house")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                    Spacer()
                    NavigationLink(value: "search") {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding()
                    }
                    Spacer()
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                    Spacer()
                    NavigationLink(value: "profile") {
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding()
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .background(Color.black) // ナビゲーションバーの背景色を設定
            }
            .background(Color.black)
            .foregroundColor(.white)
            .navigationBarItems(leading: Button(action: {
                dismiss() // 戻るアクション
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .imageScale(.large)
            })
            .refreshable {
                reloadUserData()
            }
            .navigationDestination(for: String.self) { value in
                switch value {
                case "search":
                    SearchView(user: $currentUser)
                        .navigationBarBackButtonHidden(true) // 必要に応じてコメントアウトを解除
                case "profile":
                    UserProfileView(user: $currentUser)
                        .navigationBarBackButtonHidden(true) // 必要に応じてコメントアウトを解除
                default:
                    EmptyView()
                }
            }
            .navigationDestination(isPresented: $isPostDetailViewActive) {
                if let selectedPost = selectedPost {
                    PostDetailView(user: $user, currentUser: $currentUser, posts: $user.posts, selectedPost: .constant(selectedPost))
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
        .id(reloadTrigger) // リロードトリガーをIDとして使用
        .onAppear {
            if let iconImageData = user.iconImageData,
               let uiImage = UIImage(data: iconImageData) {
                iconImage = uiImage
            }
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
        print("リロード")
    }
}

struct AnotherUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        AnotherUserProfileView(user: .constant(User(username: "takumi_140812", university: "弘前大学", posts: [], followers: [], following: [], accountname: "たくみ", faculty: "理工学部", department: "電子情報工学科", club: "なし", bio: "23s 電情 && 株式会社Spleanエンジニア", twitterHandle: "@takumi_web_design", email: "takumi@example.com", stories: [], iconImageData: nil)), currentUser: .constant(User(username: "current_user", university: "弘前大学", posts: [], followers: [], following: [], accountname: "current", faculty: "理工学部", department: "電子情報工学科", club: "なし", bio: "Current User", twitterHandle: "@current_user", email: "current@example.com", stories: [])))  // 変更
    }
}