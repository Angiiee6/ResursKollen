//
//  SwiftUIView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-27.
//

import SwiftUI



@MainActor
final class MessagesManagerViewModel: ObservableObject {
   
    @Published var messages: [Message] = []
    
    func readMessages()async throws  {
        self.messages = try await MessagesManager.shared.readAllmessages()
    }
    
    func deleteMessage(message: Message) async throws {
        
        try await MessagesManager.shared.deleteMessages(message: message)
        
    }
    
    func saveMessage(message: Message)async throws{
        guard !message.title.isEmpty && !message.text.isEmpty else {
            print("Saknar titel och text")
            return
        }
        
        do {
            try await MessagesManager.shared.writeNewMessage(message: message)
        } catch let error {
            print("Fel vi skrivande av meddallnde \(error)")
        }
        
    }
    
}


struct NewMessageEditView: View {
    
    
    @StateObject var viewmodel: MessagesManagerViewModel = MessagesManagerViewModel()
    @State private var showingEditor = false
    @State private var editingMessage: Message?
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.11, green: 0.11, blue: 0.15),
                    Color(red: 0.20, green: 0.20, blue: 0.25),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            VStack{
                List{
                    ForEach(viewmodel.messages){ message in
                        VStack(alignment: .leading,spacing: 4){
                            Text(message.title)
                                .font(.headline)
                            Text(message.text)
                                .font(.body)
                            Text("Kategori: \(message.category.MessagesCategorySE)")
                                .font(.caption)
                            
                            HStack{
                                Button("Ändra"){
                                    editingMessage = message
                                    showingEditor = true
                                }
                                .buttonStyle(.borderless)
                                
                                Spacer()
                                
                                Button("Radera", role: .destructive){
                                    deleteMessage(message: message)
                                }
                                .buttonStyle(.borderless)
                            }
                            .font(.caption)
                        }
                        .padding(.vertical, 8)
                    }.listRowBackground(Color.white.opacity(0.1))
                        .listRowSeparatorTint(Color.orange.opacity(0.3))
                    
                }
                .scrollContentBackground(.hidden)
                
                Button(action: {
                    editingMessage = nil
                    showingEditor = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Nytt meddlande")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.bottom,20)
                }
                
            }
            .navigationTitle("Meddelanden ")
            .sheet(isPresented: $showingEditor){
                EditMessagesView(viewmodel: viewmodel, messageToEdit:  editingMessage)
                
                
            }
            
            .onAppear{
                Task{
                    
                    try? await viewmodel.readMessages()
                    
                }
            }
        }
        
        
        
    }
    
    
    //Rdera ett meddelande
    func deleteMessage(message: Message){
        Task{
            try? await viewmodel.deleteMessage(message: message)
        }
    }
}
#Preview {
    NewMessageEditView()
}


/*.toolbar{
 Button(action: {
     editingMessage = nil
     showingEditor = true
 }) {
     Label("Nytt meddelande", systemImage: "plus")
 }
}*/
