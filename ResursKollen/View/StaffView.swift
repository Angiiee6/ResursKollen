// 19/5 Daniel A
// Skapde en viewModel

import SwiftUI

struct StaffView: View {
    
    @State var user: UserData
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(.systemGray6), Color(.systemGray5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).edgesIgnoringSafeArea(.all)

            NavigationView {
                
                VStack(alignment: .leading, spacing: 8) {
                    List {
                        HStack {
                            
                                VStack(alignment: .leading) {
                                    Text("\(user.name)")
                                        .font(.headline)
                                    
                                    Text("\(user.phoneNumber)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.orange)
                            }.listStyle(.insetGrouped)
                        }
                    .listStyle(.insetGrouped)
                    .navigationTitle("Anställda")
                }

                    
        
            }
        }
    }
}



#Preview {
    StaffView(
        user: UserData(id: "1", status: .employee, name: "Vivianne och Angie", employmentDate: Date(), employmentNumber: "EMP123", phoneNumber: "0701234567"))
}
