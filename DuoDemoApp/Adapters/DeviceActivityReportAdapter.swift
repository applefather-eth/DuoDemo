//
//  DeviceActivityReportAdapter.swift
//  DeviceActivityApp
//
//  Created by Youngkwang Lee on 5/9/25.
//

import SwiftUI
import DeviceActivity

struct DeviceActivityReporterAdapter: View {
    
    @State private var context: DeviceActivityReport.Context = .init(rawValue: "Activities")
    @State private var filter = DeviceActivityFilter(
        segment: .daily(
            during: Calendar.current.dateInterval(
                of: .day, for: .now
            )!
        ),
        users: .all,
        devices: .init([.iPhone])
    )
    
    var body: some View {
        ZStack {
            DeviceActivityReport(context, filter: filter)
        }
    }    
}
