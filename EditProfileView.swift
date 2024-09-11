import SwiftUI

struct EditProfileView: View {
    @Binding var user: User
    @Binding var isEditProfileViewActive: Bool
    @State private var isEditNameViewActive = false
    @State private var isEditAccountNameViewActive = false
    @State private var isEditFacultyViewActive = false
    @State private var isEditDepartmentViewActive = false
    @State private var isEditClubViewActive = false
    @State private var isEditBioViewActive = false
    @State private var isEditIconViewActive = false // アイコン編集ビューの状態を追加
    @State private var iconImage: UIImage? = nil // アイコン画像の状態を追加
    
    init(user: Binding<User>, isEditProfileViewActive: Binding<Bool>) {
        self._user = user
        self._isEditProfileViewActive = isEditProfileViewActive
    }
        
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationLink(destination: EditNameView(username: $user.username), isActive: $isEditNameViewActive) {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                    Text("ユーザー名")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Spacer()
                    Text(user.username)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .contentShape(Rectangle()) // HStack全体をタップ可能にする
                .onTapGesture {
                    isEditNameViewActive = true
                }
            }
            
            NavigationLink(destination: EditAccountNameView(accountname: $user.accountname), isActive: $isEditAccountNameViewActive) {
                HStack {
                    Image(systemName: "at.circle.fill")
                        .foregroundColor(.white)
                    Text("アカウント名")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Spacer()
                    Text(user.accountname)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .contentShape(Rectangle()) // HStack全体をタップ可能にする
                .onTapGesture {
                    isEditAccountNameViewActive = true
                }
            }
            
            NavigationLink(destination: EditFacultyView(faculty: $user.faculty), isActive: $isEditFacultyViewActive) {
                HStack {
                    Image(systemName: "building.columns.fill")
                        .foregroundColor(.white)
                    Text("所属学部")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Spacer()
                    Text(user.faculty)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .contentShape(Rectangle()) // HStack全体をタップ可能にする
                .onTapGesture {
                    isEditFacultyViewActive = true
                }
            }
            
            NavigationLink(destination: EditDepartmentView(department: $user.department), isActive: $isEditDepartmentViewActive) {
                HStack {
                    Image(systemName: "graduationcap.fill")
                        .foregroundColor(.white)
                    Text("所属学科")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Spacer()
                    Text(user.department)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .contentShape(Rectangle()) // HStack全体をタップ可能にする
                .onTapGesture {
                    isEditDepartmentViewActive = true
                }
            }
            
            NavigationLink(destination: EditClubView(club: $user.club), isActive: $isEditClubViewActive) {
                HStack {
                    Image(systemName: "person.3.fill")
                        .foregroundColor(.white)
                    Text("所属サークル")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Spacer()
                    Text(user.club)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .contentShape(Rectangle()) // HStack全体をタップ可能にする
                .onTapGesture {
                    isEditClubViewActive = true
                }
            }
            
            NavigationLink(destination: EditBioView(bio: $user.bio), isActive: $isEditBioViewActive) {
                HStack {
                    Text("プロフィール")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Spacer()
                    Text(user.bio)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .contentShape(Rectangle()) // HStack全体をタップ可能にする
                .onTapGesture {
                    isEditBioViewActive = true
                }
            }
            
            NavigationLink(destination: EditIconView(user: $user, iconImage: $iconImage), isActive: $isEditIconViewActive) {
                HStack {
                    Image(systemName: "photo")
                        .foregroundColor(.white)
                    Text("アイコン")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Spacer()
                    if let iconImage = iconImage {
                        Image(uiImage: iconImage)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .contentShape(Rectangle()) // HStack全体をタップ可能にする
                .onTapGesture {
                    isEditIconViewActive = true
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.black)
        .navigationTitle("プロフィール編集")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadUserData()
            loadIconImage()
        }
        .onDisappear {
            saveProfile()
        }
    }
    
    private func loadUserData() {
        if let userId = UserDefaults.standard.string(forKey: "loggedInUserId"),
           let loadedUser = UserDefaultsHelper.shared.loadUser().first(where: { $0.id.uuidString == userId }) {
            user = loadedUser
        }
    }
    
    private func loadIconImage() {
        if let data = user.iconImageData,
           let uiImage = UIImage(data: data) {
            iconImage = uiImage
        }
    }
    
    private func saveProfile() {
        UserDefaultsHelper.shared.saveUser(user)
        if let iconImage = iconImage,
           let data = iconImage.jpegData(compressionQuality: 0.8) {
            user.iconImageData = data
            UserDefaultsHelper.shared.saveUser(user) // ユーザーデータを保存
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditProfileView(user: .constant(User(username: "", university: "", posts: [], followers: [], following: [], accountname: "", faculty: "", department: "", club: "", bio: "", twitterHandle: "", email: "", stories: [], iconImageData: nil)), isEditProfileViewActive: .constant(false))
        }
    }
}