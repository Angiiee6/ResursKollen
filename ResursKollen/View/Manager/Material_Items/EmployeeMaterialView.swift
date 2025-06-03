//
//  MaterialHomeView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-06-02.
//

import SwiftUI

class Varukorg: Identifiable, ObservableObject{
    var quantity: Int = 0
    var materials: MaterialList?
    
    @Published var selectedItem: [Varukorg] = []
    
    init(quantity: Int = 0, materials: MaterialList? = nil, selectedItem: [Varukorg] = []) {
        self.quantity = quantity
        self.materials = materials
        self.selectedItem = selectedItem
    }
    
}

struct EmployeeMaterialView: View {
    
    @ObservedObject var viewModel = MaterialViewModel()
    @StateObject var selectedMaterial = Varukorg()
    
   // @State private var materials: [MaterialList] = MaterialList.sampleData
    @State private var searchText = ""
    @State private var isShowAddItem = false
    @State private var  materialToEdit: MaterialList? = nil
    
  //  @State var selectedItems: Dictionary<String, SelectedMaterial> = [:]
    
    
    
    
    
    var filteredMaterials: [MaterialList] {
        if searchText.isEmpty {
            return viewModel.materials
        } else {
            return viewModel.materials.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.category.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        
        VStack{
            NavigationStack {
                List {
                    ForEach(filteredMaterials) { material in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(material.title)
                                    .font(.system(.body, design: .monospaced))
                                    .bold()
                                Spacer()
                                Text(material.unit.rawValue)
                                    .font(.system(.footnote, design: .monospaced))
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                              // behöver inte visa inköps pris för anställda!  Text("Inköp: \(material.priceIn, specifier: "%.2f") kr")
                                Spacer()
                                Text("Kund: \(material.priceOut, specifier: "%.2f") kr")
                            }
                            .font(.system(.footnote, design: .monospaced))
                            
                            Text("Kategori: \(material.category.rawValue)")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.secondary)
                            
                            MaterialStepperView(pickedItem: material)
                            
                            }
                           
                        }
                        .padding(.vertical, 4)
                       
                    }
                    
                }
                .navigationTitle("Material")
                .searchable(text: $searchText, prompt: "Sök material, kategori, pris, enhet")
               
            }
            
           /*
                Till en början kanske bara chefen som kan lägga til mtrl?
            Button(action: {
                isShowAddItem = true
                materialToEdit = nil
            
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Lägg till material")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.orange)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom,20)
            }.sheet(isPresented: $isShowAddItem) {
                AddMaterialView(viewModel: viewModel, materialToEdit: $materialToEdit )
                    .presentationDragIndicator(.visible)
            } */
            .task{
                
                    try? await viewModel.readAllMaterial()
                        }
        }
      
    }
    

#Preview {
   MaterialHomeView()
}

