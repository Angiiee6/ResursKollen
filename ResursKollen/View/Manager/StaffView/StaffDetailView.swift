import SwiftUI

struct StaffDetailView: View {

    @State private var isEditUser = false
    @State var user: UserData
    @State private var isShowMoreInfo = false
    @StateObject var vm = StaffDetailViewModel()
    let currentUser: UserData

    var body: some View {

        NavigationStack {
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
                    Section(
                        header: Text("Kontaktinformation").foregroundColor(
                            .white
                        )
                    ) {
                        DetailRow(
                            icon: "envelope",
                            label: "E-post",
                            value: user.email,
                            isPhoneNumber: false
                        )
                        DetailRow(
                            icon: "phone",
                            label: "Telefonnummer",
                            value: user.phoneNumber,
                            isPhoneNumber: true
                        )

                    }
                    .listRowBackground(Color.white.opacity(0.2))

                    Section(
                        header: Text("Anställningsinformation").foregroundColor(
                            .white
                        )
                    ) {
                        DetailRow(
                            icon: "person.fill.checkmark",
                            label: "Anställningsform",
                            value: user.detailedInfo.employmentType
                                .employmentTypeSE,
                            isPhoneNumber: false
                        )
                        DetailRow(
                            icon: "number",
                            label: "Anställningsnummer",
                            value: user.employmentNumber,
                            isPhoneNumber: false
                        )
                        DetailRow(
                            icon: "calendar",
                            label: "Anställningsdatum",
                            value: formatDate(user.employmentDate),
                            isPhoneNumber: false
                        )

                    }.listRowBackground(Color.white.opacity(0.2))

                    //NOTE: här har jag lagt till logik för en listan med mer information, @Angie, @Vivanne plocka bort om ni tycker jag kladdat för mycket /Da
                    if currentUser.status == .manager {
                        Section {
                            Button {
                                withAnimation {
                                    isShowMoreInfo.toggle()
                                }
                            } label: {
                                DetailRow(
                                    icon: "list.bullet.rectangle",
                                    label: "Mera information",
                                    value: "",
                                    isPhoneNumber: false
                                )
                            }
                        }.listRowBackground(Color.white.opacity(0.2))

                        if isShowMoreInfo {

                            ShowDetailsView(user: user)

                        }
                    }

                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
        }

        .toolbar {
            if currentUser.status == .manager {
                ToolbarItem(placement: .topBarTrailing) {

                    Button {
                        isEditUser = true
                    } label: {
                        Label("Redigera", systemImage: "pencil")
                            .foregroundColor(.white)
                    }
                }
            }

        }.sheet(isPresented: $isEditUser) {
            EditStaffView(user: $user)
                .presentationDragIndicator(.visible)
        }
        //        .onAppear {
        //            Task {
        //                await vm.loadCurrentUser()
        //            }
        //        }

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
    let isPhoneNumber: Bool
    @State private var showOptions = false
    
    @ObservedObject private var vm = StaffViewViewModel()
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .frame(width: 25)
            Text(label)
                .foregroundColor(.white)
            Spacer()
            if isPhoneNumber {
                Button(action: {
                    showOptions = true
                }) {
                    Text(value)
                        .foregroundColor(.blue)
                }
                .confirmationDialog("Vad vill du göra?", isPresented: $showOptions, titleVisibility: .visible) {
                    Button("Ringa") {
                        callNumber(value)
                    }
                    
                    Button("Skicka SMS") {
                        sendSMS(value)
                    }
                    Button("Avbryt", role: .cancel) {}
                }
            } else {
                Text(value)
                    .foregroundColor(.white)
            }
        }
    }
}
// funktion för att ringa
private func callNumber(_ number: String) {
    let cleaned = number.filter { $0.isNumber }
    if let url = URL(string: "tel://\(cleaned)"),
       UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    } else {
        print(" Kunde inte ringa numret: \(number)")
    }
}

    //  Funktion för att skicka sms
private func sendSMS(_ number: String) {
    let cleaned = number.filter { $0.isNumber }
    if let url = URL(string: "sms:\(cleaned)"),
       UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    } else {
        print(" Kunde inte öppna SMS till: \(number)")
    }
}
#Preview {
    NavigationStack {
        
        StaffDetailView(user: UserData.UserDataMockData as UserData)
        
    }
}

extension StaffDetailView {
    
    class StaffDetailViewModel: ObservableObject {
        //        @Published var currentUser : UserData?

        // Hämta current User
        //        func loadCurrentUser() async {
        //            do {
        //                // Hämta den autentiserade användaren
        //                let authenticatedUser = try AuthenticationManager.shared.getAuthenticatedUser()
        //                let uid = authenticatedUser.uid
        //
        //                // Hämta användardata från Firestore
        //                let userData = try await FirestoreManager.shared.fetchUserData(userId: uid)
        //
        //                // Uppdatera currentUser på huvudtråden
        //                DispatchQueue.main.async {
        //                    self.currentUser = userData
        //                }
        //            } catch {
        //                print("Error getting user: \(error.localizedDescription)")
        //            }
        //        }
        func startPhone() {

        }
    }
}
