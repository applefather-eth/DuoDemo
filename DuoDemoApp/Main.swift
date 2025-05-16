//
//  DuoDemoAppApp.swift
//  DuoDemoApp
//
//  Created by Matheus Gois on 03/02/2024.
//

import Foundation
import SwiftUI

@main
struct Main: App {

    init() {
        NotificationManager.registerForNotification()
    }

    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.1, *) {
				AppView()
					.onOpenURL { url in
                    DeepLinkManager.managerDeepLink(with: url)
                }
            }
        }
    }
}
