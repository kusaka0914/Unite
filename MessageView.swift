import SwiftUI

struct MessageView: View {
    @Binding var currentUser: User
    var otherUser: User
    @State private var messageText: String = ""
    @State private var messages: [Message] = []
    @FocusState private var isMessageFieldFocused: Bool // フォーカス状態を管理するプロパティを追加

    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(messages) { message in
                            HStack {
                                if message.senderId == currentUser.id {
                                    Spacer()
                                    Text(message.text)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                } else {
                                    Text(message.text)
                                        .padding()
                                        .background(Color.gray)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                            .id(message.id) // 各メッセージにIDを設定
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
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: 30)
                        .focused($isMessageFieldFocused) // フォーカス状態をバインド

                    Button(action: {
                        sendMessage()
                        isMessageFieldFocused = false // フォーカスを解除
                        scrollToBottom(scrollViewProxy: scrollViewProxy)
                    }) {
                        Text("送信")
                    }
                }
                .padding()
            }
        }
        .navigationTitle(otherUser.username)
        .navigationBarTitleDisplayMode(.inline)
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

    private func scrollToBottom(scrollViewProxy: ScrollViewProxy) {
        if let lastMessage = messages.last {
            withAnimation {
                scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}