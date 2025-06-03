//
//  MaterialStepperView.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-06-03.
//

import SwiftUI



struct MaterialStepperView: View {
    
    var pickedItem: MaterialList  //vilket material är valt?
    @Binding var varukorg: Dictionary<String, SelectedMaterial>
    
    var body: some View {
        
        ZStack {
                   Stepper("", onIncrement: {    //ökar, finns objektet öka med ett annars skapa objektet
                       if var item = varukorg[pickedItem.id] {
                           item.quantity += 1
                           varukorg[pickedItem.id] = item
                       } else {
                           let newItem = SelectedMaterial(quantity: 1,materials: pickedItem)
                           varukorg[pickedItem.id] = newItem
                       }
                   }, onDecrement: {            //minskar, <= 1 tas objekt bort annars öka med 1
                       if var item = varukorg[pickedItem.id] {
                           if item.quantity <= 1 {
                               varukorg[pickedItem.id] = nil
                           } else {
                               item.quantity -= 1
                               varukorg[pickedItem.id] = item
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
