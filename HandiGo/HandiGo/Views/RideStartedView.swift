//
//  RideStartedView.swift
//  HandiGo
//
//  Created by Shishira Bhavimane on 5/24/23.
//

import SwiftUI

struct RideStartedView: View {
    var body: some View {
        Text("The ride has started!")
            .font(.custom("Helvetica", size: 65))
            .bold()
            .multilineTextAlignment(.center)
    }
}

struct RideStartedView_Previews: PreviewProvider {
    static var previews: some View {
        RideStartedView()
    }
}
