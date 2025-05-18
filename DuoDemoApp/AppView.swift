import ActivityKit
import SwiftUI
import SwiftData

@available(iOS 16.1, *)
struct AppView: View {
	@StateObject private var viewModel = ChatViewModel()
    @ObservedObject var manager = ActivityManager()
    @StateObject private var healthKitManager = HealthKitManager()
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
                ChatTabView(viewModel: viewModel)
                    .tag(0)
                
                ActivitiesTabView(manager: manager, activitiesView: {
                    AnyView(activitiesView())
                })
                .tag(1)
                .overlay(
                    VStack {
                        if #available(iOS 16.1, *) {
                            HStack {
                                Image(systemName: "figure.walk")
                                Text("Steps today: \(Int(healthKitManager.stepCount))")
                                    .font(.headline)
                                    .padding(.vertical, 4)
                            }
                            .padding(.top, 8)
                        }
                        Spacer()
                    }
                )
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
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
