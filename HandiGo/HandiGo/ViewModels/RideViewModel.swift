import Models
import SwiftUI

/// Models the data used in the `Ride` view.
class RideViewModel: ObservableObject {
    /// New passenger name (initially, an empty string).
    @Published var driver_uuid = UUID()
    @Published var passenger_name = ""
    @Published var pickup = ""
    @Published var dropoff = ""

    /// Sends a request to add a new ride to the backend.
    func addRide() async throws {
        let ride = Ride(driver_uuid: driver_uuid, passenger_name: passenger_name, pickup: pickup, dropoff: dropoff)
        guard let url = URL(string: "ride", relativeTo: HTTP.baseURL) else { return }
        try await HTTP.post(url: url, body: ride)
    }
}
