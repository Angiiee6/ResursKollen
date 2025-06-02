//
//  SwiftUIView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-06-02.
//

import SwiftUI

final class MaterialViewModel: ObservableObject {
    
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var priceIn: String = " "
    @Published var priceOut: String = " "
    @Published var unit: MaterialUnits = .st
    @Published var category: MaterialCategory = .miscellaneous
    
    
    
    
}


struct AddMaterialView: View {
    
    @StateObject var viewModel = MaterialViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Produktinformation")) {
                    TextField("Produktnamn...", text: $viewModel.title)
                    TextEditor(text: $viewModel.description)
                        .frame(height: 100)
                }

                Section(header: Text("Prisinformation")) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Inköpspris")
                                .font(.caption)
                            TextField("0.00", text: $viewModel.priceIn)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                        }
                        VStack(alignment: .leading) {
                            Text("Pris till kund")
                                .font(.caption)
                            TextField("0.00", text: $viewModel.priceOut)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                }

               Section(header: Text("Enhet")) {
                  
                    Picker("Enhet", selection: $viewModel.unit) {
                        ForEach(MaterialUnits.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                }

                Section(header: Text("Kategori")) {
                    Picker("Kategori", selection: $viewModel.category) {
                        ForEach(MaterialCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }

                Section {
                    Button("Spara material") {
                        // Lägg till spara-funktionalitet här
                    }
                }
            }
            .navigationTitle("Lägg till material")
        }
    }
}
        
#Preview {
    AddMaterialView(viewModel: MaterialViewModel())
}
