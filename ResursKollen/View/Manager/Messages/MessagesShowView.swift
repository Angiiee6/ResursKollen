//
//  Messages.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-27.
//

import SwiftUI

@MainActor
final class MessageShowViewModel: ObservableObject{
    @Published var messages: [Message] = []
    
    func readMessages()async throws  {
        self.messages = try await MessagesManager.shared.readAllmessages()
    }
}

struct MessagesShowView: View {
    
    @ObservedObject var viewModel = MessageShowViewModel()
    
   

    var body: some View {
        VStack(alignment: .leading){
            Text("Meddelanden och information:")
                .foregroundStyle(Color.orange)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16){
                    
                    ForEach(viewModel.messages, id: \.id) { message in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(message.title)
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text(message.text)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .lineLimit(4)
                                .fixedSize(horizontal: false, vertical: false)
                                .padding(.bottom, 16)
                            
                            
                            Text("\(formattedDate(message.date))")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text("\(message.category.MessagesCategorySE)")
                                .font(.caption2)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .frame(width: 300, height: 160)
                        .background(message.category.color)
                        .cornerRadius(20)
                    }
                }
                .padding(8)
            }
            
            .task {
                try? await viewModel.readMessages()
            }
            
        }
        
    }
        

            func formattedDate(_ date: Date) -> String {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                return formatter.string(from: date)
            }
        }


#Preview {
 //   MessagesShowView()
}
