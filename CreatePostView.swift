import SwiftUI
import Mantis
import PhotosUI

struct CreatePostView: View {
    @Binding var user: User
    @State var image: UIImage?
    @State var isCropViewShowing = false
    @State private var cropShapeType: Mantis.CropShapeType = .rect // トリミングの形を指定
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var showAlert = false
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
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .imageScale(.large)
                },
                trailing: NavigationLink(destination: NextView(user: $user, image: $image)
                .navigationBarBackButtonHidden(true)
                ) {
                    Text("次へ")
                        .foregroundColor(.white)
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
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("画像がありません")
            }
            ZStack(alignment: .topLeading) {
                TextEditor(text: $postText)
                    .frame(height: 150) // 高さを設定
                    .padding(4)
                    .background(Color.black)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                if postText.isEmpty {
                    Text("キャプションを入力")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                }
            }
            .padding()
            Spacer()

            Button(action: {
                if image == nil {
                    showAlert = true
                } else {
                    savePost()
                    isUserProfileViewShowing = true
                }
            }) {
                Text("投稿する")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("エラー"), message: Text("画像が選択されていません"), dismissButton: .default(Text("OK")))
            }
            .fullScreenCover(isPresented: $isUserProfileViewShowing) {
                UserProfileView(user: $user)
            }
        }
        .navigationBarTitle("新規投稿", displayMode: .inline)
        .navigationBarItems(leading: Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .imageScale(.large)
            })
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