import SwiftUI

struct Course: Identifiable, Codable {
    let id = UUID()
    var name: String
    var day: String
    var period: Int
    var location: String
}

struct CourseRegistrationView: View {
    @Binding var user: User
    @Binding var currentUser: User
    @State private var isUserProfileViewActive = false
    @State private var selectedCourse: Course? = nil
    @State private var isCourseEditViewActive = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let totalWidth = geometry.size.width
                let remainingWidth = totalWidth - 20 // 20は左側の時間列の幅
                let columnWidth = remainingWidth / 6 // 6列に分割
                
                VStack {
                    HStack {
                        Button(action: {
                            isUserProfileViewActive = true
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .imageScale(.large)
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                        }
                        .navigationDestination(isPresented: $isUserProfileViewActive) {
                            UserProfileView(user: $currentUser)
                                .navigationBarHidden(true)
                        }
                        Text("2024年2学期")
                            .font(.headline)
                            .padding(.trailing, 30)
                        Text("週間時間割")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Text("")
                                .frame(width: 20, height: 30)
                                .background(Color.gray.opacity(0.2))
                                .border(Color.gray)
                            
                            ForEach(["月", "火", "水", "木", "金", "土"], id: \.self) { day in
                                Text(day)
                                    .frame(width: columnWidth, height: 30)
                                    .font(.caption)
                                    .background(Color.gray.opacity(0.2))
                                    .border(Color.gray)
                            }
                        }
                        
                        ForEach(1..<7) { period in
                            HStack(spacing: 0) {
                                Text("\(period)")
                                    .frame(width: 20, height: 80)
                                    .background(Color.gray.opacity(0.2))
                                    .border(Color.gray)
                                    .font(.caption)
                                
                                ForEach(["月", "火", "水", "木", "金", "土"], id: \.self) { day in
                                    if let course = user.courses.first(where: { $0.day == day && $0.period == period }) {
                                        Button(action: {
                                            selectedCourse = course
                                            isCourseEditViewActive = true
                                        }) {
                                            VStack {
                                                Text(course.name)
                                                    .font(.caption2)
                                                    .padding(5)
                                                    .foregroundColor(.white)
                                            }
                                            .frame(width: columnWidth - 10, height: 70) // 隙間を作るために幅と高さを調整
                                            .background(Color.blue.opacity(0.7))
                                            .cornerRadius(5)
                                            .padding(5) // 隙間を作るためにパディングを追加
                                            .border(Color.gray)
                                        }
                                    } else {
                                        Button(action: {
                                            selectedCourse = Course(name: "", day: day, period: period, location: "")
                                            isCourseEditViewActive = true
                                        }) {
                                            Text("")
                                                .frame(width: columnWidth, height: 80)
                                                .border(Color.gray)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true) // デフォルトのナビゲーションバーを非表示にする
            .navigationDestination(isPresented: $isCourseEditViewActive) {
                if let selectedCourse = selectedCourse {
                    CourseEditView(course: selectedCourse, user: $user)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

struct CourseEditView: View {
    @State var course: Course
    @Binding var user: User
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("コース名", text: $course.name)
            TextField("場所", text: $course.location)
            Button("保存") {
                if let index = user.courses.firstIndex(where: { $0.id == course.id }) {
                    user.courses[index] = course
                } else {
                    user.courses.append(course)
                }
                UserDefaultsHelper.shared.saveUser(user) // ユーザーデータを保存
                presentationMode.wrappedValue.dismiss() // CourseRegistrationViewに戻る
            }
        }
        .padding()
    }
}

struct CourseRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        CourseRegistrationView(user: .constant(User(username: "takumi_140812", university: "弘前大学", posts: [], followers: [], following: [], accountname: "たくみ", faculty: "理工学部", department: "電子情報工学科", club: "なし", bio: "23s 電情 && 株式会社Spleanエンジニア", twitterHandle: "@takumi_web_design", email: "takumi@example.com", stories: [], iconImageData: nil, courses: [
            Course(name: "電子回路", day: "月", period: 2, location: "理工第2講義室"),
            Course(name: "電子回路演習", day: "月", period: 3, location: "理工第2講義室"),
            Course(name: "量子・デバイス工学基礎", day: "月", period: 4, location: "理工第2講義室"),
            Course(name: "データサイエンス発展II", day: "月", period: 5, location: "未登録"),
            Course(name: "電磁気学III", day: "水", period: 2, location: "第8講義室"),
            Course(name: "コンピュータアーキテクチャ", day: "木", period: 2, location: "総合301"),
            Course(name: "電子情報工学実験II", day: "木", period: 3, location: "理工401"),
            Course(name: "電子情報工学実験II", day: "木", period: 4, location: "理工401"),
            Course(name: "プログラミング演習III", day: "木", period: 5, location: "理工458"),
            Course(name: "食育概論", day: "木", period: 5, location: "未登録"),
            Course(name: "フィールドワーク", day: "金", period: 5, location: "未登録")
        ])), currentUser: .constant(User(username: "takumi_140812", university: "弘前大学", posts: [], followers: [], following: [], accountname: "たくみ", faculty: "理工学部", department: "電子情報工学科", club: "なし", bio: "23s 電情 && 株式会社Spleanエンジニア", twitterHandle: "@takumi_web_design", email: "takumi@example.com", stories: [], iconImageData: nil)))
    }
}