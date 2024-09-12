import SwiftUI

struct BulltinBoardDetailView: View {
    var post: BulltinBoard
    @State private var isMessageViewActive = false
    @State private var postUser: User? = nil

    var body: some View {
        VStack(alignment: .leading) {
            Text(post.title)
                .font(.largeTitle)
                .padding()

            Text(post.text)
                .padding()

            if let postImageData = post.image, let postImage = UIImage(data: postImageData) {
                Image(uiImage: postImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: UIScreen.main.bounds.width - 40)
                    .padding()
            }

            Spacer()

            Button(action: {
                if let user = UserDefaultsHelper.shared.loadUser().first(where: { $0.id == post.userId }) {
                    postUser = user
                    isMessageViewActive = true
                }
            }) {
                Text("回答する")
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            .padding()
            .navigationDestination(isPresented: $isMessageViewActive) {
                if let postUser = postUser {
                    MessageView(currentUser: .constant(UserDefaultsHelper.shared.loadCurrentUser()!), otherUser: postUser)
                }
            }
        }
        .navigationTitle("投稿詳細")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BulltinBoardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BulltinBoardDetailView(post: BulltinBoard(id: UUID(), title: "サンプルタイトル", text: "サンプルテキスト", image: nil, userId: UUID()))
    }
}