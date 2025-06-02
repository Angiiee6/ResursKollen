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
    @StateObject var viewModel: ViewModel

    @State var order: Order
    @State var newTimeUnit: OrderTimeUnit

    //let orderOriginal: Order
    //To be able to build different UI's depending on the current user's status.
    let employmentStatus: EmploymentStatus

    init(order: Order, status: EmploymentStatus) {
        self.order = order
        self.employmentStatus = status
        self.newTimeUnit = OrderTimeUnit(
            time: 0,
            date: Date(),
            userId: order.assignedUserId ?? ""
        )
        _viewModel = StateObject(wrappedValue: ViewModel(order: order))
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
        BaseView {
            VStack(spacing: 0) {
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
                                Button(
                                    viewModel.currentUserInfo?.name ?? "Välj"
                                ) {
                                    activeSheet = .assignedUser
                                }
                            }
                            .onAppear {
                                if let userId = order.assignedUserId {
                                    Task {
                                        do {
                                            try await viewModel.fetchUserName(
                                                userId: userId
                                            )
                                        } catch {
                                            activeAlert = .error(error)
                                            alertPresent = true
                                        }
                                    }
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
                        TimeConsumptionView(
                            newTimeUnit: $newTimeUnit,
                            order: $order,
                            activeSheet: $activeSheet
                        )

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
                    Task {
                        do {
                            if newTimeUnit.time > 0 {
                                order.timeUnits.append(newTimeUnit)
                            }
                            try await viewModel.updateOrder(order: order)
                            dismiss()
                        } catch {
                            activeAlert = .error(error)
                            alertPresent = true
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 10)
            }
            .navigationBarBackButtonHidden(true)
            //MARK: Nav title
            .navigationTitle(order.orderNumber)
        }

        //MARK: onChange
        .onChange(
            //Update the local state of assignedUser and newTimeUnit depending on new selected user
            of: viewModel.currentUserInfo?.id,
            { _, newValue in
                guard let existinUserId = newValue else {
                    newTimeUnit.time = 0
                    order.assignedUserId = nil
                    return
                }
                newTimeUnit.userId = existinUserId
                order.assignedUserId = existinUserId
            }
        )

        //MARK: Toolbar
        .toolbar {
            //Use a custom back button to be able to show an alert if the user presses the back button without saving.
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    if order != viewModel.orderOriginal || newTimeUnit.time != 0
                    {
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
            if viewModel.orderOriginal.status != .completed {
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
                AssignedUserPickerSheet(viewModel: viewModel)
            case .timeUnits:
                TimeUnitListSheet(timeUnits: order.timeUnits)
                    //Makes sheet cover only half the screen
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
                        Task {
                            do {
                                if newTimeUnit.time > 0 {
                                    order.timeUnits.append(newTimeUnit)
                                }
                                var updatedOrder = order
                                updatedOrder.status =
                                    switch employmentStatus {
                                    case .manager:
                                        .completed
                                    case .employee:
                                        .done
                                    }
                                try await viewModel.updateOrder(
                                    order: updatedOrder
                                )
                                dismiss()
                            } catch {
                                activeAlert = .error(error)
                            }
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

    @MainActor
    class ViewModel: ObservableObject {
        let firestoreManager = FirestoreManager.shared

        let orderOriginal: Order

        @Published var currentUserInfo: (id: String, name: String)?
        @Published var allUsersDataState: AllUsersDataState = .loading

        private(set) var allUsersNotFetched = true

        init(order: Order) {
            self.orderOriginal = order
        }

        enum AllUsersDataState {
            case loading
            case noData
            case hasData(employees: [UserData], managers: [UserData])
            case error(Error)
        }

        func updateOrder(order: Order) async throws {
            if order.status != .completed && orderOriginal.status == .completed
            {
                try await firestoreManager.moveOrderFromCompletedToActive(
                    order: order
                )
            } else if order.status == .completed
                && orderOriginal.status != .completed
            {
                try await firestoreManager.moveOrderFromActiveToCompleted(
                    order: order
                )
            } else {
                try firestoreManager.updateOrder(order)
            }
        }

        func fetchUserName(userId: String) async throws {
            let user = try await firestoreManager.fetchUserData(userId: userId)
            currentUserInfo = (id: user.id, name: user.name)
        }

        func fetchAllUsers() async {
            allUsersDataState = .loading
            do {
                let allUsers = try await FirestoreManager.shared
                    .fetchUserDataCollection()
                allUsersDataState = .hasData(
                    employees: allUsers.filter { $0.status == .employee },
                    managers: allUsers.filter { $0.status == .manager }
                )
                allUsersNotFetched = false
            } catch {
                allUsersDataState = .error(error)
            }
        }
    }

}

//MARK: Preview
#Preview {
    OrderDetailView(order: Order.orderMockUpData, status: .manager)
}
