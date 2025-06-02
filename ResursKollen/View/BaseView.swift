//
//  BaseView.swift
//  ResursKollen
//
//  Created by Angelica E on 2025-06-02.
//

import SwiftUI

///BAKGRUND
struct BaseView<Content: View>: View {
    private let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.11, green: 0.11, blue: 0.15),
                        Color(red: 0.20, green: 0.20, blue: 0.25),
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
    }
}

///BAKGRUND FÖR SHEETS
extension View {
    func sheetWithBaseView<Item: Identifiable, Content: View>(
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        self.sheet(item: item, onDismiss: onDismiss) { item in
            BaseView {
                content(item)
            }
        }
    }
}
