//
//  AcceptRideView.swift
//  HandiGo
//
//  Created by Shishira Bhavimane on 5/17/23.
//

import SwiftUI

struct AcceptRideView: View {
    @State private var showNextView = false
    @State private var uuid = UUID()
    
    var body: some View {
        VStack {
            Text("Do you want to accept this ride?")
            
            Button("Accept Ride") {
                uuid = UUID()
                showNextView = true
            }.buttonStyle(BlueButton())
            
            NavigationLink(
                destination: ContentView(), //iBeaconPassengerView(myUUID: uuid),
                isActive: $showNextView,
                label: { EmptyView() }
            )
            .hidden() // Hide the link, only using it for navigation
        }
    }
}

struct AcceptRideView_Previews: PreviewProvider {
    static var previews: some View {
        AcceptRideView()
    }
}

