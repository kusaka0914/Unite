import SwiftUI

struct StoryDetailView: View {
    var stories: [Story]
    var currentIndex: Int
    var user: User

    @Binding var currentUser: User
    @State private var selectedIndex: Int
    @State private var isHomeView: Bool = false
    @State private var progress: CGFloat = 0.0
    @State private var timer: Timer?

    init(stories: [Story], currentIndex: Int, user: User, currentUser: Binding<User>) {
        self.stories = stories
        self.currentIndex = currentIndex
        self.user = user
        self._currentUser = currentUser
        self._selectedIndex = State(initialValue: currentIndex)
    }

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text("ストーリーズ")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(elapsedTimeString(since: stories[selectedIndex].postedDate))
                        .font(.caption)
                        .foregroundColor(.white)
                }
                Spacer()
                Button(action: {
                    isHomeView = true
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                }.navigationDestination(isPresented: $isHomeView) {
                    HomeView(currentUser: $currentUser) // 遷移先のビュー
                        .navigationBarBackButtonHidden(true)
                }
            }
            .padding()
            .background(Color.black)
            
            // プログレスバー
            ProgressBar(progress: $progress)
                .frame(height: 4)
                .padding(.horizontal, 0) // 横幅いっぱいにするためにパディングを0に設定
                .background(Color.gray.opacity(0.5))
            
            TabView(selection: $selectedIndex) {
                ForEach(0..<stories.count, id: \.self) { index in
                    if !isStoryExpired(story: stories[index]) { // ストーリーが期限切れでないか確認
                        GeometryReader { geometry in
                            ZStack {
                                if let image = loadImageFromDocumentsDirectory(fileName: stories[index].imageName) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaleEffect(stories[index].imageScale) // スケールを適用
                                        .offset(x: stories[index].imageOffset.width, y: stories[index].imageOffset.height) // 画像のオフセットを適用
                                } else {
                                    Text("画像が見つかりません")
                                }
                                
                                // ここで各テキストフィールドを表示する
                                ForEach(stories[index].texts) { text in
                                    Text(text.text)
                                        .padding(8)
                                        .background(Color.black.opacity(0.7))
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                        .position(x: text.position.x, y: text.position.y)
                                }
                            }
                            .tag(index)
                            .onAppear {
                                startTimer()
                            }
                            .onDisappear {
                                stopTimer()
                            }
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .background(Color.black)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { value in
                        if value.startLocation.x < UIScreen.main.bounds.width / 2 {
                            goToPreviousStory()
                        } else {
                            goToNextStory()
                        }
                    }
            )
            
            // 右下にゴミ箱ボタンを配置
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        deleteCurrentStory()
                    }) {
                        Image(systemName: "trash")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .padding()
                }
            }
        }
        .background(Color.black)
    }

    // ドキュメントディレクトリから画像を読み込む関数
    func loadImageFromDocumentsDirectory(fileName: String) -> UIImage? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = urls[0]
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if let imageData = try? Data(contentsOf: fileURL) {
            return UIImage(data: imageData)
        }
        
        return nil
    }
    
    // ドキュメントディレクトリからテキストデータを読み込む関数
    func loadTextsFromDocumentsDirectory(fileName: String) -> [DraggableText]? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = urls[0]
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if let textsData = try? Data(contentsOf: fileURL) {
            let decoder = JSONDecoder()
            if let texts = try? decoder.decode([DraggableText].self, from: textsData) {
                return texts
            }
        }
        
        return nil
    }
    
    // ストーリーが期限切れかどうかを確認する関数
    func isStoryExpired(story: Story) -> Bool {
        let currentTime = Date()
        let storyTime = story.postedDate
        return currentTime.timeIntervalSince(storyTime) > 24 * 60 * 60
    }
    
    // 経過時間を文字列で返す関数
    func elapsedTimeString(since date: Date) -> String {
        let currentTime = Date()
        let elapsedTime = currentTime.timeIntervalSince(date)
        
        if elapsedTime < 60 {
            return "\(Int(elapsedTime))秒前"
        } else if elapsedTime < 3600 {
            return "\(Int(elapsedTime / 60))分前"
        } else {
            return "\(Int(elapsedTime / 3600))時間前"
        }
    }
    
    // タイマーを開始する関数
    func startTimer() {
        stopTimer()
        progress = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            progress += 0.01
            if progress >= 1.0 {
                goToNextStory()
            }
        }
    }
    
    // タイマーを停止する関数
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // 次のストーリーに移動する関数
    func goToNextStory() {
        if selectedIndex < stories.count - 1 {
            selectedIndex += 1
        } else {
            isHomeView = true
        }
    }
    
    // 前のストーリーに移動する関数
    func goToPreviousStory() {
        if selectedIndex > 0 {
            selectedIndex -= 1
        } else {
            isHomeView = true
        }
    }
    
    // 現在のストーリーを削除する関数
    func deleteCurrentStory() {
        if selectedIndex < stories.count {
            let storyToDelete = stories[selectedIndex]
            if let index = currentUser.stories.firstIndex(where: { $0.id == storyToDelete.id }) {
                currentUser.stories.remove(at: index)
                UserDefaultsHelper.shared.saveUser(currentUser)
                if selectedIndex < stories.count - 1 {
                    goToNextStory()
                } else if selectedIndex > 0 {
                    goToPreviousStory()
                } else {
                    isHomeView = true
                }
            }
        }
    }
}

struct ProgressBar: View {
    @Binding var progress: CGFloat

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)

                Rectangle()
                    .frame(width: min(geometry.size.width, geometry.size.width * progress), height: geometry.size.height)
                    .foregroundColor(Color.blue)
                    .animation(.linear, value: progress)
            }
        }
    }
}