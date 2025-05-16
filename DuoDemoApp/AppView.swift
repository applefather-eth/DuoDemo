import ActivityKit
import SwiftUI
import SwiftData

@available(iOS 16.1, *)
struct AppView: View {
	@StateObject private var viewModel = ChatViewModel()
    @ObservedObject var manager = ActivityManager()
    @State private var currentPage = 0

    var body: some View {
        VStack {
            // Tab selector
            HStack {
                Spacer()
                TabButton(title: "Chat", isSelected: currentPage == 0) {
                    withAnimation {
                        currentPage = 0
                    }
                }
                Spacer()
                TabButton(title: "Activities", isSelected: currentPage == 1) {
                    withAnimation {
                        currentPage = 1
                    }
                }
                Spacer()
            }
            .padding(.top)
            
            // Paging ScrollView
            TabView(selection: $currentPage) {
                contentView
                    .tag(0)
                
                menuView
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
    
    // Chat view as the main content
    private var contentView: some View {
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
    
    // Activities management as the menu
    private var menuView: some View {
        NavigationView {
            Form {
                Section {
                    Text("Create an activity to start a live activity").fontWeight(.ultraLight)

                    Button(action: {
                        manager.createActivity()
                        manager.listAllDeliveries()
                    }) {
                        Text("Create Activity")
                    }

                    Button(action: {
                        manager.listAllDeliveries()
                    }) {
                        Text("List All Activities")
                    }

                    Button(action: {
                        manager.endAllActivity()
                        manager.listAllDeliveries()
                    }) {
                        Text("End All Activites")
                    }
                }
                if !manager.activities.isEmpty {
                    Section {
                        Text("Live Activities")

                        activitiesView()
                    }
                }
            }
            .navigationTitle("DuoDemo!")
        }
    }
}

// MARK: - List

@available(iOS 16.1, *)
extension AppView {

    func activitiesView() -> some View {
        ScrollView {
            ForEach(manager.activities, id: \.id) { activity in
                activityView(activity)
            }
        }
    }

    func activityView(_ activity: Activity<DuoDemoAppAttributes>) -> some View {

        return HStack(alignment: .center) {
            Text("\(activity.contentState.progressString)% -")
            Text(activity.contentState.initialTime, style: .timer)
            Text("update")
                .font(.headline)
                .foregroundColor(.green)
                .onTapGesture {
                    manager.update(activity: activity)
                    manager.listAllDeliveries()
                }
            Text("end")
                .font(.headline)
                .foregroundColor(.red)
                .onTapGesture {
                    manager.end(activity: activity)
                    manager.listAllDeliveries()
                }
        }.padding(.vertical)
    }
}

// MARK: - Components

// Custom tab button
private struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .fontWeight(isSelected ? .bold : .regular)
                    .foregroundColor(isSelected ? .primary : .secondary)
                
                // Indicator line
                Rectangle()
                    .frame(height: 3)
                    .foregroundColor(isSelected ? Color("action") : Color.clear)
                    .cornerRadius(1.5)
            }
        }
        .padding(.horizontal)
    }
}
