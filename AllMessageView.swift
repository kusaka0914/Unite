import SwiftUI

struct AllMessageView: View {
    @Binding var currentUser: User
    @State private var users: [User] = UserDefaultsHelper.shared.loadUser()
    @State private var selectedUser: User?
    @State private var isMessageViewActive = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(users.filter { user in
                    currentUser.messages.contains(where: { $0.receiverId == user.id || $0.senderId == user.id })
                }) { user in
                    Button(action: {
                        selectedUser = user
                        isMessageViewActive = true
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
                            Text(user.username)
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $isMessageViewActive) {
                if let selectedUser = selectedUser {
                    MessageView(currentUser: $currentUser, otherUser: selectedUser)
                }
            }
            .navigationTitle("Messages")
        }
    }
}

struct AllMessageView_Previews: PreviewProvider {
    static var previews: some View {
        AllMessageView(currentUser: .constant(User(id: UUID(), username: "currentUser", university: "University", posts: [], followers: [], following: [], accountname: "accountname", faculty: "faculty", department: "department", club: "club", bio: "bio", twitterHandle: "twitterHandle", email: "email", stories: [], iconImageData: nil, notifications: [], messages: [])))
    }
}