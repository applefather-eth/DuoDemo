import SwiftUI
import ActivityKit

@available(iOS 16.1, *)
struct ActivitiesTabView: View {
    @ObservedObject var manager: ActivityManager
    let activitiesView: () -> AnyView
    
    var body: some View {
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