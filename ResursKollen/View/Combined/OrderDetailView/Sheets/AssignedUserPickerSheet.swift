//
//  AssignedUserPicker.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-24.
//

import SwiftUI

/// Shows a list of registered users, used for updating an orders' `assignedUser`.
struct AssignedUserPickerSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: OrderDetailView.ViewModel

    var body: some View {
        VStack {
            switch viewModel.allUsersDataState {
            case .loading:
                ProgressView()
            case .noData:
                Text("Inga registrerade användare hittades")
            case .hasData(let employees, let managers):
                List {
                    //MARK: Employees
                    Section("Utförare") {
                        AssignedUserListItem(
                            user: nil,
                            isSelected: viewModel.currentUserInfo == nil
                        )
                        .onTapGesture {
                            viewModel.currentUserInfo = nil
                            dismiss()
                        }
                        ForEach(employees) { employee in
                            AssignedUserListItem(
                                user: employee,
                                isSelected: viewModel.currentUserInfo?.id
                                    == employee.id
                            )
                            .onTapGesture {
                                viewModel.currentUserInfo = (
                                    id: employee.id, name: employee.name
                                )
                                dismiss()
                            }
                        }
                    }
                    //MARK: Managers
                    Section("Arbetsledare") {
                        ForEach(managers) { manager in
                            AssignedUserListItem(
                                user: manager,
                                isSelected: viewModel.currentUserInfo?.id
                                    == manager.id
                            )
                            .onTapGesture {
                                viewModel.currentUserInfo = (
                                    id: manager.id, name: manager.name
                                )
                                dismiss()
                            }
                        }
                    }
                }.scrollContentBackground(.hidden)
            case .error(let error):
                VStack {
                    Text("Ett fel uppstod")
                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundStyle(.red)
                    Button("Försök igen") {
                        Task {
                            await viewModel.fetchAllUsers()
                        }
                    }
                }
            }
        }
        .onAppear {
            if viewModel.allUsersNotFetched {
                Task {
                    await viewModel.fetchAllUsers()
                }
            }
        }
    }
}
