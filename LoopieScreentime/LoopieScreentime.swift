//

import DeviceActivity
import SwiftUI

@main
struct haruScreenTimeReport: DeviceActivityReportExtension {
	var body: some DeviceActivityReportScene {
		// Create a report for each DeviceActivityReport.Context that your app supports.
		TotalActivityReport { totalActivity in
			TotalActivityView(deviceActivity: totalActivity)
		}
		// Add more reports here...
	}
}
