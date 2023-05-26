import Models
import SwiftUI

/// View to support requesting a new ride.
struct PassengerView: View {
    /// Model for the data in this view.
    @ObservedObject var viewModel: PassengerViewModel

    @State private var errorMessage: String?
    @State private var busy = false
    @State private var showNextView = false

    // allow the passenger to input their ride information and request a ride
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Form {
                        TextField("Name", text: $viewModel.name)
                        TextField("Pickup Location", text: $viewModel.pickup)
                        TextField("Dropoff Location", text: $viewModel.dropoff)
                    }
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                    HStack {
                        Button("Request Ride") {
                            addPassenger()
                            showNextView = true
                        }
                        // gray out the button if information not entered
                        .disabled(viewModel.name.isEmpty)
                        .disabled(viewModel.pickup.isEmpty)
                        .disabled(viewModel.dropoff.isEmpty)
                        .buttonStyle(.borderedProminent)
                        
                        NavigationLink(
                            destination: RideView(),
                            isActive: $showNextView,
                            label: { EmptyView() }
                        )
                        .hidden() // Hide the link, only using it for navigation
                    }
                }
                if busy {
                    ProgressView()
                }
            }
        }
    }

    private func addPassenger() {
        self.errorMessage = nil
        self.busy = true
        Task {
            do {
                try await viewModel.addPassenger()
            } catch {
                errorMessage = "Failed to add passenger: \(error.localizedDescription)"
                busy = false
            }
        }
    }
}

struct PassengerView_Previews: PreviewProvider {
    static var previews: some View {
        PassengerView(viewModel: PassengerViewModel())
    }
}
