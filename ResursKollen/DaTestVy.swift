//
//  DaTestVy.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-22.
//

import SwiftUI

struct DaTestVy: View {
    @State private var showEmploymentInfo = false

    var body: some View {

        Section {
            DisclosureGroup("Anställning") {
                Text("Hello world")
            }
        }
    }

}

#Preview {
    DaTestVy()
}
