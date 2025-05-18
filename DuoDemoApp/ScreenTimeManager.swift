//
//  ScreenTimeManager.swift
//  haru
//
//  Created by Youngkwang Lee on 5/7/25.
//

import SwiftUI
import FamilyControls
import DeviceActivity
import ManagedSettings

class ScreenTimeManager: ObservableObject {
    @Published var isAuthorized = false
    
    private let center = AuthorizationCenter.shared
    
    init() {
        // Check initial authorization status
        isAuthorized = center.authorizationStatus == .approved
    }
    
    func requestAuthorization() {
        Task {
            do {
                try await center.requestAuthorization(for: .individual)
                
                // Update UI on main thread
                await MainActor.run {
                    self.isAuthorized = center.authorizationStatus == .approved
                }
            } catch {
                print("Authorization failed: \(error.localizedDescription)")
            }
        }
    }
}
