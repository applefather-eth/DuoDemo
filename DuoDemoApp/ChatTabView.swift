import SwiftUI

@available(iOS 16.1, *)
struct ChatTabView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        VStack {
            // App header
            HStack {
                Text("Petie")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding()
            
            // Message list
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                }
                .onChange(of: viewModel.messages.count) { _ in
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color(.white))
            
            // Input area
            VStack {
                if viewModel.isProcessing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.vertical, 10)
                }
                
                HStack {
                    // Text input field
                    TextField("Type a message...", text: $viewModel.inputMessage)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                        .onSubmit {
                            viewModel.sendMessage()
                        }
                    
                    // Send button
                    Button(action: {
                        viewModel.sendMessage()
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(Color("action"))
                    }
                    .disabled(viewModel.inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isProcessing)
                    
                    // Voice input button
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .background(Color.white)
            .cornerRadius(10)
        }
    }
} 