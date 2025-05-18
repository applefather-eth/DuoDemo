//

import SwiftUI


struct TotalActivityView: View {
	
	var deviceActivity: DeviceActivity
	
	var body: some View {
		ActivitiesView(activities: deviceActivity)
	}
	
}
