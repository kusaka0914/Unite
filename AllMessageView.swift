import SwiftUI

struct AllMessageView: View {
    @Binding var currentUser: User
    @State private var users: [User] = UserDefaultsHelper.shared.loadUser()
    @State private var selectedUser: User?
    @State private var isMessageViewActive = false
    @State private var isHomeViewActive = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(users.filter { user in
                    user.id != currentUser.id && currentUser.messages.contains(where: { $0.receiverId == user.id || $0.senderId == user.id })
                }.sorted(by: { user1, user2 in
                    let lastMessage1 = currentUser.messages.filter { $0.receiverId == user1.id || $0.senderId == user1.id }.max(by: { $0.date < $1.date })
                    let lastMessage2 = currentUser.messages.filter { $0.receiverId == user2.id || $0.senderId == user2.id }.max(by: { $0.date < $1.date })
                    return (lastMessage1?.date ?? Date.distantPast) > (lastMessage2?.date ?? Date.distantPast)
                })) { user in
                    Button(action: {
                        selectedUser = user
                        isMessageViewActive = true
                        markMessagesAsRead(from: user)
                    }) {
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
                            VStack(alignment: .leading) {
                                Text(user.username)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                if let lastMessage = currentUser.messages.filter({ $0.receiverId == user.id || $0.senderId == user.id }).max(by: { $0.date < $1.date }) {
                                    Text(lastMessage.text)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            Spacer()
                            if currentUser.messages.contains(where: { $0.senderId == user.id && !$0.isRead }) {
                                Text("\(currentUser.messages.filter { $0.senderId == user.id && !$0.isRead }.count)")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(Color.red)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $isMessageViewActive) {
                if let selectedUser = selectedUser {
                    MessageView(currentUser: $currentUser, otherUser: selectedUser)
                    .navigationBarBackButtonHidden(true)
                }
            }
            .navigationTitle("メッセージ一覧")
            .navigationBarItems(leading: Button(action: {
                isHomeViewActive = true
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .imageScale(.large)
            }
            .navigationDestination(isPresented: $isHomeViewActive) {
                HomeView(currentUser: $currentUser)
                .navigationBarBackButtonHidden(true)
            }
          )
        }
    }

    private func markMessagesAsRead(from user: User) {
        for i in 0..<currentUser.messages.count {
            if currentUser.messages[i].senderId == user.id && !currentUser.messages[i].isRead {
                currentUser.messages[i].isRead = true
            }
        }
        UserDefaultsHelper.shared.saveUser(currentUser)
    }
}

struct AllMessageView_Previews: PreviewProvider {
    static var previews: some View {
        AllMessageView(currentUser: .constant(User(id: UUID(), username: "currentUser", university: "University", posts: [], followers: [], following: [], accountname: "accountname", faculty: "faculty", department: "department", club: "club", bio: "bio", twitterHandle: "twitterHandle", email: "email", stories: [], iconImageData: nil, notifications: [], messages: [])))
    }
}