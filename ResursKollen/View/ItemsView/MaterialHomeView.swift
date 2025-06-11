//
//  MaterialHomeView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-06-02.
//

import SwiftUI

@MainActor
final class MaterialViewModel: ObservableObject {
    
   @Published var materials: [Material] = []
    
   init(){
      Task{
         try? await readAllMaterial()
          print("kommer vi hit? \(materials)")
     }
    }
    func readAllMaterial() async throws {
    
        self.materials = try await  MaterialManager.shared.readMaterialList()
    }
    
    func saveNewMaterialPos(material: Material) async throws{
          try? await MaterialManager.shared.writeNewMaterialPost(material: material)
    }
 
    func deleteMaterialPost(material: Material)async throws{
        try await MaterialManager.shared.deleteMaterialPost(materialPost: material)
    }
    
    func updateMaterial(material: Material)throws{
        try? MaterialManager.shared.updateMaterialPost(material: material)
    }
}


struct MaterialHomeView: View {
    
    @StateObject var viewModel = MaterialViewModel()
    
   
    @State private var searchText = ""
    @State private var isShowAddItem = false
   @State private var  materialToEdit: Material? = nil
    
    
    
    
    var filteredMaterials: [Material] {
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
         //   NavigationStack {
                List {
                    ForEach(filteredMaterials, id: \.id) { material in
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
                                Text("Inköp: \(material.priceIn, specifier: "%.2f") kr")
                                Spacer()
                                Text("Kund: \(material.priceOut, specifier: "%.2f") kr")
                            }
                            .font(.system(.footnote, design: .monospaced))
                            
                            Text("Kategori: \(material.category.rawValue)")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.secondary)
                            Button("Ändra"){
                                materialToEdit = material
                                isShowAddItem = true
                              //  print(materialToEdit)
                            }
                            .font(.caption)
                            .foregroundStyle(Color.red)
                        }
                        .padding(.vertical, 4)
                       
                    }
                    
                }
                .navigationTitle("Material")
                .searchable(text: $searchText, prompt: "Sök material, kategori, pris, enhet")
               
            }
            
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
            }
           
        }
      
    }
    
//}
#Preview {
  //  MaterialHomeView()
}
