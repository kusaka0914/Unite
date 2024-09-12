import SwiftUI

struct HomeView: View {
    @State private var users: [User] = UserDefaultsHelper.shared.loadUser()
    @Binding var currentUser: User // 現在のユーザー
    @State private var selectedStory: Story?
    @State private var selectedUser: User?
    @State private var isStoryDetailViewActive = false
    @State private var isSearchViewActive = false
    @State private var isUserProfileViewActive = false
    @State private var isCreateStoryViewActive = false
    @State private var isNotificationViewActive = false
    @State private var selectedPost: Post?
    @State private var isPostDetailViewActive = false
    @State private var showAlert = false
    @State private var isAllMessageViewActive = false
    @State private var isBulltinBoardViewActive = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    HStack {
                        Image("Sphere")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Unite")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .padding(.leading, 30)
                    Spacer()
                    HStack {
                        Button(action: {
                            isBulltinBoardViewActive = true
                        }) {
                            Image("shake")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(.trailing, 10)
                        }
                        .navigationDestination(isPresented: $isBulltinBoardViewActive) {
                            BulltinBoardView(currentUser: $currentUser) // 遷移先のビュー
                                .navigationBarBackButtonHidden(true)
                        }
                        Button(action: {
                            isNotificationViewActive = true
                            currentUser.notifications = currentUser.notifications.map { notification in
                                var updatedNotification = notification
                                updatedNotification.isRead = true
                                return updatedNotification
                            }
                            UserDefaultsHelper.shared.saveUser(currentUser)
                        }) {
                            ZStack {
                                Image("bell")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(.trailing, 10)
                                if currentUser.notifications.contains(where: { !$0.isRead }) {
                                    Text("\(currentUser.notifications.filter { !$0.isRead }.count)")
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                        .padding(5)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                        .offset(x: 10, y: -10)
                                }
                            }
                        }
                        .navigationDestination(isPresented: $isNotificationViewActive) {
                            NotificationListView(user: $currentUser) // 遷移先のビュー
                                .navigationBarBackButtonHidden(true)
                        }
                        Button(action: {
                            isAllMessageViewActive = true
                        }) {
                            ZStack {
                                Image("DM")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                if currentUser.unreadMessagesCount() > 0 {
                                    Text("\(currentUser.unreadMessagesCount())")
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                        .padding(5)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                        .offset(x: 10, y: -10)
                                }
                            }
                        }
                        .navigationDestination(isPresented: $isAllMessageViewActive) {
                            AllMessageView(currentUser: $currentUser) // 遷移先のビュー
                                .navigationBarBackButtonHidden(true)
                        }
                    }.padding()
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        // 自分のストーリーズを表示
                        if let firstStory = currentUser.stories.first {
                            Button(action: {
                                selectedStory = firstStory
                                selectedUser = currentUser
                                isStoryDetailViewActive = true
                            }) {
                                StoryView(story: firstStory, user: currentUser, currentUser: $currentUser)
                            }
                        } else {
                            Button(action: {
                                isCreateStoryViewActive = true
                            }) {
                                VStack {
                                    Button(action: {
                                        isCreateStoryViewActive = true
                                    }) {
                                        VStack {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.largeTitle)
                                                .foregroundColor(.blue)
                                        Text("Create Story")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                        }
                                    }.navigationDestination(isPresented: $isCreateStoryViewActive) {
                                        CreateStoryView(currentUser: $currentUser) // 遷移先のビュー
                                            .navigationBarBackButtonHidden(true)
                                    }
                                }
                            }
                        }
                        
                        // フォローしているユーザーのストーリーズを表示
                        ForEach(users.filter { user in
                            currentUser.following.contains(user.id) // フォローしているユーザーのみにフィルタリング
                        }) { user in
                            if let firstStory = user.stories.first {
                                Button(action: {
                                    selectedStory = firstStory
                                    selectedUser = user
                                    isStoryDetailViewActive = true
                                }) {
                                    StoryView(story: firstStory, user: user, currentUser: $currentUser)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .background(Color.black)
                .foregroundColor(.white)
                
                List {
                    ForEach(users.filter { user in
                        currentUser.following.contains(user.id)
                    }.flatMap { $0.posts }.sorted(by: { $0.date > $1.date })) { post in
                        if let postUser = users.first(where: { $0.posts.contains(where: { $0.id == post.id }) }) {
                            VStack(alignment: .leading) {
                                HStack {
                                    if let iconImageData = postUser.iconImageData, let uiImage = UIImage(data: iconImageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                            .clipShape(Circle())
                                    } else {
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                    }
                                    Text(postUser.username)
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
                                            if let index = currentUser.posts.firstIndex(where: { $0.id == post.id }) {
                                                currentUser.posts[index].isGood.toggle()
                                                currentUser.posts[index].goodCount += currentUser.posts[index].isGood ? 1 : -1
                                                UserDefaultsHelper.shared.saveUser(currentUser)
                                            }
                                        }) {
                                            Image("clap")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                        }
                                        Text("\(post.goodCount)")
                                            .font(.subheadline)
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
                                        .foregroundColor(.gray)
                                        .padding(.bottom, 8)

                                    Text("投稿日: \(post.date.formatted())") // ここは適切な日付フォーマットに変更してください
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            }
                            .id(post.id) // 各投稿にIDを設定
                        }
                    }
                }
                .listStyle(PlainListStyle())
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button(action: {
                        // ホーム画面に遷移するアクション
                    }) {
                        Image(systemName: "house")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding()
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
                        SearchView(user: $currentUser) // 遷移先のビュー
                            .navigationBarBackButtonHidden(true)
                    }
                    Spacer()
                    NavigationLink(destination: CreatePostView(user: $currentUser)
                        .navigationBarBackButtonHidden(true)
                    ) {
                        Image(systemName: "plus")
                            .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                    }
                    Spacer()
                    Button(action: {
                        isUserProfileViewActive = true
                    }) {
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding()
                    }
                    .navigationDestination(isPresented: $isUserProfileViewActive) {
                        UserProfileView(user: $currentUser) // 遷移先のビュー
                            .navigationBarBackButtonHidden(true)
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .background(Color.black) // ナビゲーションバーの背景色を設定
            }
            .background(Color.black)
            .foregroundColor(.white)
            .navigationDestination(isPresented: $isStoryDetailViewActive) {
                if let selectedStory = selectedStory, let selectedUser = selectedUser {
                    StoryDetailView(stories: selectedUser.stories, currentIndex: selectedUser.stories.firstIndex(where: { $0.id == selectedStory.id }) ?? 0, user: selectedUser, currentUser: $currentUser)
                }
            }
        }
        .background(Color.black)
        .foregroundColor(.white)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(currentUser: .constant(User(id: UUID(), username: "", university: "", posts: [], followers: [], following: [], accountname: "", faculty: "", department: "", club: "", bio: "", twitterHandle: "", email: "", stories: [])))
    }
}