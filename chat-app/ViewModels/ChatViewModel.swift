import Foundation
import SwiftUI

struct Chat: Identifiable {
    let id = UUID()
    var title: String
    var messages: [Message]
}

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var inputMessage: String = ""
    @Published var chatHistories: [Chat] = []
    @Published var selectedChatId: UUID?
    
    init() {
        startNewChat()
    }
    
    func startNewChat() {
        let newChat = Chat(title: "新对话 \(chatHistories.count + 1)", messages: [])
        chatHistories.append(newChat)
        selectedChatId = newChat.id
        messages = []
    }
    
    func sendMessage() {
        guard !inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        // 添加用户消息
        let userMessage = Message(content: inputMessage, isUser: true)
        messages.append(userMessage)
        
        // 更新当前对话
        if let index = chatHistories.firstIndex(where: { $0.id == selectedChatId }) {
            chatHistories[index].messages = messages
            
            // 如果是第一条消息，用��更新对话标题
            if messages.count == 1 {
                chatHistories[index].title = inputMessage.prefix(20) + (inputMessage.count > 20 ? "..." : "")
            }
        }
        
        // 模拟AI响应
        let aiResponse = Message(content: "这是一个模拟的AI响应。", isUser: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.messages.append(aiResponse)
            // 同步更新当前对话
            if let index = self.chatHistories.firstIndex(where: { $0.id == self.selectedChatId }) {
                self.chatHistories[index].messages = self.messages
            }
        }
        
        inputMessage = ""
    }
    
    func selectChat(_ chat: Chat) {
        selectedChatId = chat.id
        messages = chat.messages
    }
} 