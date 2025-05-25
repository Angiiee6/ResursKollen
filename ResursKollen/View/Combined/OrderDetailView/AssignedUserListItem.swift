//
//  AssignedUserListItem.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-25.
//

import SwiftUI

///A single user's information.
struct AssignedUserListItem: View {
    let user: UserData?
    let isSelected: Bool
    var body: some View {
        HStack {
            Text(user?.name ?? "Ingen")
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
            }

        }
    }
}

#Preview {
    AssignedUserListItem(user: UserData(name: "Joline"), isSelected: true)
}
