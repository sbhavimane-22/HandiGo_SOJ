//
//  PassengerView.swift
//  HandiGo
//
//  Created by Shishira Bhavimane on 5/17/23.
//

import Models
import SwiftUI

/// View to support requesting a new ride.
struct PassengerView: View {
    /// Model for the data in this view.
    @ObservedObject var viewModel: PassengerViewModel
    /// Presentation mode environment key. This is used to enable the view to dismiss itself on button presses.
    @Environment(\.presentationMode) private var presentationMode

    @State private var errorMessage: String?
    @State private var busy = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Form {
                        TextField("Name", text: $viewModel.name)
                        TextField("Pickup Location", text: $viewModel.pickup)
                    }
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                    HStack {
                        Button("Request Ride") {
                            addPassenger()
                        }
                        .disabled(viewModel.name.isEmpty)
                        .buttonStyle(.borderedProminent)
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
                presentationMode.wrappedValue.dismiss()
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
