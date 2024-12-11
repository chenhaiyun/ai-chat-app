//
//  ContentView.swift
//  chat-app
//
//  Created by Magic Chen on 2024/12/11.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var showSidebar = false
    
    var body: some View {
        ZStack {
            // 主聊天界面
            VStack(spacing: 0) {
                // 顶部Header
                HStack {
                    Button(action: {
                        withAnimation {
                            showSidebar.toggle()
                        }
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.startNewChat()
                    }) {
                        Image(systemName: "square.and.pencil")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                .shadow(radius: 1)
                
                // 聊天记录
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: viewModel.messages.count) {
                        if let lastMessage = viewModel.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                }
                
                // 输入区域
                HStack {
                    TextField("输入消息...", text: $viewModel.inputMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: {
                        viewModel.sendMessage()
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                    .disabled(viewModel.inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .padding(.trailing)
                }
                .padding(.vertical)
                .background(Color(.systemBackground))
                .shadow(radius: 1)
            }
            
            // 侧边栏
            if showSidebar {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showSidebar = false
                        }
                    }
                
                HStack {
                    VStack {
                        List(viewModel.chatHistories) { chat in
                            Button(action: {
                                viewModel.selectChat(chat)
                                withAnimation {
                                    showSidebar = false
                                }
                            }) {
                                Text(chat.title)
                                    .lineLimit(1)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.75)
                    .background(Color(.systemBackground))
                    
                    Spacer()
                }
                .transition(.move(edge: .leading))
            }
        }
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.content)
                .padding(12)
                .background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(message.isUser ? .white : .primary)
                .cornerRadius(16)
            
            if !message.isUser { Spacer() }
        }
    }
}

#Preview {
    ContentView()
}
