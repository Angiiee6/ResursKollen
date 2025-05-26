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
    @StateObject var viewModel = ViewModel()
    @Binding var selectedUserId: String?
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .error(let error):
                VStack {
                    Text("Kunde inte ladda information om anställda.")
                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundStyle(.red)
                    Button("Försök igen") {
                        Task {
                            await viewModel.fetchAllUsers()
                        }
                    }
                }
            case .hasData((let employees, let managers)):
                List {
                    Section("Utförare") {
                        AssignedUserListItem(user: nil, isSelected: selectedUserId == nil)
                            .onTapGesture {
                                selectedUserId = nil
                                dismiss()
                            }
                        ForEach(employees) { employee in
                            AssignedUserListItem(user: employee, isSelected: selectedUserId == employee.id)
                                .onTapGesture {
                                    selectedUserId = employee.id
                                    dismiss()
                                }
                        }
                    }
                    Section("Arbetsledare") {
                        ForEach(managers) { manager in
                            AssignedUserListItem(user: manager, isSelected: selectedUserId == manager.id)
                                .onTapGesture {
                                    selectedUserId = manager.id
                                    dismiss()
                                }
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchAllUsers()
            }
        }
    }
}


extension AssignedUserPickerSheet {

    class ViewModel: ObservableObject {
        @Published var state: UserDataState = .loading

        enum UserDataState {
            case loading
            case error(Error)
            case hasData((employees: [UserData], managers: [UserData]))
        }

        @MainActor
        func fetchAllUsers() async {
            state = .loading
            do {
                let allUsers = try await FirestoreManager.shared
                    .fetchUserDataCollection()
                state = .hasData(
                    (
                        employees: allUsers.filter { $0.status == .employee },
                        managers: allUsers.filter { $0.status == .manager }
                    )
                )
            } catch {
                state = .error(error)
            }
        }

    }
}

#Preview {
    AssignedUserPickerSheet(
        selectedUserId: .constant(nil)
    )
}
