

import FirebaseAuth
import SwiftUI

struct StaffView: View {
    @StateObject private var viewModel = StaffViewViewModel()
    @State private var isAddNewEmployeePresented = false
    
   // Sorterar namnen på chefer
    private var managers: [UserData] {
        viewModel.user.filter { $0.status == .manager }.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    // Sorterar namnen på anställda
    private var employees: [UserData] {
        viewModel.user.filter { $0.status == .employee }.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.11, green: 0.11, blue: 0.15),
                        Color(red: 0.20, green: 0.20, blue: 0.25),
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 16) {
                    List {
                        // Avdelning för chefer
                        if !managers.isEmpty {
                            Section(header: Text(EmploymentStatus.manager.nameSE.capitalized).foregroundColor(.orange)) {
                                ForEach(managers, id: \.id) { user in
                                    NavigationLink {
                                        StaffDetailView(user: user)
                                    } label: {
                                        StaffRowView(user: user)
                                    }
                                    .listRowBackground(Color.white.opacity(0.2))
                                }
                            }
                        }
                        
                        // Avdelning för anställda
                        Section(header: Text(EmploymentStatus.employee.nameSE.capitalized).foregroundColor(.orange)) {
                            ForEach(employees, id: \.id) { user in
                                NavigationLink {
                                    StaffDetailView(user: user)
                                } label: {
                                    StaffRowView(user: user)
                                }
                                .listRowBackground(Color.white.opacity(0.2))
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    
                    if viewModel.currentUser?.status == .manager {
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
                            .padding(20)
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
                    try? await viewModel.loadUsers()
                    try? await viewModel.loadCurrentUser()
                }
            }
        }
    }
}

struct StaffRowView: View {
    let user: UserData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(user.name)
                .font(.headline)
                .foregroundColor(.white)

        }
        .padding(.vertical, 4)
    }
}

@MainActor
final class StaffViewViewModel: ObservableObject {
    @Published private(set) var user: [UserData] = []
    @Published var currentUser : UserData?

    func loadUsers() async throws {
        self.user = try await UsersManager.shared.getAllUser()
    }
    
    func updateStaff(user: UserData) throws {
        try? UsersManager.shared.updateUser(user: user)
    }
    // Kopierade denna från staffdetailView viewmodeln, borde göra en som man kan använda överallt
    func loadCurrentUser() async {
            do {
                // Hämta den autentiserade användaren
                let authenticatedUser = try AuthenticationManager.shared.getAuthenticatedUser()
                let uid = authenticatedUser.uid
                
                // Hämta användardata från Firestore
                let userData = try await FirestoreManager.shared.fetchUserData(userId: uid)
                
                // Uppdatera currentUser på huvudtråden
                DispatchQueue.main.async {
                    self.currentUser = userData
                }
            } catch {
                print("Error getting user: \(error.localizedDescription)")
            }
        }
    
}

#Preview {
    NavigationStack {
        StaffView()
    }
}
