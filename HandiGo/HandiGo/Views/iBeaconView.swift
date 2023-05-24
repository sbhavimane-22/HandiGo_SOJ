//
//  iBeaconView.swift
//  HandiGo
//
//  Created by Shishira Bhavimane on 5/17/23.
//

//import SwiftUI
//import CoreLocation
//
//class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
//        if let beacon = beacons.first {
//            let accuracy = beacon.accuracy // Estimated distance to the beacon in meters
//
//            // Display the estimated distance in your UI
//            print("Estimated distance to iBeacon: \(accuracy)m")
//        }
//    }
//}
//
//struct iBeaconPassengerView: View {
//    let locationManager = CLLocationManager()
//    let myUUID : UUID
//
//    init(myUUID: UUID) {
//        self.myUUID = myUUID
//    }
//
//    var body: some View {
//        Text("iBeacon Passenger View")
//            .onAppear {
//                let delegate = LocationManagerDelegate()
//                locationManager.delegate = delegate
//
//                // Request location authorization from the user
//                locationManager.requestWhenInUseAuthorization()
//
//                // Start ranging for iBeacons
//                startRangingForIBeacons()
//            }
//    }
//
//    func startRangingForIBeacons() {
//        if CLLocationManager.isRangingAvailable() {
//            let constraint = CLBeaconIdentityConstraint(uuid: myUUID)
//
//            locationManager.startRangingBeacons(satisfying: constraint)
//        }
//    }
//}
//
//struct iBeaconPassengerView_Previews: PreviewProvider {
//    static var previews: some View {
//        iBeaconPassengerView(myUUID: UUID())
//    }
//}
