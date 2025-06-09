import SwiftUI

struct StaffDetailView: View {
    @ObservedObject var viewModel : StaffViewViewModel
    @State private var isEditUser = false
    let user: UserData
    @State private var isShowMoreInfo = false
    let currentUser: UserData

    var body: some View {

        NavigationStack {
            BaseView {
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
                            isPhoneNumber: false,
                            isEmail: true
                        )
                        DetailRow(
                            icon: "phone",
                            label: "Telefonnummer",
                            value: user.phoneNumber,
                            isPhoneNumber: true
                        )

                    }
                    .listRowBackground(Color.white.opacity(0.1))
                    .listRowSeparatorTint(Color.orange.opacity(0.3))

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

                    }     .listRowBackground(Color.white.opacity(0.1))
                        .listRowSeparatorTint(Color.orange.opacity(0.3))

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
                        }                                                        .listRowBackground(Color.white.opacity(0.1))
                            .listRowSeparatorTint(Color.orange.opacity(0.3))

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
            EditStaffView(viewModel: viewModel, user: user)
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

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    let isPhoneNumber: Bool
    var isEmail: Bool = false
    @State private var showOptions = false
    
    
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
            }
            else if isEmail {
                Button(value) {
                    sendMail(to: value)
                }
            }
            else {
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

private func sendMail(to address: String) {
   let trimmedAddress = address.trimmingCharacters(
       in: .whitespacesAndNewlines
   )
   // Email format validation
   let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
   let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

   guard !trimmedAddress.isEmpty, predicate.evaluate(with: trimmedAddress)
   else {
       print("Invalid email address")
       return
   }
   //Ensure format of special characters like '@' is properly formatted for URL
   let mailto = "mailto:\(trimmedAddress)".addingPercentEncoding(
       withAllowedCharacters: .urlQueryAllowed
   )!
   if let url = URL(string: mailto), UIApplication.shared.canOpenURL(url) {
       UIApplication.shared.open(url)
   } else {
       print("Cannot open mail app")
   }
}

#Preview {
    NavigationStack {
        
        StaffDetailView(viewModel: StaffViewViewModel(), user: UserData.UserDataMockData as UserData, currentUser: UserData.UserDataMockData as UserData)
        
    }
}
