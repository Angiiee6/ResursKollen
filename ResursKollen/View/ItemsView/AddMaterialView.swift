//
//  SwiftUIView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-06-02.
//

import SwiftUI


    struct AddMaterialView: View {
        
        
        @ObservedObject var viewModel: MaterialViewModel
        @Environment(\.dismiss) var dismiss
        
        @Binding var materialToEdit: Material?
        
        @State var title: String = ""
        @State var description: String = ""
        @State var priceIn: Double = 0.0
        @State var priceOut: Double = 0.0
        @State var unit: MaterialUnits = .st
        @State var category: MaterialCategory = .miscellaneous
        
        
        let numberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            formatter.locale = Locale(identifier: "sv_SE")
            return formatter
        }()
        
        var body: some View {
            NavigationStack {
                Form {
                    Section(header: Text("Produktinformation")) {
                        TextField("Produktnamn...", text: $title)
                        TextEditor(text: $description)
                            .frame(height: 100)
                    }
                    
                    Section(header: Text("Prisinformation")) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Inköpspris exkl. moms")
                                    .font(.caption)
                                TextField("0.00", value: $priceIn, formatter: numberFormatter)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(.roundedBorder)
                            }
                            VStack(alignment: .leading) {
                                Text("Pris till kund")
                                    .font(.caption)
                                TextField("0.00", value: $priceOut, formatter: numberFormatter)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                    }
                    
                    Section(header: Text("Enhet")) {
                        Picker("Enhet", selection: $unit) {
                            ForEach(MaterialUnits.allCases, id: \.self) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }
                    }
                    
                    Section(header: Text("Kategori")) {
                        Picker("Kategori", selection: $category) {
                            ForEach(MaterialCategory.allCases, id: \.self) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                    }
                    
                    Section {
                        HStack{
                            
                            Button{
                                saveMaterialData()
                            }label: {
                                Text("Spara")
                            }
                            
                         /*       Button("Spara") {
                                    if !title.isEmpty{
                                       saveMaterialData()
                                    
                                    }
                            } */
                            
                            Spacer()
                            
                            if materialToEdit != nil{
                                Button("RADERA"){
                                    if let materialToDelete = materialToEdit {
                                        Task{
                                           try? await viewModel.deleteMaterialPost(material: materialToDelete)
                                            print("kommer vi hit?")
                                           
                                        }
                                        }
                                }
                            }
                            
                            Spacer()
                            Button("Avbryt", role: .destructive){
                                materialToEdit = nil
                            dismiss()
                            }
                        }
                    }
                }
                .toolbar{
                    ToolbarItem(placement: .principal){
                     //   .navigationTitle(materialToEdit == nil ? "Lägg till ny artikel" : "Redigera Artikel")
                       Text(materialToEdit == nil ? "Lägg till ny artikel" : "Redigera Artikel")
                    }
                }
                .onAppear{
                    if let material = materialToEdit {
                        title = material.title
                        description = material.description
                        priceIn = material.priceIn
                        priceOut = material.priceOut
                        unit = material.unit
                        category = material.category
                        
                    }
                   
                }
            }
        }
        
        func saveMaterialData(){
            print("saveMaterialData")
            let newMaterial = Material(title: title, priceOut: priceOut, priceIn: priceIn, description: description, unit: unit, category: category)
            
            Task{
                if materialToEdit == nil {
                    try await viewModel.saveNewMaterialPos(material: newMaterial)
                    clearForm()
                    dismiss()
                }else {
                    print("Redigeringsläge")
                    dismiss()
                }
            }
           
        }
        
        func clearForm(){
            
            title = ""
            description = ""
            priceIn = 0.0
            priceOut = 0.0
            unit = .st
            category = .miscellaneous
            
        }
        
        
    }

#Preview {
  //  AddMaterialView(viewModel: MaterialViewModel())
}

