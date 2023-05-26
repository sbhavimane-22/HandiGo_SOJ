import Models
import SwiftUI

/// Main view displaying a list of riders.
struct DriverView: View {
    /// Model for the data in this view.
    @StateObject private var viewModel = DriverViewModel()

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
                        ForEach(viewModel.passengers) { passenger in
                            // Each element in the list is a link that, if clicked, will open the view/update/delete
                            // view for the corresponding kitten.
                            NavigationLink(
                                destination: AcceptRideView(viewModel: RideViewModel(), passenger_name: passenger.name, pickup: passenger.pickup, dropoff: passenger.dropoff)
                            ) {
                                Text(passenger.name)
                                    .font(.title3)
                                Text(passenger.pickup)
                                Text(passenger.dropoff)
                            }
                        }
                    }
                    // Pull to refresh
                    .refreshable { fetchPassengers() }
                }
                if busy {
                    ProgressView()
                }
            }
            .sheet(
                isPresented: $showingAddModal,
                onDismiss: {
                    // On dismiss, retrieve an updated list of riders.
                    fetchPassengers()
                }
            ) {
                PassengerView(viewModel: PassengerViewModel())
            }
            // When the view appears, retrieve an updated list of riders.
            .onAppear(perform: fetchPassengers)
            .navigationBarTitle("Passengers", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func fetchPassengers() {
        self.busy = true
        self.errorMessage = nil
        Task {
            do {
                try await viewModel.fetchPassengers()
                busy = false
            } catch {
                busy = false
                errorMessage = "Failed to fetch list of passengers: \(error.localizedDescription)"
            }
        }
    }
}

struct DriverView_Previews: PreviewProvider {
    static var previews: some View {
        DriverView()
    }
}
