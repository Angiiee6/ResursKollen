// 19/5 Daniel A
// Skapde en viewModel

import FirebaseAuth
import SwiftUI

struct StaffView: View {

   // @State var user: UserData
    @StateObject private var viewModel = StaffViewViewModel()
    @State private var isAddNewEmployeePresented = false

    var body: some View {
            NavigationView {
                VStack(alignment: .leading, spacing: 16) {
                    List {
                        Section(header: Text("Anställda")) {
                            ForEach(viewModel.user, id: \.id) { user in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Namn: \(user.name)")
                                        .font(.headline)
                                    Text("Telefonnummer: \(user.phoneNumber)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("Anställningsform: \(user.status)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("Anställningsnummer: \(user.employmentNumber)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .navigationTitle("Anställda")
                    
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
                    }
                    .sheet(isPresented: $isAddNewEmployeePresented) {
                        AddEmployeeView()
                            .presentationDragIndicator(.visible)
                    }
                }.onAppear{
                    Task{ try? await viewModel.loadUsers() }
                }
            }
        }

}

@MainActor
final class StaffViewViewModel: ObservableObject {

    @Published private(set) var user: [UserData] = []

    func loadUsers() async throws {
        
        self.user = try await UsersManager.shared.getAllUser()
       
    }

}

#Preview {
    NavigationStack{
        StaffView()
    }
}
/*#Preview {
    StaffView(
        user: UserData(
            id: "1",
            status: .employee,
            name: "Vivianne och Angie",
            employmentDate: Date(),
            employmentNumber: "EMP123",
            phoneNumber: "0701234567"
        )
    )
} */
