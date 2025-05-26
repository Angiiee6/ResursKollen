//
//  TextBox.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-20.
//

import SwiftUI

///Expandable box for showing text information. Becomes scrollable when expanded.
struct DetailTextBox: View {
    @Binding var isExpanded: Bool
    let title: String
    let text: String
    var placeHolderText: String?
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            }
            Group {
                if isExpanded {
                    ScrollView {
                        Text(text.isEmpty ? placeHolderText ?? "" : text)

                    }
                } else {
                    Text(text.isEmpty ? placeHolderText ?? "" : text)
                }
            }
            .italic(text.isEmpty)
            .foregroundStyle(.opacity(text.isEmpty ? 0.5 : 1))
            .frame(
                maxWidth: .infinity,
                maxHeight: isExpanded ? 400 : 135,
                alignment: .leading
            )
            .padding(8)
            .background(.secondary.opacity(0.35))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .onTapGesture {
                isExpanded.toggle()
            }
        }
    }
}
