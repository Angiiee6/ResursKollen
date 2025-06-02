//
//  Customer.swift
//  ResursKollen
//
//  Created by Magnus Freidenfelt on 2025-05-16.
//

import Foundation
import MapKit
import CoreLocation



struct Customer: Codable, Identifiable {
    var id: String = ""
    var name: String
    var phoneNumber: String
//    var orders: [Order]
    var streetName: String
    var city: String
    var postalCode: String
    var emailAddress: String
    var customerNumber = UUID()
    
    var fullAddress: String {
        "\(streetName), \(postalCode) \(city)"
    }
}



extension Customer {
    func openInMaps() {
        let fullAddress = "\(streetName), \(postalCode) \(city)"
        
        #if targetEnvironment(simulator)
        // Visa koordinater istället för att öppna kartor
        let alert = UIAlertController(
            title: "Simulator: Kartöppning",
            message: "Adress: \(fullAddress)\n(Öppnas i Kartor på riktig enhet)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
        return
        #endif
        
        CLGeocoder().geocodeAddressString(fullAddress) { placemarks, error in
            if let error = error {
                print("Geokodningsfel: \(error.localizedDescription)")
                return
            }
            guard let placemark = placemarks?.first else { return }
            
            let mapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark))
            mapItem.name = self.name
            mapItem.openInMaps()
        }
    }
//    func openInMaps() {
//        let fullAddress = "\(streetName), \(postalCode) \(city)"
//        
//        CLGeocoder().geocodeAddressString(fullAddress) { placemarks, error in
//            if let placemark = placemarks?.first {
//                let mapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark))
//                mapItem.name = self.name
//                mapItem.openInMaps(launchOptions: nil)
//            }
//        }
//    }
}
