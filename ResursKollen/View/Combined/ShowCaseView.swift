//
//  ShowCaseView.swift
//  ResursKollen
//
//  Created by Robin jakobsson on 2025-05-20.
//

import SwiftUI

struct ShowCaseView: View {
    let value : String?
    
    var body: some View {
        
        if let value = value {
            Text(value)
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 100, height: 100)
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()
        } else {
            ProgressView()
        }
    }
}

#Preview {
    ShowCaseView(value: "13H")
}
