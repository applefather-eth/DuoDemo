//
//  List.swift
//  Monitor
//
//  Created by Youngkwang Lee on 5/9/25.
//

import SwiftUI

struct ListItem: View {
    
    private let app: AppReport
    
    init(app: AppReport) {
        self.app = app
    }
    
    var body: some View {
        HStack {
            
            VStack {
                Text(app.name)
            }
            
            Spacer()
            Spacer()
            Text(app.duration.toString().replacingOccurrences(of: ":", with: "h"))
        }
    }
}

struct List_Previews: PreviewProvider {
    static var previews: some View {
        ListItem(app: AppReport(id: "1",
                                name: "Twitter",
                                duration: .zero))
    }
}
