import SwiftUI

struct SearchView: View {
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
                    Text("❶")
                    Text("学部選択")
                    .underline()
                    }
                    Image(systemName: "arrow.right")
                    VStack {
                    Text("②")
                    Text("学科選択")
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
                    DepartmentButton(departmentName: "理工学部", destination: SearchDepartmentView(user: $user)
                    .navigationBarBackButtonHidden(true)
                    )
                    CustomDivider()
                    DepartmentButton(departmentName: "農学生命科学部", destination: SearchDepartmentView(user: $user)
                    .navigationBarBackButtonHidden(true)
                    )
                    CustomDivider()
                    DepartmentButton(departmentName: "医学部", destination: SearchDepartmentView(user: $user)
                    .navigationBarBackButtonHidden(true)
                    )
                    CustomDivider()
                    DepartmentButton(departmentName: "教育学部", destination: SearchDepartmentView(user: $user)
                    .navigationBarBackButtonHidden(true)
                    )
                    CustomDivider()
                    DepartmentButton(departmentName: "人文社会学部", destination: SearchDepartmentView(user: $user)
                    .navigationBarBackButtonHidden(true)
                    )
                    CustomDivider()
                }
                .padding(.top, 20)
                
                Spacer()
                
                HStack {
                    Spacer()
                    NavigationLink(destination: HomeView(currentUser: $user)
                        .navigationBarBackButtonHidden(true)
                    ) {
                    Image(systemName: "house")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                    }
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(user: .constant(User(username: "user1", university: "弘前大学", posts: [], followers: [], following: [], accountname: "account1", faculty: "理工学部", department: "電子情報工学科", club: "サッカー部", bio: "こんにちは", twitterHandle: "@user1", email: "user1@example.com", stories: [])))
    }
}