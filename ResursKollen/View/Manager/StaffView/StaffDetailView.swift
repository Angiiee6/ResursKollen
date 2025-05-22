import SwiftUI

struct StaffDetailView: View {
    
    @State private var isEditUser = false
    @State var user: UserData
    @State private var isShowMoreInfo = false
    
    
    
    var body: some View {
        
        NavigationStack{
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
            
            List {
                Section {
                    HStack {
                        Spacer()
                        VStack(alignment: .center, spacing: 8) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.orange)
                            Text(user.name)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Text(user.employmentNumber)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                    .listRowBackground(Color.clear)
                }
                Section(header: Text("Kontaktinformation").foregroundColor(.white)) {
                    DetailRow(icon: "envelope", label: "E-post", value: user.email)
                    DetailRow(icon: "phone", label: "Telefonnummer", value: user.phoneNumber)
                        .listRowBackground(Color.white)
                }
                
                Section(header: Text("Anställningsinformation").foregroundColor(.white)) {
                    DetailRow(icon: "person.fill.checkmark", label: "Anställningsform", value: user.detailedInfo.employmentType.employmentTypeSE )
                    DetailRow(icon: "number", label: "Anställningsnummer", value: user.employmentNumber)
                    DetailRow(icon: "calendar", label: "Anställningsdatum", value: formatDate(user.employmentDate))
                     .listRowBackground(Color.white)
                }
                
                
                  
//NOTE: här har jag lagt till logik för en listan med mer information, @Angie, @Vivanne plocka bort om ni tycker jag kladdat för mycket /Da
                Section{
                    Button{
                        withAnimation{
                            isShowMoreInfo.toggle()
                        }
                    }label: {
                        DetailRow(icon: "list.bullet.rectangle", label: "Mera information", value: "")
                    }
                }
                
                if isShowMoreInfo{
                    
                        ShowDetailsView(user: user)
                    
                    }
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }.ignoresSafeArea(.all)
    }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                
                Button{
                    isEditUser = true
                }label: {
                    Label("Redigera", systemImage: "pencil")
                        .foregroundColor(.white)
                }
            }
            
        }.sheet(isPresented: $isEditUser) {
            EditStaffView(user: $user)
                .presentationDragIndicator(.visible)
        }
        
        
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "sv_SE")
        return formatter.string(from: date)
    }
}

//Note Jag lyfte ut DetailRow till 
struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .frame(width: 25)
            Text(label)
                .foregroundColor(.black.opacity(0.7))
            Spacer()
            Text(value)
                .foregroundColor(.black.opacity(0.5))
        }
    }
}

#Preview {
    NavigationStack {
        
        StaffDetailView(user: UserData.UserDataMockData as UserData)
       
    }
}
