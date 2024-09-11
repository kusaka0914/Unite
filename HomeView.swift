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
                            isNotificationViewActive = true
                        }) {
                            Image("bell")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(.trailing, 10)
                        }
                        .navigationDestination(isPresented: $isNotificationViewActive) {
                            NotificationListView(user: $currentUser) // 遷移先のビュー
                                .navigationBarBackButtonHidden(true)
                        }
                        Button(action: {
                            // ダイレクトメッセージ画面に遷移するアクション
                        }) {
                            Image("DM")
                                .resizable()
                                .frame(width: 30, height: 30)
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
                    }) { user in
                        VStack(alignment: .leading) {
                            Text(user.username)
                                .font(.headline)
                            Rectangle()
                                .fill(Color.gray)
                                .frame(height: 200)
                                .overlay(Text("写真").foregroundColor(.white))
                            HStack {
                                Button(action: {
                                    // いいねボタンのアクション
                                }) {
                                    Image("clap")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                Button(action: {
                                    // コメントボタンのアクション
                                }) {
                                    Image("comment")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                Spacer()
                            }
                            .padding(.top, 5)
                        }
                        .padding()
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
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
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