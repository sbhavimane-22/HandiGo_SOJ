import Models
import SwiftUI

/// Models the data used in the `Passenger` view.
class PassengerViewModel: ObservableObject {
    /// New passenger name (initially, an empty string).
    @Published var name = ""
    @Published var pickup = ""
    @Published var dropoff = ""

    /// Sends a request to add a new passenger to the backend.
    func addPassenger() async throws {
        let passenger = Passenger(name: name, pickup: pickup, dropoff: dropoff)
        guard let url = URL(string: "passenger", relativeTo: HTTP.baseURL) else { return }
        try await HTTP.post(url: url, body: passenger)
    }
}
