//
//  MaterialHomeView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-06-02.
//

import SwiftUI




struct MaterialHomeView: View {
    
    @State private var materials: [MaterialList] = MaterialList.sampleData
    @State private var searchText = ""
    @State private var isShowAddItem = false
    
    var filteredMaterials: [MaterialList] {
        if searchText.isEmpty {
            return materials
        } else {
            return materials.filter {
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
                                Text("Inköp: \(material.priceIn, specifier: "%.2f") kr")
                                Spacer()
                                Text("Kund: \(material.priceOut, specifier: "%.2f") kr")
                            }
                            .font(.system(.footnote, design: .monospaced))
                            
                            Text("Kategori: \(material.category.rawValue)")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                       
                    }
                    .onDelete(perform: deletePost)
                }
                .navigationTitle("Material")
                .searchable(text: $searchText, prompt: "Sök material, kategori, pris, enhet")
               
            }
            
            Button(action: {
                isShowAddItem = true
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
                AddMaterialView()
                    .presentationDragIndicator(.visible)
            }
        }
    }
    private func deletePost(at indexSet: IndexSet){
        materials.remove(atOffsets: indexSet)
        
        //TODO Lägg till så att det raderas i från databasen också
        
        print(indexSet)
    }
    
}
#Preview {
  //  MaterialHomeView()
}
