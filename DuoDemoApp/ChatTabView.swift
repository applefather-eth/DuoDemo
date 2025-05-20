import SwiftUI

@available(iOS 16.1, *)
struct ChatTabView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    // State variable to show image picker
    @State private var showImagePicker = false
    // State variable to hold the selected image
    @State private var selectedImage: UIImage? = nil
    
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
                if let image = selectedImage {
                    // Preview the selected image
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 150)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
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
                    
                    // Take Photo button
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Image(systemName: "camera")
                            .font(.system(size: 30))
                            .foregroundColor(Color("action"))
                    }
                    
                    // Voice input button
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .background(Color.white)
            .cornerRadius(10)
        }
        // Present the image picker sheet
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
        }
    }
} 