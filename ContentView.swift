import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn: Bool = false
    @State private var user: User

    init(user: User) {
        self._user = State(initialValue: user)
    }
    
    var body: some View {
        NavigationStack {
            if isLoggedIn {
                UserProfileView(user: $user)
            } else {
                LoginView(isLoggedIn: $isLoggedIn, user: $user)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(user: User(
            username: "preview_user",
            university: "弘前大学",
            posts: [],
            followers: [],
            following: [],
            accountname: "preview_account",
            faculty: "理工学部",
            department: "電子情報工学科",
            club: "サッカー部",
            bio: "これはプレビュー用のバイオです。",
            twitterHandle: "@preview_user",
            email: "preview_user@example.com",
            stories: []
        ))
    }
}