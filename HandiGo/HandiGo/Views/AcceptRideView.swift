import SwiftUI

struct AcceptRideView: View {
    /// Model for the data in this view.
    @ObservedObject var viewModel: RideViewModel
    
    let passenger_name: String
    let pickup: String
    let dropoff: String

    init(viewModel: RideViewModel, passenger_name: String, pickup: String, dropoff: String) {
        self.viewModel = viewModel
        self.passenger_name = passenger_name
        self.pickup = pickup
        self.dropoff = dropoff
    }
    
    @State private var uuid = UUID()
    
    @State private var busy = false
    @State private var errorMessage: String?
    @State private var path = [String]()
    
    // letting the driver accept the ride if they choose to do so
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("Do you want to accept this ride?")
                
                Button("Accept Ride") {
                    // generating a UUID for the driver
                    uuid = UUID()
                    viewModel.driver_uuid = uuid
                    
                    // setting model parameters
                    viewModel.passenger_name = passenger_name
                    viewModel.pickup = pickup
                    viewModel.dropoff = dropoff
                    
                    addRide()
                    path.append("accept")
                }.buttonStyle(BlueButton()).navigationDestination(for: String.self) { route in
                    switch route {
                    case "accept":
                        BeaconView(beaconUUID: uuid)
                    default:
                        ContentView()
                    }
                }
            }
        }
    }
    
    private func addRide() {
        self.errorMessage = nil
        self.busy = true
        Task {
            do {
                try await viewModel.addRide()
            } catch {
                errorMessage = "Failed to add ride: \(error.localizedDescription)"
                busy = false
            }
        }
    }
}

struct AcceptRideView_Previews: PreviewProvider {
    static var previews: some View {
        AcceptRideView(viewModel: RideViewModel(), passenger_name: "", pickup: "", dropoff: "")
    }
}
