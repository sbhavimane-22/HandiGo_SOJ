//
//  TestBeaconView.swift
//  HandiGo
//
//  Created by Shishira Bhavimane on 5/18/23.
//

//import SwiftUI
//import CoreLocation
//import CoreBluetooth
//
//class BeaconManager: NSObject, CLLocationManagerDelegate, ObservableObject {
//    var locationManager: CLLocationManager?
//    let myUUID: UUID
//    var timer: Timer?
//    @Published var distance: Double = 0.0
//
//    init(uuid: UUID) {
//        self.myUUID = uuid
//        super.init()
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//    }
//
//    func startMonitoring() {
//        let beaconRegion = CLBeaconRegion(uuid: myUUID, identifier: "YourBeaconIdentifier")
//        locationManager?.startMonitoring(for: beaconRegion)
//        startRangingTimer()
//    }
//
//    func startRangingTimer() {
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
//            guard let self = self else { return }
//            let constraint = CLBeaconIdentityConstraint(uuid: self.myUUID)
//            self.locationManager?.startRangingBeacons(satisfying: constraint)
//        }
//    }
//
//    func stopRangingTimer() {
//        timer?.invalidate()
//        timer = nil
//    }
//
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        let constraint = CLBeaconIdentityConstraint(uuid: myUUID)
//        locationManager?.stopRangingBeacons(satisfying: constraint)
//        stopRangingTimer()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedAlways || status == .authorizedWhenInUse {
//            startMonitoring()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        let constraint = CLBeaconIdentityConstraint(uuid: myUUID)
//        locationManager?.startRangingBeacons(satisfying: constraint)
//        //locationManager?.startRangingBeacons(in: region as! CLBeaconRegion)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
//        if let beacon = beacons.first {
//            let accuracy = beacon.accuracy
//            distance = accuracy
//        }
//    }
//}
//
//struct BeaconView: View {
//    @StateObject private var beaconManager: BeaconManager
//    let beaconUUID: UUID
//    
//    init(beaconUUID: UUID) {
//        self.beaconUUID = beaconUUID
//        _beaconManager = StateObject(wrappedValue: BeaconManager(uuid: beaconUUID))
//    }
//
//    var body: some View {
//        VStack {
//            Text("Your phone is a beacon.")
//                .font(.title)
//                .padding()
//
//            Spacer()
//        }
//    }
//}
//
//struct BeaconView_Previews: PreviewProvider {
//    static var previews: some View {
//        BeaconView(beaconUUID: UUID())
//    }
//}
//
//struct DistanceView: View {
//    @StateObject private var beaconManager: BeaconManager
//    let beaconUUID: UUID
//    
//    init(beaconUUID: UUID) {
//        self.beaconUUID = beaconUUID
//        _beaconManager = StateObject(wrappedValue: BeaconManager(uuid: beaconUUID))
//    }
//
//    var body: some View {
//        VStack {
//            Text("Distance from Beacon")
//                .font(.title)
//                .padding()
//
//            Text(String(format: "%.2f meters", beaconManager.distance))
//                .font(.largeTitle)
//                .padding()
//
//            Spacer()
//        }
//        .onAppear {
//            beaconManager.locationManager?.requestWhenInUseAuthorization()
//        }
//    }
//}
//
//struct DistanceView_Previews: PreviewProvider {
//    static var previews: some View {
//        DistanceView(beaconUUID: UUID())
//    }
//}




































//import SwiftUI
//import CoreLocation
//import CoreBluetooth
//
//class BeaconManager: NSObject, CLLocationManagerDelegate {
//    var locationManager: CLLocationManager?
//
//    override init() {
//        super.init()
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedAlways || status == .authorizedWhenInUse {
//            startMonitoring()
//        }
//    }
//
//    func startMonitoring() {
//        let uuid = UUID(yourUserUUIDString) // Replace with your user's UUID
//        let beaconRegion = CLBeaconRegion(uuid: uuid, identifier: "YourBeaconIdentifier")
//        locationManager?.startMonitoring(for: beaconRegion)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        locationManager?.startRangingBeacons(in: region as! CLBeaconRegion)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        locationManager?.stopRangingBeacons(in: region as! CLBeaconRegion)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
//        if let beacon = beacons.first {
//            let proximity = beacon.proximity
//            let accuracy = beacon.accuracy
//
//            // Use the proximity and accuracy values as needed to display or calculate distance
//        }
//    }
//}


//class BeaconManager: NSObject, CLLocationManagerDelegate, ObservableObject {
//    let locationManager = CLLocationManager()
//    let beaconUUID: UUID
//
//    @Published var distance: CLProximity = .unknown
//
//    init(uuid: UUID) {
//        self.beaconUUID = uuid
//        super.init()
//        locationManager.delegate = self
//    }
//
//    func startMonitoring() {
//        let beaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, identifier: "MyBeaconRegion")
//        locationManager.startMonitoring(for: beaconRegion)
//
//        let constraint = CLBeaconIdentityConstraint(uuid: beaconUUID)
//        locationManager.startRangingBeacons(satisfying: constraint)
//        //locationManager.startRangingBeacons(in: beaconRegion)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
//        if let nearestBeacon = beacons.first {
//            distance = nearestBeacon.proximity
//        }
//    }
//}

//struct BeaconView: View {
//    @StateObject private var beaconManager: BeaconManager
//    let beaconUUID: UUID
//
//    init(beaconUUID: UUID) {
//        self.beaconUUID = beaconUUID
//        _beaconManager = StateObject(wrappedValue: BeaconManager(uuid: beaconUUID))
//    }
//
//    var body: some View {
//        VStack {
//            Text("Distance: \(beaconManager.distance.rawValue)")
//                .font(.largeTitle)
//                .padding()
//        }
//        .onAppear {
//            beaconManager.startMonitoring()
//        }
//    }
//}
//
//struct TestBeaconView: View {
//    let myUUID : UUID
//    init(myUUID: UUID) {
//        self.myUUID = myUUID
//    }
//
//    var body: some View {
//        NavigationView {
//            BeaconView(beaconUUID: myUUID)
//                .navigationTitle("Beacon Distance")
//        }
//    }
//}
//
//struct TestBeaconView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestBeaconView(myUUID: UUID())
//    }
//}
