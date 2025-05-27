//
//  SwiftUIView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-27.
//

import SwiftUI



@MainActor
final class MessageViewViewModel: ObservableObject {
   
    
    func saveMessage(message: Message)async throws{
        guard !message.title.isEmpty && !message.text.isEmpty else {
            print("Saknar titel och text")
            return
        }
        
        do {
            try await MessagesManger.shared.writeNewMessage(message: message)
        } catch let error {
            print("Fel vi skrivande av meddallnde \(error)")
        }
        
    }
    
}


struct MessagesView: View {
    
    
    @ObservedObject var viewmodel: MessageViewViewModel = MessageViewViewModel()
    @State private var title = ""
    @State private var text = ""
    @State private var category: MessagesCategory = .general
       
       var body: some View {
           NavigationView {
               Form {
                   Section(header: Text("Rubrik")) {
                       TextField("Ange rubrik", text: $title)
                   }
                   
                   Section(header: Text("Meddelande")) {
                       TextEditor(text: $text)
                           .frame(height: 150)
                   }
                   
                   Section(header: Text("Kategori")) {
                       Picker("Kategori", selection: $category) {
                           ForEach(MessagesCategory.allCases, id: \.self) { category in
                               Text(category.MessagesCategorySE)
                                   .tag(category)
                           }
                       }
                   }
                   
                   Section {
                       Button(action: submitMessage) {
                           Text("Skicka meddelande")
                               .frame(maxWidth: .infinity, alignment: .center)
                               .foregroundColor(.white)
                               .padding()
                               .cornerRadius(10)
                       }
                       .disabled(title.isEmpty || text.isEmpty)
                   }
               }
               .navigationTitle("Nytt Meddelande")
           }
       }

       private func submitMessage() {
           let newMessage = Message(
            title: title,
            text: text,
           category: category)
           
           Task{
               try? await  viewmodel.saveMessage(message: newMessage)
               
           }
          
           print("Meddelande skickat:", newMessage)
           
           // Nollställ formuläret
          title = ""
         text = ""
           category = .general
       }
   }
    

#Preview {
   // MessagesView()
}
