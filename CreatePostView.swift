import SwiftUI
import Mantis
import PhotosUI

struct CreatePostView: View {
    @Binding var user: User
    @State var image: UIImage?
    @State var isCropViewShowing = false
    @State private var cropShapeType: Mantis.CropShapeType = .rect // トリミングの形を指定
    @State private var selectedItems: [PhotosPickerItem] = []
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                if let image = image {
                    Image(uiImage: image) // 画像表示
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("画像が選択されていません")
                }
                Spacer()
                HStack {
                    Spacer()
                    Button { // 丸トリミングボタン
                        cropShapeType = .circle()
                        isCropViewShowing = true
                    } label: {
                        Image(systemName: "circle.square")
                            .font(.title2)
                    }
                    .padding()
                    Spacer()
                    Button { // 四角トリミングボタン
                        cropShapeType = .rect
                        isCropViewShowing = true
                    } label: {
                        Image(systemName: "crop")
                            .font(.title2)
                    }
                    .padding()
                    Spacer()
                }
                PhotosPicker(selection: $selectedItems, matching: .images, photoLibrary: .shared()) {
                    Text("写真フォルダーから選択")
                        .foregroundColor(.blue)
                        .padding()
                }
                .onChange(of: selectedItems) { newItems in
                    Task {
                        if let newItem = newItems.first {
                            if let data = try? await newItem.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                image = uiImage
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("画像選択", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("戻る")
                        .foregroundColor(.blue)
                },
                trailing: NavigationLink(destination: NextView(user: $user, image: $image)) {
                    Text("次へ")
                        .foregroundColor(.blue)
                }
            )
        }
        // トリミング画面の表示
        .fullScreenCover(isPresented: $isCropViewShowing) {
            ImageCropper(image: $image, isCropViewShowing: $isCropViewShowing, cropShapeType: $cropShapeType)
                .ignoresSafeArea()
        }
    }
}

struct NextView: View {
    @Binding var user: User
    @Binding var image: UIImage?
    @State private var postText: String = ""
    @State private var isUserProfileViewShowing = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("画像がありません")
            }
            TextField("キャプションを入力", text: $postText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Spacer()

            Button(action: {
                savePost()
                isUserProfileViewShowing = true
            }) {
                Text("投稿する")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
            .fullScreenCover(isPresented: $isUserProfileViewShowing) {
                UserProfileView(user: $user)
            }
        }
        .navigationBarTitle("新規投稿", displayMode: .inline)
    }

    private func savePost() {
        // 画像をDataに変換
        let imageData = image?.jpegData(compressionQuality: 1.0) ?? Data()
        let newPost = Post(id: UUID(), text: postText, images: [imageData], date: Date())
        user.posts.append(newPost)
        
        // ユーザーを保存
        UserDefaultsHelper.shared.saveUser(user)
    }
}