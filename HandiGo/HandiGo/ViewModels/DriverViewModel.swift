import Models
import SwiftUI

/// Models the data used in the `PassengerList` view.
class DriverViewModel: ObservableObject {
    /// The list of riders to display.
    @Published var passengers = [Passenger]()

    /// Loads an updated list of riders from the backend server.
    func fetchPassengers() async throws {
        guard let url = URL(string: "passenger", relativeTo: HTTP.baseURL) else { return }
        let passengers = try await HTTP.get(url: url, dataType: [Passenger].self)
        // we do this on the main queue so that when the value is updated the view will automatically be refreshed.
        DispatchQueue.main.async {
            self.passengers = passengers
        }
    }
}
