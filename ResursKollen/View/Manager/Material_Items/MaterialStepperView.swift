//
//  MaterialStepperView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-06-03.
//

import SwiftUI



struct MaterialStepperView: View {
    
    var pickedItem: MaterialList  //vilket material är valt?
   // @Binding var varukorg: Dictionary<String, Varukorg>
    
    @ObservedObject var varukorg: Varukorg
    
    var body: some View {
        
        ZStack {
                   Stepper("", onIncrement: {    //ökar, finns objektet öka med ett annars skapa objektet
                       if let item = varukorg.selectedItem[pickedItem.id] {
                           item.quantity += 1
                           varukorg[pickedItem.id] = item
                       } else {
                           let newItem = Varukorg(quantity: 1,materials: pickedItem)
                           varukorg[pickedItem.id] = newItem
                       }
                   }, onDecrement: {            //minskar, <= 1 tas objekt bort annars öka med 1
                       if let item = varukorg.selectedItem[pickedItem.id] {
                           if item.quantity <= 1 {
                               varukorg.selectedItem[pickedItem.id] = nil
                           } else {
                               item.quantity -= 1
                               varukorg.selectedItem[pickedItem.id] = item
                           }
                       }
                   })
                   .labelsHidden()
                   .scaleEffect(0.50)

                   Text("\(varukorg[pickedItem.id]?.quantity ?? 0)")
               }
           }
       }
      

#Preview {
  //  MaterialStepperView(materialItem: MaterialList.singelSample)
}
