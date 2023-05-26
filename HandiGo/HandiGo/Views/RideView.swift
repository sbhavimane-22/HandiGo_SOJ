import SwiftUI

struct RideView: View {
    /// Model for the data in this view.
    @StateObject private var viewModel = PassengerRideViewModel()

    @State private var showingAddModal = false
    @State private var busy = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                    List {
                        ForEach(viewModel.rides) { ride in
                            // Each element in the list is a link that, if clicked, will open the view/update/delete
                            // view for the corresponding ride.
                            NavigationLink(
                                destination: DistanceView(beaconUUID: ride.driver_uuid)
                            ) {
                                Text(ride.passenger_name)
                                    .font(.title3)
                                Text(ride.pickup)
                                Text(ride.dropoff)
                            }
                        }
                    }
                    // Pull to refresh
                    .refreshable { fetchRides() }
                }
                if busy {
                    ProgressView()
                }
            }
            .sheet(
                isPresented: $showingAddModal,
                onDismiss: {
                    // On dismiss, retrieve an updated list of riders.
                    fetchRides()
                }
            ) {
                AcceptRideView(viewModel: RideViewModel(), passenger_name: "", pickup: "", dropoff: "")
            }
            // When the view appears, retrieve an updated list of riders.
            .onAppear(perform: fetchRides)
            .navigationBarTitle("Ride:", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func fetchRides() {
        self.busy = true
        self.errorMessage = nil
        Task {
            do {
                try await viewModel.fetchRides()
                busy = false
            } catch {
                busy = false
                errorMessage = "Failed to fetch list of rides: \(error.localizedDescription)"
            }
        }
    }
}

struct RideView_Previews: PreviewProvider {
    static var previews: some View {
        RideView()
    }
}
