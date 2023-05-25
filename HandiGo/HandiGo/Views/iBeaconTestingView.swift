//
//  iBeaconTestingView.swift
//  HandiGo
//
//  Created by Shishira Bhavimane on 5/18/23.
//

import SwiftUI
import CoreLocation
import CoreBluetooth
import AudioToolbox
import AVFoundation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    let beaconUUID: UUID
    let closerSound: SystemSoundID = 1050
    let confirmSound: SystemSoundID = 1075
    private var immediateProximity = false
    private var mindist = 1000.0
    private var beaconRegion: CLBeaconRegion
    @Published var distanceString = "Driver has not arrived yet."
    @Published var distance = 1000.0 {
        didSet {
            if (distance < mindist && abs(mindist - distance) > 0.5) {
                mindist = distance
                AudioServicesPlayAlertSound(closerSound)
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            
            if (distance < 0.05 && !immediateProximity) {
                immediateProximity = true
                AudioServicesPlayAlertSound(confirmSound)
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
    }
    
    init(beaconUUID: UUID) {
        self.beaconUUID = beaconUUID
        self.beaconRegion = CLBeaconRegion(uuid: beaconUUID, identifier: "YourBeaconIdentifier")
        super.init()
        locationManager.delegate = self
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startMonitoring() {
        print("Monitoring beacon: \(beaconUUID)")
        print("Distance to beacon: \(self.distanceString)")
        locationManager.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
        print("Beaconregion: \(beaconRegion)")
        }
    
    func stopMonitoring() {
        print("Stopping monitoring")
        locationManager.stopRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
    }
    
//    func startMonitoring() {
//        let beaconRegion = CLBeaconRegion(uuid: beaconUUID, identifier: "YourBeaconIdentifier")
//        locationManager.startRangingBeacons(in: beaconRegion)
//    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("Beacons: \(beacons)")
        guard let closestBeacon = beacons.first else {
            return
        }
        let distance = closestBeacon.accuracy
        self.distanceString = String(format: "%.2f meters", distance)
        self.distance = distance
        print("Distance to beacon: \(self.distanceString)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
      print("Failed monitoring region: \(error.localizedDescription)")
    }
      
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print("Location manager failed: \(error.localizedDescription)")
    }
    
}

class BeaconManager: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    
    var peripheralManager: CBPeripheralManager?
    let beaconUUID: UUID
    let beaconRegion: CLBeaconRegion!
//    var centralManager: CBCentralManager!
    
    init(beaconUUID: UUID) {
        self.beaconUUID = beaconUUID
        let major: CLBeaconMajorValue = 12345 // Replace with your own major value
        let minor: CLBeaconMinorValue = 56890 // Replace with your own minor value
        beaconRegion = CLBeaconRegion(uuid: beaconUUID, major: major, minor: minor, identifier: "YourBeaconIdentifier")
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
    }
    
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        print("cbcentralmanager initialized")
//    }
    
    func startAdvertising() {
        print("ATTEMPTING TO START ADVERTISING UUID \(self.beaconUUID)")
        let peripheralData = beaconRegion.peripheralData(withMeasuredPower: nil)
        peripheralManager?.startAdvertising(((peripheralData as NSDictionary) as! [String: Any]))
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            // DEBUG message, peripheral manager should have been switched to on
            print("peripheral state: \(peripheral.state)")
        } else { return }
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
                if (beaconManager.peripheralManager != nil) {
                    if beaconManager.peripheralManager?.state == .poweredOn {
                        beaconManager.startAdvertising()
                    }
                    else {
                        print("LINE108")
                        // Bluetooth is not powered on, handle the error or prompt the user to enable Bluetooth
                        return
                    }
                }
                else {
                    print("peripheral manager uninitialized")
                    return
                }
            }) {
                Text("I've arrived")
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
    @State private var showNextView = false
    
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
                Task { locationManager.requestAuthorization()
                }
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
            
            if (locationManager.distance < 0.05) {
                HStack {
                    Button(action: {
                        locationManager.stopMonitoring()
                        showNextView = true
                    }) {
                        Text("Confirm Ride")
                            .font(Font.custom("Helvetica", size: 50))
                            .bold()
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16))
                            .background(Capsule().fill(Color.green))
                    }
                    
                    NavigationLink(
                        destination: RideStartedView(),
                        isActive: $showNextView,
                        label: { EmptyView() }
                    )
                    .hidden() // Hide the link, only using it for navigation
                }
            }
        }
    }
}

struct DistanceView_Previews: PreviewProvider {
    static var previews: some View {
        DistanceView(beaconUUID: UUID())
    }
}
