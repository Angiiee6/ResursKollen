//
//  OrderDetailView.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import SwiftUI

/// Shows a view of all details on an order.
struct OrderDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ViewModel()

    @State var order: Order
    @State var newTimeUnit: OrderTimeUnit

    //Used to compare changes to an order to be able to show an alert if the user clicks the back button without saving
    let orderOriginal: Order
    //To be able to build different UI's depending on the current user's status.
    let employmentStatus: EmploymentStatus

    init(order: Order, status: EmploymentStatus) {
        self.order = order
        self.orderOriginal = order
        self.employmentStatus = status
        self.newTimeUnit = OrderTimeUnit(
            time: 0,
            date: Date(),
            user: order.assignedUser ?? UserData()
        )
    }

    //Sheets & alerts
    @State var activeSheet: ActiveSheet?
    @State var activeAlert: ActiveAlert?
    @State var alertPresent: Bool = false

    //Text boxes
    @State var workPerformedExpanded: Bool = false
    @State var descriptionExpanded: Bool = false

    //All possible sheets to show
    enum ActiveSheet: Identifiable {
        ///For entering text about what has been done on an order.
        case workPerformedText
        ///For editing any materials on an order.
        case material
        ///For updating the assigned user on an order (managers only).
        case assignedUser
        ///For showing a list of an order's time units.
        case timeUnits

        var id: Self { self }
    }

    //All possible alerts to show
    enum ActiveAlert {
        case error(Error)
        case exit, orderDone
    }

    var body: some View {
        ZStack {
            // Gradient backgrund
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.11, green: 0.11, blue: 0.15),
                    Color(red: 0.20, green: 0.20, blue: 0.25),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                ScrollView {
                    VStack(spacing: 32) {
                        //MARK: Creation date
                        HStack {
                            Text("Skapad: \(order.creationDate.asYYYYMMDD)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        //MARK: Status
                        StatusPicker(
                            status: employmentStatus,
                            selection: $order.status
                        )

                        //MARK: Assigned user picker
                        //Manager only
                        if employmentStatus == .manager {
                            HStack {
                                Text("Utförare:")
                                    .font(.headline)
                                Spacer()
                                Button(order.assignedUser?.name ?? "Välj") {
                                    activeSheet = .assignedUser
                                }
                            }
                        }

                        //MARK: Customer
                        CustomerDetailCard(customer: order.customer)
                        Divider()

                        //MARK: Description
                        DetailTextBox(
                            isExpanded: $descriptionExpanded,
                            title: "Arbetsbeskrivning:",
                            text: order.description
                        )
                        //MARK: Work performed
                        VStack {
                            DetailTextBox(
                                isExpanded: $workPerformedExpanded,
                                title: "Utfört:",
                                text: order.workPerformed,
                                placeHolderText:
                                    "Lägg till text..."
                            )
                            HStack {
                                Spacer()
                                Button("Ändra/lägg till text") {
                                    activeSheet = .workPerformedText
                                }
                            }
                        }
                        Divider()
                        //MARK: Time consumption
                        VStack(spacing: 24) {
                            HStack {
                                Text("Total tid på order:")
                                    .font(.headline)
                                Spacer()
                                Text(
                                    "\((newTimeUnit.time + order.totalTimeWorked).formattedAsHours) h"
                                )
                                .font(.headline)
                            }
                            if order.assignedUser == nil {
                                Text(
                                    "Lägg till utförare för att kunna lägga till tid."
                                )
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .italic()
                            } else {
                                VStack(spacing: 24) {

                                    HStack {
                                        Text("Lägg till tid:")
                                        Spacer()
                                        Text(newTimeUnit.time.formattedAsHours)
                                        Stepper(
                                            value: $newTimeUnit.time,
                                            in: 0...Double.infinity,
                                            step: 0.5
                                        ) {
                                            Text("h")
                                        }
                                        .frame(maxWidth: 130)
                                    }
                                }

                            }
                            HStack {
                                Spacer()
                                Button("Detaljer") {
                                    activeSheet = .timeUnits
                                }
                            }
                        }

                        //MARK: Material
                        VStack {
                            HStack {
                                Text("Förbrukat material:")
                                    .font(.headline)
                                Spacer()
                            }
                            if order.materialConsumption.isEmpty {
                                Text("Inget material tillagt.")
                                    .font(.callout)
                                    .italic()
                                    .padding()
                            } else {
                                MaterialDetailList(
                                    materials: order.materialConsumption
                                )
                            }
                            HStack {
                                Spacer()
                                Button("Ändra/lägg till material") {
                                    activeSheet = .material
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 34)
                    .padding(.vertical)
                }
                .scrollIndicators(.hidden)
                Spacer()
                //MARK: Summary
                PriceSummaryBox(
                    totalLaborCost: (order.totalLaborCost
                        + (newTimeUnit.time
                            //TODO: Replace with real hourly cost when implemented
                            * 539)),
                    totalMaterialCost: order.totalMaterialCost
                )

                //MARK: Save button
                Button("Spara") {
                    do {
                        if newTimeUnit.time > 0 {
                            order.timeUnits.append(newTimeUnit)
                        }
                        try viewModel.updateOrder(order)
                        dismiss()
                    } catch {
                        activeAlert = .error(error)
                        alertPresent = true
                    }
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
            .navigationBarBackButtonHidden(true)
            .padding(.vertical, 16)
            //MARK: Nav title
            .navigationTitle(order.orderNumber)
        }

        //MARK: onChange
        .onChange(
            of: order.assignedUser,
            { _, newValue in
                guard let newValue = newValue else {
                    newTimeUnit.time = 0
                    return
                }
                newTimeUnit.user = newValue
                print("newTimeUnit = \(String(describing: newTimeUnit))")

            }
        )

        //MARK: Toolbar
        .toolbar {
            //Use a custom back button to be able to show an alert if the user presses the back button without saving.
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    if order != orderOriginal {
                        activeAlert = .exit
                        alertPresent = true
                    } else {
                        dismiss()
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
            //Button to mark an order as done or completed (depending on user's status)
            if orderOriginal.status != .completed {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        "\(employmentStatus == .manager ? "Avsluta": "Utför")"
                    ) {
                        activeAlert = .orderDone
                        alertPresent = true
                    }
                }
            }
        }
        //MARK: Sheets
        .sheet(item: $activeSheet) { activeSheet in
            switch activeSheet {
            case .workPerformedText:
                WorkPerformedTextSheet(workPerformedText: $order.workPerformed)
            case .material:
                MaterialEditSheet(materials: $order.materialConsumption)
            case .assignedUser:
                AssignedUserPickerSheet(selectedUser: $order.assignedUser)
            case .timeUnits:
                TimeUnitListSheet(timeUnits: $order.timeUnits)
                    //Makes sheet cover about 50% of screen
                    .presentationDetents([.medium])
            }

        }
        //MARK: Alerts
        .alert(isPresented: $alertPresent) {
            switch activeAlert {
            case .error(let error):
                //In case of error
                Alert(
                    title: Text("Ett fel uppstod"),
                    message: Text(error.localizedDescription),
                    dismissButton: .default(Text("OK"))
                )
            //When the user presses the back button
            case .exit:
                Alert(
                    title: Text("Avsluta utan att spara?"),
                    primaryButton: .cancel(Text("Nej")),
                    secondaryButton: .destructive(Text("Ja")) {
                        dismiss()
                    }
                )
            //When the user presses the done/complete order button
            case .orderDone:
                Alert(
                    title: Text(
                        "\(employmentStatus == .manager ? "Avsluta" : "Utför") order?"
                    ),
                    primaryButton: .default(Text("Nej")),
                    secondaryButton: .destructive(Text("Ja")) {
                        do {
                            var updatedOrder = order
                            updatedOrder.status =
                                switch employmentStatus {
                                case .manager:
                                    .completed
                                case .employee:
                                    .done
                                }
                            try viewModel.updateOrder(updatedOrder)
                            dismiss()
                        } catch {
                            activeAlert = .error(error)
                        }
                    }
                )
            case nil:
                Alert(title: Text(""))
            }
        }
        .onDisappear {
            activeAlert = nil
        }
    }
}

//MARK: ViewModel
extension OrderDetailView {

    class ViewModel: ObservableObject {
        let firestoreManager = FirestoreManager.shared

        func updateOrder(_ order: Order) throws {
            try firestoreManager.updateOrder(order)
        }
    }

}

//MARK: Preview
#Preview {
    OrderDetailView(order: Order.orderMockUpData, status: .manager)
}
