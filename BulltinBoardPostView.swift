import SwiftUI

struct BulltinBoardPostView: View {
    @Binding var currentUser: User
    @State private var title: String = ""
    @State private var text: String = ""
    @State private var image: UIImage? = nil
    @State private var showImagePicker = false
    @FocusState private var isTextFieldFocused: Bool

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
                Text("新規投稿")
                    .font(.headline)
                Spacer()
                Button(action: {
                    // 投稿ボタンのアクション
                    let newPost = BulltinBoard(id: UUID(), title: title, text: text, image: image?.pngData(), userId: currentUser.id)
                    var posts = UserDefaultsHelper.shared.loadBulletinBoardPosts()
                    posts.append(newPost)
                    UserDefaultsHelper.shared.saveBulletinBoardPosts(posts)
                    text = ""
                    image = nil
                    isTextFieldFocused = false
                }) {
                    Text("投稿")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .padding()
            TextField("タイトル",text: $title)
            TextField("ここにテキストを入力", text: $text)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding()
                .focused($isTextFieldFocused)

            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: UIScreen.main.bounds.width - 40)
                    .padding()
            }

            Button(action: {
                showImagePicker = true
            }) {
                Text("画像を選択")
                    .foregroundColor(.blue)
            }
            .padding()

            Spacer()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $image)
        }
    }
}

struct BulltinBoardPostView_Previews: PreviewProvider {
    static var previews: some View {
        BulltinBoardPostView(currentUser: .constant(User(id: UUID(), username: "", university: "", posts: [], followers: [], following: [], accountname: "", faculty: "", department: "", club: "", bio: "", twitterHandle: "", email: "", stories: [])))
    }
}