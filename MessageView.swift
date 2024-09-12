import SwiftUI

struct MessageView: View {
    @Binding var currentUser: User
    var otherUser: User
    @State private var messageText: String = ""
    @State private var messages: [Message] = []
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @FocusState private var isMessageFieldFocused: Bool // フォーカス状態を管理するプロパティを追加
    @State private var isAllMessageViewActive = false

    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(messages) { message in
                            HStack {
                                if message.senderId == currentUser.id {
                                    Spacer()
                                    if let imageData = message.image, let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: UIScreen.main.bounds.width * 0.7)
                                            .cornerRadius(20)
                                            .contextMenu {
                                                Button(action: {
                                                    UIPasteboard.general.image = uiImage
                                                }) {
                                                    Text("コピー")
                                                    Image(systemName: "doc.on.doc")
                                                }
                                                Button(action: {
                                                    deleteMessage(message)
                                                }) {
                                                    Text("削除")
                                                    Image(systemName: "trash")
                                                }
                                            }
                                    } else {
                                        Text(message.text)
                                            .padding()
                                            .background(Color(red: 121/255, green: 33/255, blue: 222/255))
                                            .foregroundColor(.white)
                                            .cornerRadius(20)
                                            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .trailing) // フレームを設定
                                            .contextMenu {
                                                Button(action: {
                                                    UIPasteboard.general.string = message.text
                                                }) {
                                                    Text("コピー")
                                                    Image(systemName: "doc.on.doc")
                                                }
                                                Button(action: {
                                                    deleteMessage(message)
                                                }) {
                                                    Text("削除")
                                                    Image(systemName: "trash")
                                                }
                                            }
                                    }
                                } else {
                                    if let imageData = message.image, let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: UIScreen.main.bounds.width * 0.7)
                                            .cornerRadius(20)
                                            .contextMenu {
                                                Button(action: {
                                                    UIPasteboard.general.image = uiImage
                                                }) {
                                                    Text("コピー")
                                                    Image(systemName: "doc.on.doc")
                                                }
                                                Button(action: {
                                                    deleteMessage(message)
                                                }) {
                                                    Text("削除")
                                                    Image(systemName: "trash")
                                                }
                                            }
                                    } else {
                                        Text(message.text)
                                            .padding()
                                            .background(Color(red: 46/255, green: 44/255, blue: 44/255))
                                            .foregroundColor(.white)
                                            .cornerRadius(20)
                                            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .leading) // フレームを設定
                                            .contextMenu {
                                                Button(action: {
                                                    UIPasteboard.general.string = message.text
                                                }) {
                                                    Text("コピー")
                                                    Image(systemName: "doc.on.doc")
                                                }
                                                Button(action: {
                                                    deleteMessage(message)
                                                }) {
                                                    Text("削除")
                                                    Image(systemName: "trash")
                                                }
                                            }
                                    }
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                            .id(message.id) // 各メッセージにIDを設定
                            .padding(.bottom, 8)
                        }
                    }
                }
                .onAppear {
                    loadMessages()
                    scrollToBottom(scrollViewProxy: scrollViewProxy)
                }
                .onChange(of: messages.count) { _ in
                    scrollToBottom(scrollViewProxy: scrollViewProxy)
                }
                .onChange(of: isMessageFieldFocused) { focused in
                    if focused {
                        scrollToBottom(scrollViewProxy: scrollViewProxy)
                    }
                }

                HStack {
                    TextField("メッセージを入力...", text: $messageText)
                        .padding(.leading, 10)
                        .frame(height: 40)
                        .focused($isMessageFieldFocused) // フォーカス状態をバインド
                        .background(Color(red: 46/255, green: 44/255, blue: 44/255))
                        .cornerRadius(10)

                    Button(action: {
                        showImagePicker = true
                    }) {
                        Image(systemName: "photo")
                            .foregroundColor(.blue)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                    }

                    Button(action: {
                        if let selectedImage = selectedImage {
                            sendImage(selectedImage)
                        } else {
                            sendMessage()
                        }
                        isMessageFieldFocused = false // フォーカスを解除
                        scrollToBottom(scrollViewProxy: scrollViewProxy)
                    }) {
                        Text("送信")
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(5)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(otherUser.username)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: Button(action: {
                isAllMessageViewActive = true
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .imageScale(.large)
            }
        )
        .navigationDestination(isPresented: $isAllMessageViewActive) {
            AllMessageView(currentUser: $currentUser)
            .navigationBarBackButtonHidden(true)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerWithSendView(selectedImage: $selectedImage, isPresented: $showImagePicker) {
                if let selectedImage = selectedImage {
                    sendImage(selectedImage)
                }
            }
        }
    }

    private func loadMessages() {
        // メッセージをロードする前に配列をクリア
        messages.removeAll()
        
        // currentUserのメッセージを取得
        if let currentUser = UserDefaultsHelper.shared.loadCurrentUser() {
            messages = currentUser.messages.filter { ($0.receiverId == otherUser.id && $0.senderId == currentUser.id) || ($0.receiverId == currentUser.id && $0.senderId == otherUser.id) }
        }
    }

    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        let newMessage = Message(id: UUID(), senderId: currentUser.id, receiverId: otherUser.id, text: messageText, date: Date())
        UserDefaultsHelper.shared.sendMessage(sender: currentUser, receiver: otherUser, text: messageText)
        messages.append(newMessage) // 新しいメッセージを直接追加
        messageText = ""
    }

    private func sendImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        let newMessage = Message(id: UUID(), senderId: currentUser.id, receiverId: otherUser.id, text: "", image: imageData, date: Date())
        UserDefaultsHelper.shared.sendMessage(sender: currentUser, receiver: otherUser, text: "", image: imageData)
        messages.append(newMessage) // 新しいメッセージを直接追加
        selectedImage = nil
    }

    private func deleteMessage(_ message: Message) {
        if let index = messages.firstIndex(where: { $0.id == message.id }) {
            messages.remove(at: index)
            // UserDefaultsからも削除する
            UserDefaultsHelper.shared.deleteMessage(message)
        }
    }

    private func scrollToBottom(scrollViewProxy: ScrollViewProxy) {
        if let lastMessage = messages.last {
            withAnimation {
                scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}