//
//  PassengerViewModel.swift
//  HandiGo
//
//  Created by Shishira Bhavimane on 5/17/23.
//

import Models
import SwiftUI

/// Models the data used in the `Passenger` view.
class PassengerViewModel: ObservableObject {
    /// New passenger name (initially, an empty string).
    @Published var name = ""
    @Published var pickup = ""
    @Published var dropoff = ""
    @Published var driver_uuid = UUID()
    @Published var accept = false

    /// Sends a request to add a new passenger to the backend.
    func addPassenger() async throws {
        let passenger = Passenger(name: name, pickup: pickup, dropoff: dropoff, driver_uuid: driver_uuid, accept: accept)
        try await HTTP.post(url: HTTP.baseURL, body: passenger)
    }
}
