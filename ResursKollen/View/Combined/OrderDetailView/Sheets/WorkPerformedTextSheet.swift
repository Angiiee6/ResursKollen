//
//  WorkPerformedTextSheet.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-26.
//

import SwiftUI

struct WorkPerformedTextSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var workPerformedText: String
    var body: some View {
        VStack {
            Text("Utfört arbete: ")
            TextEditor(text: $workPerformedText)
            Spacer()
            Button("Klar") {
                dismiss()
            }
        }
        .padding()
    }
}

#Preview {
    WorkPerformedTextSheet(workPerformedText: .constant("Texten visas här...."))
}
