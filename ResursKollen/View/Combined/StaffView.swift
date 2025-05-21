import FirebaseAuth
import SwiftUI

struct StaffView: View {
    @StateObject private var viewModel = StaffViewViewModel()
    @State private var isAddNewEmployeePresented = false

    var body: some View {
        NavigationView {
            ZStack {
                // Bakgrund
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
                        Section(header: Text("").foregroundColor(.white)) {
                            ForEach(viewModel.user, id: \.id) { user in
                                NavigationLink {
                                    StaffDetailView(user: user)
                                } label: {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(user.name)
                                            .font(.headline)
                                            .foregroundColor(.black)
//                                        Text(user.phoneNumber)
//                                            .font(.subheadline)
//                                            .foregroundColor(.gray)
                                        Text(user.status.nameSE)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.vertical, 4)
                                }
                                .listRowBackground(Color.white)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .navigationTitle("Anställda")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    
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
                }
            }
            .onAppear {
                Task { try? await viewModel.loadUsers() }
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
    NavigationStack {
        StaffView()
    }
}
