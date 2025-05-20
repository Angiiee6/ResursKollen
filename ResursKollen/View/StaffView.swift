// 19/5 Daniel A
// Skapde en viewModel

import FirebaseAuth
import SwiftUI

struct StaffView: View {

   // @State var user: UserData
    @StateObject private var viewModel = StaffViewViewModel()
    @State private var isAddNewEmployeePresented = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemGray6), Color(.systemGray5),
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).edgesIgnoringSafeArea(.all)
            
            NavigationView {
                
                VStack(alignment: .leading, spacing: 8) {
                    List {
                        HStack {
                            if let user = viewModel.user {
                                VStack(alignment: .leading) {
                                    Text("Namn: \(user.name)")
                                        .font(.headline)
                                    
                                }
                                //Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.orange)
                            } //.listStyle(.insetGrouped)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .navigationTitle("Anställda")
                    
                    
                }
                
            }//.task {
                //try? await viewModel.loadCurrentUser()
            //}
            Button("Läggtill anstäld"){
                isAddNewEmployeePresented = true
            }.sheet(isPresented: $isAddNewEmployeePresented) {
                AddEmployeeView()
                    .presentationDragIndicator(.visible) //dragfliken synlig
                
                    
            }
        }
    }
}

@MainActor
final class StaffViewViewModel: ObservableObject {

    @Published private(set) var user: UserData? = nil

    func loadCurrentUser() async throws {

        let authDataResult = try AuthenticationManager.shared
            .getAuthenticatedUser()
        self.user = try await UsersManager.shared.getUser(
            userId: authDataResult.uid
        )
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
