import SwiftUI

struct CreateStoryView: View {
    @Binding var currentUser: User
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var texts: [DraggableText] = [] // タップごとに表示するテキストデータ
    @State private var imageOffset: CGSize = .zero // 画像のオフセット
    @State private var imageScale: CGFloat = 1.0 // 画像のスケール
    @Environment(\.presentationMode) var presentationMode
    var onStoryCreated: ((Story) -> Void)? // コールバックを追加

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
                    ZStack {
                        if let selectedImage = selectedImage {
                            DraggableImageView(image: selectedImage, offset: $imageOffset, scale: $imageScale)
                        }
                        
                        // ここで各テキストフィールドを表示する
                        ForEach($texts) { $text in
                            DraggableTextView(draggableText: $text)
                        }
                    }
                    .contentShape(Rectangle()) // タップを検出するために必要
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            isImagePickerPresented = true
                        }) {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding([.leading, .bottom], 20)
                        .sheet(isPresented: $isImagePickerPresented) {
                            ImagePicker(selectedImage: $selectedImage)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            guard let selectedImage = selectedImage else { return }
                            let newStory = Story(imageName: saveImageToDocumentsDirectory(image: selectedImage), texts: texts, imageOffset: imageOffset, imageScale: imageScale, postedDate: Date()) // 画像のオフセットとスケール、投稿日時を追加
                            currentUser.stories.append(newStory)
                            UserDefaultsHelper.shared.saveUser(currentUser)
                            onStoryCreated?(newStory) // コールバックを呼び出す
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding([.trailing, .bottom], 20)
                        .disabled(selectedImage == nil)
                    }
                }
            }
            
            // 左上に罰ボタンを配置
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .padding()
                    Spacer()
                }
                Spacer()
            }
        }
        .contentShape(Rectangle()) // タップを検出するために必要
        .onTapGesture { location in
            // GeometryProxyを使ってタップした位置を取得
            let tapLocation = location
            
            // 新しいテキストフィールドを追加
            let newText = DraggableText(id: UUID(), text: "", position: tapLocation)
            texts.append(newText)
        }
        .padding()
    }
    
    // 画像をドキュメントディレクトリに保存する関数
    func saveImageToDocumentsDirectory(image: UIImage) -> String {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = urls[0]
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if let data = image.jpegData(compressionQuality: 1.0) {
            try? data.write(to: fileURL)
            
        }
        
        // テキストデータを保存
        let textsFileName = UUID().uuidString + ".json"
        let textsFileURL = documentsDirectory.appendingPathComponent(textsFileName)
        let encoder = JSONEncoder()
        if let textsData = try? encoder.encode(texts) {
            try? textsData.write(to: textsFileURL)
            
            // テキストデータをデコードして出力
            if let decodedTexts = try? JSONDecoder().decode([DraggableText].self, from: textsData) {
                for text in decodedTexts {
                    
                }
            }
        }
        
        return fileName
    }
}

struct DraggableTextView: View {
    @Binding var draggableText: DraggableText
    @State private var offset: CGSize = .zero
    @State private var isEditing: Bool = false
    @State private var scale: CGFloat = 1.0
    @State private var lastScaleValue: CGFloat = 1.0

    var body: some View {
        TextField("Enter text", text: $draggableText.text, onEditingChanged: { editing in
            isEditing = editing
        })
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 5)
        .scaleEffect(scale)
        .position(x: draggableText.position.x + offset.width, y: draggableText.position.y + offset.height)
        .gesture(
            SimultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        if !isEditing {
                            offset = value.translation
                        }
                    }
                    .onEnded { value in
                        if !isEditing {
                            draggableText.position.x += offset.width
                            draggableText.position.y += offset.height
                            offset = .zero
                            // 位置を保存
                            saveTextPosition()
                        }
                    },
                MagnificationGesture()
                    .onChanged { value in
                        let delta = value / lastScaleValue
                        lastScaleValue = value
                        scale *= delta
                    }
                    .onEnded { _ in
                        lastScaleValue = 1.0
                    }
            )
        )
        .onTapGesture {
            isEditing = true
        }
    }
    
    // テキストの位置を保存する関数
    private func saveTextPosition() {
        // ここでテキストの位置を保存するロジックを実装
        // 例えば、UserDefaultsやファイルに保存するなど
        
    }
}

struct DraggableImageView: View {
    var image: UIImage
    @Binding var offset: CGSize
    @Binding var scale: CGFloat
    @State private var lastScaleValue: CGFloat = 1.0
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .scaleEffect(scale)
            .offset(x: offset.width , y: offset.height)
            .gesture(
                SimultaneousGesture(
                    DragGesture()
                        .onChanged { value in
                            offset = CGSize(width: value.translation.width + lastOffset.width, height: value.translation.height + lastOffset.height)
                        }
                        .onEnded { value in
                            lastOffset = CGSize(width: offset.width, height: offset.height)
                            offset = .zero
                        },
                    MagnificationGesture()
                        .onChanged { value in
                            let delta = value / lastScaleValue
                            lastScaleValue = value
                            scale *= delta
                        }
                        .onEnded { _ in
                            lastScaleValue = 1.0
                        }
                )
            )
            .onChange(of: lastOffset) { newValue in
                offset = newValue
            }
    }
}