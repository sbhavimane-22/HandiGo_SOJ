//
//  iBeaconTestingView.swift
//  HandiGo
//
//  Created by Shishira Bhavimane on 5/18/23.
//

import SwiftUI
import CoreLocation
import CoreBluetooth

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    let beaconUUID: UUID
    @Published var distanceString = "Unknown"
    
    init(beaconUUID: UUID) {
        self.beaconUUID = beaconUUID
        super.init()
        locationManager.delegate = self
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startMonitoring() {
        let beaconRegion = CLBeaconRegion(uuid: beaconUUID, identifier: "YourBeaconIdentifier")
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        guard let closestBeacon = beacons.first else {
            return
        }
        
        let distance = closestBeacon.accuracy
        distanceString = String(format: "%.2f meters", distance)
    }
}

class BeaconManager: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    private var peripheralManager: CBPeripheralManager?
    let beaconUUID: UUID
    
    init(beaconUUID: UUID) {
        self.beaconUUID = beaconUUID
    }
    
    func startAdvertising() {
        let major: CLBeaconMajorValue = 12345 // Replace with your own major value
        let minor: CLBeaconMinorValue = 56890 // Replace with your own minor value
        let beaconRegion = CLBeaconRegion(uuid: beaconUUID, major: major, minor: minor, identifier: "YourBeaconIdentifier")
        
        let peripheralData = beaconRegion.peripheralData(withMeasuredPower: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        peripheralManager?.startAdvertising(((peripheralData as NSDictionary) as! [String: Any]))
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            // Start advertising when the peripheral is ready
            startAdvertising()
        }
    }
}

struct BeaconView: View {
    @StateObject private var beaconManager: BeaconManager
    let myUUID: UUID
    
    init(beaconUUID: UUID) {
        self.myUUID = beaconUUID
        _beaconManager = StateObject(wrappedValue: BeaconManager(beaconUUID: beaconUUID))
    }
    
    var body: some View {
        VStack {
            Text("You are a Beacon")
                .font(.headline)
                .padding()
            
            Button(action: {
                beaconManager.startAdvertising()
            }) {
                Text("Start Advertising")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

struct BeaconView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconView(beaconUUID: UUID())
    }
}

struct DistanceView: View {
    @StateObject private var locationManager: LocationManager
    let myUUID: UUID

    init(beaconUUID: UUID) {
        self.myUUID = beaconUUID
        _locationManager = StateObject(wrappedValue: LocationManager(beaconUUID: beaconUUID))
    }
    
    var body: some View {
        VStack {
            Text("Distance to Beacon: \(locationManager.distanceString)")
                .font(.headline)
                .padding()
            
            Button(action: {
                locationManager.requestAuthorization()
                locationManager.startMonitoring()
            }) {
                Text("Start Monitoring")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

struct DistanceView_Previews: PreviewProvider {
    static var previews: some View {
        DistanceView(beaconUUID: UUID())
    }
}

