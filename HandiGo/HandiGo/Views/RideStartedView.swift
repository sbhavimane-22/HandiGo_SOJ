import SwiftUI

// simple view to display after the ride has been confirmed
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
