//
//  ReportView.swift
//  haru
//
//  Created by Youngkwang Lee on 5/9/25.
//

import SwiftUI

struct ReportsView: View {
    @State private var isLoading = true
    var body: some View {
        ZStack {
            if isLoading {
                Loading(text: "loading...",
                        scale: 1)
            }
            DeviceActivityReporterAdapter().onAppear {
                // Give the DeviceActivityReport some time to load
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        isLoading = false
                    }
            }
        }
    }
}

struct ReportsView_Previews: PreviewProvider {
    static var previews: some View {
        ReportsView()
    }
}
