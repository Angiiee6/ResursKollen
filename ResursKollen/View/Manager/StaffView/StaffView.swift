

import FirebaseAuth
import SwiftUI

/*
    View that dispalys all staff / employess in a list
*/
struct StaffView: View {
    @StateObject private var viewModel = StaffViewViewModel()
    @State private var isAddNewEmployeePresented = false
    @State private var detailViewPresent = false
    let currentUser: UserData
    
    
   // Sort list for managers
    private var managers: [UserData] {
        viewModel.users.filter { $0.status == .manager }.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    // Sort employess
    private var employees: [UserData] {
        viewModel.users.filter { $0.status == .employee }.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    var body: some View {
        NavigationView {
            BaseView {
                VStack(alignment: .leading, spacing: 16) {
                    List {
                        // Top view managers
                        if !managers.isEmpty {
                            Section(header: Text(EmploymentStatus.manager.nameSE.capitalized).foregroundColor(.orange)) {
                                ForEach(managers, id: \.id) { user in
//                                    NavigationLink {
//                                        
//                                        StaffDetailView(viewModel: viewModel, currentUser: currentUser)
//                                    } label: {
//                                        StaffRowView(userName: user.name)
//                                    }
//                                    .onAppear {
//                                        viewModel.selectedUser = user
//                                    }
                                    StaffRowView(userName: user.name)
                                        .onTapGesture {
                                            viewModel.selectedUser = user
                                            detailViewPresent = true
                                        }
                                    .listRowBackground(Color.white.opacity(0.1))
                                    .listRowSeparatorTint(Color.orange.opacity(0.3))
                                }
                            }
                        }
                        
                        // Section for employee
                        Section(header: Text(EmploymentStatus.employee.nameSE.capitalized).foregroundColor(.orange)) {
                            ForEach(employees, id: \.id) { user in
//                                NavigationLink {
//                                    StaffDetailView(viewModel: viewModel, currentUser: currentUser)
//                                } label: {
//                                    StaffRowView(userName: user.name)
//                                }
//                                .onAppear {
//                                    viewModel.selectedUser = user
//                                }
                                StaffRowView(userName: user.name)
                                    .onTapGesture {
                                        viewModel.selectedUser = user
                                        detailViewPresent = true
                                    }
                                .listRowBackground(Color.white.opacity(0.1))
                                .listRowSeparatorTint(Color.orange.opacity(0.3))
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    
                    
                    // If user is in manger position, enable button to add employees
                    if currentUser.status == .manager {
                        Button(action: {
                            isAddNewEmployeePresented = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Lägg till anställd")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .padding(.bottom,20)
                        }
                    
                        .sheet(isPresented: $isAddNewEmployeePresented) {
                            AddEmployeeView()
                                .presentationDragIndicator(.visible)
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    //try? await viewModel.loadUsers()
//                    try? await viewModel.loadCurrentUser()
                }
            }
            .navigationDestination(isPresented: $detailViewPresent) {
                StaffDetailView(viewModel: viewModel, currentUser: currentUser)
            }
        }
    }
}

struct StaffRowView: View {
    let userName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(userName)
                .font(.headline)
                .foregroundColor(.white)

        }
        .padding(.vertical, 4)
    }
}

@MainActor
final class StaffViewViewModel: ObservableObject {
    @Published private(set) var users: [UserData] = []
    @Published var selectedUser: UserData = UserData()

    func loadUsers() async throws {
        self.users = try await UsersManager.shared.getAllUser()
    }
    init() {
        listenToUsers()
    }
    
    func updateStaff(user: UserData) async throws {
        try await UsersManager.shared.updateUser(user: user)
    }
    
    func listenToUsers() {
        UsersManager.shared.listenToUserChanges { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self?.users = users
                case .failure(let error):
                    print("Error")
                }
            }
        }
    }
    
}

#Preview {
    NavigationStack {
        StaffView(currentUser: UserData(name: "Test user"))
    }
}
