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
        BaseView {
            VStack {
                Text("Utfört arbete: ")
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $workPerformedText)
                            .frame(height: 200)
                        
                        if workPerformedText.isEmpty {
                            Text("Skriv utfört arbete här...")
                                .foregroundColor(Color(.placeholderText))
                                .padding(.top, 8)
                                .padding(.leading, 5)
                        }
                    }
                    Spacer()
                    Button("Klar") {
                        dismiss()
                    }
            }.scrollContentBackground(.hidden)
                .padding()
            .padding()
            
        }
    }
}

#Preview {
    WorkPerformedTextSheet(workPerformedText: .constant("Texten visas här...."))
}
