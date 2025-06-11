//
//  EditMessagesView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-28.
//

import Foundation
import SwiftUI

/*
 View for editing staff messages
 */
struct EditMessagesView: View {
    
    @StateObject var viewmodel: MessagesManagerViewModel
   
    @State var messageToEdit: Message?
    @State var title: String = ""
    @State var text: String = ""
    @State var category: MessagesCategory = .general
    

   @Environment(\.dismiss) var dismiss
    //MARK: Body
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
               
               //shows an message, enable delete button
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
    //MARK: SubmitMessage
//Submits new message, merge to old message if updated
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
