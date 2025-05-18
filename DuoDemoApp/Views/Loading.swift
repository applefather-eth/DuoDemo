//
//  Loading.swift
//  DeviceActivityApp
//
//  Created by Youngkwang Lee on 5/9/25.
//

import SwiftUI

struct Loading: View {
    
    private let text: String
    private let scale: Double
    
    init(text: String,
         scale: Double = 1.5) {
        self.text = text
        self.scale = scale
    }
    
    var body: some View {
        VStack {
            ProgressView {
                Text(text)
            }
            .foregroundColor(.white)
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .font(.title3)
            .controlSize(.large)
            .scaleEffect(scale)
            .foregroundColor(.black)
        }
    }
}
