import SwiftUI
import PhotosUI

struct EditIconView: View {
    @Binding var user: User
    @Binding var iconImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
        Form {
            Section(header: Text("アイコンを編集")) {
                if let iconImage = iconImage {
                    Image(uiImage: iconImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .clipShape(Circle())
                }
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Text("写真フォルダーから選択")
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            iconImage = uiImage
                            user.iconImageData = data // ユーザーデータにアイコン画像を保存
                        }
                    }
                }
            }
            Section {
                Button(action: {
                    saveIcon()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("保存")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.white)
                }
            }
        }
        .navigationTitle("アイコン")
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .imageScale(.large)
            }
        )
    }

    private func saveIcon() {
        if let iconImage = iconImage,
           let data = iconImage.jpegData(compressionQuality: 0.8) {
            user.iconImageData = data
            UserDefaultsHelper.shared.saveUser(user) // ユーザーデータを保存
        }
    }
}

struct EditIconView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditIconView(user: .constant(User(username: "", university: "", posts: [], followers: [], following: [], accountname: "", faculty: "", department: "", club: "", bio: "", twitterHandle: "", email: "", stories: [], iconImageData: nil)), iconImage: .constant(nil))
        }
    }
}