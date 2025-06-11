//
//  ShowCaseView.swift
//  ResursKollen
//
//  Created by Robin jakobsson on 2025-05-20.
//

import SwiftUI

struct ShowCaseView: View {
    let title: String
    let value: String
    let iconName: String?
    
    //MARK: Body
    var body: some View {
        VStack(spacing: 8) {
            if let iconName = iconName {
                Image(systemName: iconName)
                    .font(.title)
                    .foregroundColor(.accentColor)
            }
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.title2)
                .bold()
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding()
    }
}

#Preview {
    ShowCaseView(title: "hello", value: "13H", iconName: "wrench")
}
