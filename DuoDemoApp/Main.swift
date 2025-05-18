//
//  DuoDemoAppApp.swift
//  DuoDemoApp
//
//  Created by Matheus Gois on 03/02/2024.
//

import Foundation
import SwiftUI
import FamilyControls

@main
struct Main: App {
	@StateObject private var screenTimeManager = ScreenTimeManager()

    init() {
		Task {
			try? await AuthorizationCenter.shared.requestAuthorization(for: .individual)
		}

        NotificationManager.registerForNotification()
    }

    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.1, *) {
				AppView()
					.environmentObject(screenTimeManager)
					.onOpenURL { url in
                    DeepLinkManager.managerDeepLink(with: url)
                }
            }
        }
    }
}
