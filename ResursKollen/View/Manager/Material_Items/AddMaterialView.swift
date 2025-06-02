//
//  SwiftUIView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-06-02.
//

import SwiftUI

final class MaterialViewModel: ObservableObject {
    
    
    
    func saveNewMaterialPos(material: MaterialList) async throws{
          try? await MaterialManager.shared.writeNewMaterialPost(material: material)
    }
    
}
    struct AddMaterialView: View {
        
        @StateObject var viewModel = MaterialViewModel()
        
        @State var title: String = ""
        @State var description: String = ""
        @State var priceIn: Double = 0.0
        @State var priceOut: Double = 0.0
        @State var tax: Double = 0.0
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
                    
                    Section(header: Text("Moms och enhet")) {
                        TextField("Moms %", value: $tax, formatter: numberFormatter)
                            .keyboardType(.decimalPad)
                        
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
                        if !title.isEmpty{
                            Button("Spara material") {
                                saveMaterialData()
                                clearForm()
                            }
                        }
                    }
                }
                .navigationTitle("Lägg till material")
            }
        }
        
        func saveMaterialData(){
            
            let newMaterial = MaterialList(title: title, description: description, priceIn: priceIn, priceOut: priceOut, unit: unit, category: category)
            
            Task{
                try await viewModel.saveNewMaterialPos(material: newMaterial)
                
             
            }
        }
        
        func clearForm(){
            
            title = ""
            description = ""
            priceIn = 0.0
            priceOut = 0.0
            tax = 0.0
            unit = .st
            category = .miscellaneous
            
        }
        
        
    }

#Preview {
  //  AddMaterialView(viewModel: MaterialViewModel())
}

