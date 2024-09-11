import SwiftUI
import SwiftData

struct UserProfileView: View {
    @Binding var user: User
    @State private var isEditProfileViewActive = false
    @State private var isEditIconViewActive = false
    @State private var isSearchViewActive = false
    @State private var isAllFollowingViewActive = false // フォロー中ビューの状態を追加
    @State private var isAllFollwedViewActive = false // フォロワービューの状態を追加
    @State private var isHomeViewActive = false
    @State private var iconImage: UIImage? = nil
    @State private var selectedPost: Post? = nil
    @State private var isPostDetailViewActive = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack {
                        Text(user.username)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.leading)
                        Image("vector")
                            .padding(.top, 8)
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
                        Image("menu")
                            .resizable()
                            .frame(width: 36, height: 36)
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
                                    .padding(.trailing,16)
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
                            .onTapGesture {
                                isAllFollwedViewActive = true
                            }
                            .navigationDestination(isPresented: $isAllFollwedViewActive) {
                                AllFollwedView(user: $user)
                                .navigationBarBackButtonHidden(true)
                            }
                            
                            VStack(alignment: .center) {
                                Text("フォロー中").font(.subheadline)
                                Text("\(user.following.count)")
                            }
                            .onTapGesture {
                                isAllFollowingViewActive = true
                            }
                            .navigationDestination(isPresented: $isAllFollowingViewActive) {
                                AllFollowingView(user: $user)
                                .navigationBarBackButtonHidden(true)
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
                            Button(action: {
                                isEditProfileViewActive = true
                            }) {
                                Text("プロフィールを編集")
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .foregroundColor(.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white, lineWidth: 1)
                                    )
                            }
                            .navigationDestination(isPresented: $isEditProfileViewActive) {
                                EditProfileView(user: $user, isEditProfileViewActive: $isEditProfileViewActive)
                                    .navigationBarBackButtonHidden(true)
                                    .navigationBarItems(leading: Button(action: {
                                        isEditProfileViewActive = false
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.white)
                                            .imageScale(.large)
                                    })
                            }
                            Spacer()
                        }
                        .padding(.leading)
                        .padding(.bottom,24)
                        
                        if user.posts.count == 0 {
                            Text("投稿がありません")
                                .padding(.leading, 16)
                                .padding(.bottom, 24)
                        } else {
                        // 投稿のサムネイルを表示するGrid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 0) {
                            ForEach(user.posts.reversed()) { post in // 逆順に表示
                                PostThumbnailView(post: post)
                                    .onTapGesture {
                                        selectedPost = post
                                        isPostDetailViewActive = true
                                    }
                                }
                            }.padding(.horizontal, 16)
                        }
                    }
                    .padding(.leading, 16)
                }
            }
            
            Spacer() // これにより、ナビゲーションバーが最下部に配置されます
            
            HStack {
                Spacer()
                Button(action: {
                    isHomeViewActive = true
                }) {
                    Image(systemName: "house")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                }
                .navigationDestination(isPresented: $isHomeViewActive) {
                    HomeView(currentUser: $user)
                        .navigationBarBackButtonHidden(true)
                }
                Spacer()
                Button(action: {
                    isSearchViewActive = true
                }) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                }
                .navigationDestination(isPresented: $isSearchViewActive) {
                    SearchView(user: $user) // 遷移先のビュー
                    .navigationBarBackButtonHidden(true)
                }
                Spacer()
                NavigationLink(destination: CreatePostView(user: $user)
                    .navigationBarBackButtonHidden(true)
                ) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                }
                Spacer()
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding()
                Spacer()
            }
            .foregroundColor(.white)
            .background(Color.black) // ナビゲーションバーの背景色を設定
        }
        .background(Color.black)
        .foregroundColor(.white)
        .onAppear {
            if let iconImageData = user.iconImageData,
               let uiImage = UIImage(data: iconImageData) {
                iconImage = uiImage
            }
        }
        .navigationDestination(isPresented: $isPostDetailViewActive) {
            if let selectedPost = selectedPost {
                PostDetailView(user: $user, currentUser: $user, posts: $user.posts, selectedPost: $selectedPost)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct PostThumbnailView: View {
    var post: Post

    var body: some View {
        if let imageData = post.images.first, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipped()
        } else {
            Rectangle()
                .fill(Color.gray)
                .frame(width: 100, height: 100)
                .cornerRadius(8)
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(user: .constant(User(username: "takumi_140812", university: "弘前大学", posts: [], followers: [], following: [], accountname: "たくみ", faculty: "理工学部", department: "電子情報工学科", club: "なし", bio: "23s 電情 && 株式会社Spleanエンジニア", twitterHandle: "@takumi_web_design", email: "takumi@example.com", stories: [], iconImageData: nil)))
    }
}