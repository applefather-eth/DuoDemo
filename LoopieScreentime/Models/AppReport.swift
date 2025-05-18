//
//  AppReport.swift
//  Monitor
//
//  Created by Youngkwang Lee on 5/9/25.
//


import Foundation

struct AppReport: Identifiable {
    
    var id: String
    var name: String
    var duration: TimeInterval
    
}

extension TimeInterval {
    
    func toString() -> String {
        let time = NSInteger(self)
        
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d",hours,minutes)
    }
    
}
