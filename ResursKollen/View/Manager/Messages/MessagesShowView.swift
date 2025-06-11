
//
//  Messages.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-27.
//

import SwiftUI

@MainActor
final class MessageShowViewModel: ObservableObject {
    @Published var messages: [Message] = []

    func readMessages() async throws {
        self.messages = try await MessagesManager.shared.readAllmessages()
    }
}

struct MessagesShowView: View {

    @ObservedObject var viewModel = MessageShowViewModel()
    @State private var expandedMessageID: String? = nil
    @State private var isCollapsed = false
   
    
    private var sortedMessages: [Message] {
        viewModel.messages.sorted { $0.date > $1.date }
    }
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Meddelanden och information:")
                    .foregroundStyle(Color.orange)
                    .font(.headline)

                Spacer()

                Button(action: {
                    withAnimation(.easeInOut) {
                        isCollapsed.toggle()
                        expandedMessageID = nil
                    }
                }) {
                    Image(systemName: isCollapsed ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 15)

            if !isCollapsed {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(sortedMessages, id: \.id) { message in
                            let isExpanded = expandedMessageID == message.id

                            VStack(alignment: .leading, spacing: 8) {
                                Text(message.title)
                                    .font(.headline)
                                    .foregroundColor(.white)

                                if isExpanded {
                                    ScrollView {
                                        Text(message.text)
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.8))
                                            .multilineTextAlignment(.leading)
                                    }
                                    .frame(height: 120)
                                } else {
                                    Text(message.text)
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                        .lineLimit(3)
                                        .multilineTextAlignment(.leading)
                                }

                                Text(formattedDate(message.date))
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.6))

                                Text(message.category.MessagesCategorySE)
                                    .font(.caption2)
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .frame(width: isExpanded ? 300 : 200)
                            .background(message.category.color)
                            .cornerRadius(20)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    expandedMessageID = isExpanded ? nil : message.id
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .task {
                    try? await viewModel.readMessages()
                }
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    MessagesShowView()
}

