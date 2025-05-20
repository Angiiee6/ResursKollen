import SwiftUI

struct StaffDetailView: View {
    let user: UserData
    
    var body: some View {
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
                    DetailRow(icon: "person.fill.checkmark", label: "Anställningsform", value: user.status.nameSE)
                    DetailRow(icon: "number", label: "Anställningsnummer", value: user.employmentNumber)
                    DetailRow(icon: "calendar", label: "Anställningsdatum", value: formatDate(user.employmentDate))
                    DetailRow(icon: "calendar.badge.plus", label: "Skapad datum", value: formatDate(user.createdDate))
                        .listRowBackground(Color.white)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
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
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    NavigationStack {
        StaffDetailView(user: UserData(
            id: "1",
            status: .employee,
            name: "Vivianne och Angie",
            email: "test@example.com",
            employmentDate: Date(),
            employmentNumber: "EMP123",
            phoneNumber: "0701234567",
//            createdDate: Date()
        ))
    }
}
