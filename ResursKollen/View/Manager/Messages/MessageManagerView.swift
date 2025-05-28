//
//  SwiftUIView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-27.
//

import SwiftUI



@MainActor
final class MessagesManagerView: ObservableObject {
   
    @Published var messages: [Message] = []
    
    func readMessages()async throws  {
        self.messages = try await MessagesManager.shared.readAllmessages()
    }
    
    func deleteMessage(message: Message) async throws {
        
        try await MessagesManager.shared.deleteMessages(id: message.id)
        
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
    
    
    @ObservedObject var viewmodel: MessagesManagerView = MessagesManagerView()
    @State private var showingEditor = false
    @State private var editingMessage: Message?
    
    var body: some View {
        NavigationView {
            
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
                            Button("Radera", role: .destructive){
                                Task{
                                    try? await viewmodel.deleteMessage(message: message)
                                }
                            }
                        }
                        .font(.caption)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Meddlandecenter")
            .toolbar{
                Button(action: {
                    editingMessage = nil
                    showingEditor = true
                }) {
                    Label("Nytt meddelande", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingEditor){
                // editor av medd
            }
        }
        .task {
            try? await viewmodel.readMessages()
        }
        
    }
    
    
    /*   @State private var title = ""
     @State private var text = ""
     @State private var category: MessagesCategory = .general
     
     @Environment(\.dismiss) var dismiss
     
     var messageToEdit: Message?
     
     var body: some View {
     NavigationView {
     Form {
     Section(header: Text("Rubrik")) {
     TextField("Ange rubrik", text: $title)
     }
     
     Section(header: Text("Meddelande")) {
     TextEditor(text: $text).frame(height: 150)
     }
     
     Section(header: Text("Kategori")) {
     Picker("Kategori", selection: $category) {
     ForEach(MessagesCategory.allCases, id: \.self) { cat in
     Text(cat.MessagesCategorySE).tag(cat)
     }
     }
     }
     
     Section {
     Button(action: submitMessage) {
     Text(messageToEdit == nil ? "Publicera" : "Uppdatera")
     }
     .disabled(title.isEmpty || text.isEmpty)
     }
     
     if messageToEdit != nil {
     Section {
     Button("Radera", role: .destructive) {
     Task {
     try? await viewmodel.deleteMessage(message: messageToEdit!)
     dismiss()
     }
     }
     }
     }
     }
     .navigationTitle(messageToEdit == nil ? "Nytt Meddelande" : "Redigera Meddelande")
     .onAppear {
     if let msg = messageToEdit {
     title = msg.title
     text = msg.text
     category = msg.category
     }
     }
     }
     }
     
     private func submitMessage() {
     var message = messageToEdit ?? Message(title: "", text: "", category: .general)
     message.title = title
     message.text = text
     message.category = category
     
     Task {
     try? await viewmodel.saveMessage(message: message)
     dismiss()
     }
     }
     }
     
     */
}
#Preview {
    NewMessageEditView()
}
