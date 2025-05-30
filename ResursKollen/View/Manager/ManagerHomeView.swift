//
//  ManagerHomeView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import SwiftUI

struct ManagerHomeView: View {
    @ObservedObject var dataProvider: MainDataProvider
    @State private var isLoggedOut = false

    var body: some View {
        NavigationStack {
            NavigationLink(
                destination: ContentView().navigationBarBackButtonHidden(true),
                isActive: $isLoggedOut
            ) {
                EmptyView()
            }.navigationBarBackButtonHidden(true)

            TabView {
                ManagerAllOrdersView(dataProvider: dataProvider)
                    .tabItem {
                        Label(
                            "Aktiva ordrar",
                            systemImage: "list.bullet.clipboard"
                        )
                    }
                ReviewOrdersView(dataProvider: dataProvider)
                    .tabItem {
                        Label(
                            "Utförda ordrar",
                            systemImage: "text.page.badge.magnifyingglass"
                        )
                    }
                SummaryView(dataProvider: dataProvider)
                    .tabItem {
                        Label(
                            "Statistik",
                            systemImage: "waveform.badge.magnifyingglass"
                        )
                    }
                StaffView(currentUser: dataProvider.currentUser)
                    .tabItem {
                        Label("Personal", systemImage: "person.3")
                    }

                NewMessageEditView()
                    .tabItem {
                        Label("Meddlanden", systemImage: "message")
                    }
            }
            //            NavigationStack {
            .tint(Color.orange)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        do {
                            try AuthenticationManager.shared.signOut()
                            isLoggedOut = true
                        } catch {
                            print("Kunde inte logga ut användaren")
                        }
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .tint(.orange)
                    }
                }
            }
        }
    }
}

#Preview {
    ManagerHomeView(dataProvider: MainDataProvider.asPreview())
}
