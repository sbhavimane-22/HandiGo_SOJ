import Models
import SwiftUI

/// Models the data used in the `PassengerList` view.
class PassengerRideViewModel: ObservableObject {
    /// The list of riders to display.
    @Published var rides = [Ride]()

    /// Loads an updated list of riders from the backend server.
    func fetchRides() async throws {
        guard let url = URL(string: "ride", relativeTo: HTTP.baseURL) else { return }
        let rides = try await HTTP.get(url: url, dataType: [Ride].self)
        // we do this on the main queue so that when the value is updated the view will automatically be refreshed.
        DispatchQueue.main.async {
            self.rides = rides
        }
    }
}
