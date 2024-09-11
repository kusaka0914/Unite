import SwiftUI

struct SearchDepartmentView: View {
    @Binding var user: User
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack {
                Text("Unite with New Friends")
                    .font(.title)
                    .fontWeight(.bold)
                
                HStack {
                    VStack {
                    Text("①")
                    Text("学部選択")
                    }
                    Image(systemName: "arrow.right")
                    VStack {
                    Text("❷")
                    Text("学科選択")
                    .underline()
                    }
                    Image(systemName: "arrow.right")
                    VStack {
                    Text("③")
                    Text("完了")
                    }
                }
                .font(.headline)
                .padding(.top, 10)
                .padding(.bottom, 10)
                
                VStack(spacing: 0) {
                    DepartmentButton(departmentName: "機械科学科", destination: SearchDepartmentView(user: $user))
                    CustomDivider()
                    DepartmentButton(departmentName: "数物科学科", destination: SearchDepartmentView(user: $user))
                    CustomDivider()
                    DepartmentButton(departmentName: "物質創生科学科", destination: SearchDepartmentView(user: $user))
                    CustomDivider()
                    DepartmentButton(departmentName: "電子情報工学科", destination: AllElectoricInformationView(user: $user)
                    .navigationBarBackButtonHidden(true)
                    )
                    CustomDivider()
                    DepartmentButton(departmentName: "地球環境防災学科", destination: SearchDepartmentView(user: $user)
                    .navigationBarBackButtonHidden(true)
                    )
                    CustomDivider()
                    DepartmentButton(departmentName: "自然エネルギー学科", destination: SearchDepartmentView(user: $user))
                }
                .padding(.top, 20)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Image(systemName: "house")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                    Spacer()
                    NavigationLink(destination: SearchView(user: $user)
                        .navigationBarBackButtonHidden(true)
                    ) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding()
                    }
                    Spacer()
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                    Spacer()
                    NavigationLink(destination: UserProfileView(user: $user)
                        .navigationBarBackButtonHidden(true)
                    ) {
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding()
                    }
                }
                .background(Color.black)
                .foregroundColor(.white)
                .padding(.trailing, 30)
                .navigationBarItems(leading: Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .imageScale(.large)
                })
            }
            .background(Color.black)
            .foregroundColor(.white)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct CustomDivider: View {
    var body: some View {
        VStack {
            Divider().background(Color.white)
        }
        .padding(.horizontal, 50)
    }
}

struct DepartmentButton<Destination: View>: View {
    var departmentName: String
    var destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            Text(departmentName)
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.white, lineWidth: 2)
                )
        }
        .padding(.horizontal, 50)
    }
}

struct SearchDepartmentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchDepartmentView(user: .constant(User(username: "user1", university: "弘前大学", posts: [], followers: [], following: [], accountname: "account1", faculty: "理工学部", department: "電子情報工学科", club: "サッカー部", bio: "こんにちは", twitterHandle: "@user1", email: "user1@example.com", stories: [])))
    }
}