//
//  SwiftUIView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-27.
//

import SwiftUI

struct MessagesView: View {
    @State private var messageText = ""
    @State private var messages: [String] = []
    
    var body: some View {
        VStack {
            List(messages, id: \.self) { message in
                Text(message)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack {
                TextField("Skriv meddelande...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    // sendMessage()
                }) {
                    Text("Skicka")
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(messageText.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(messageText.isEmpty)
            }
            .padding()
        }
        .navigationTitle("Meddelanden till anställda")
    }
    
}
#Preview {
    MessagesView()
}
