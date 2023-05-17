//
//  DriverViewModel.swift
//  HandiGo
//
//  Created by Shishira Bhavimane on 5/17/23.
//

import Models
import SwiftUI

/// Models the data used in the `PassengerList` view.
class DriverViewModel: ObservableObject {
    /// The list of riders to display.
    @Published var passengers = [Passenger]()

    /// Loads an updated list of riders from the backend server.
    func fetchPassengers() async throws {
        let passengers = try await HTTP.get(url: HTTP.baseURL, dataType: [Passenger].self)
        // we do this on the main queue so that when the value is updated the view will automatically be refreshed.
        DispatchQueue.main.async {
            self.passengers = passengers
        }
    }
}
