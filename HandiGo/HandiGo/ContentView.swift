//
//  ContentView.swift
//  HandiGo
//
//  Created by Shishira Bhavimane on 5/17/23.
//

import SwiftUI

public var testUUID = UUID(uuidString: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX")

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed
        return configuration.label
            .padding()
            .background(isPressed ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .frame(width: 1000, height: 100)
            .bold()
            .font(.custom("Helvetica", size: 45))
            .cornerRadius(10)
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isPressed)
    }
}

struct ContentView: View {
    let customFont = Font.custom("Helvetica", size: 65)
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to")
                    .font(customFont)
                    .bold()
                    .offset(x: 0, y: -150)
                
                Text("Handigo!")
                    .font(customFont)
                    .bold()
                    .offset(x: 0, y: -140)
                
                Text("Select what describes you:")
                    .font(Font.custom("Helvetica", size: 25))
                    .offset(x: 0, y: -50)
                
                NavigationLink(destination: DriverView()) {
                        Text("Driver")
                        .font(Font.custom("Helvetica", size: 50))
                        .bold()
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .background(Capsule().fill(Color.blue))
                        .offset(x: 0, y: -10)
                }
                
                NavigationLink(destination: PassengerView(viewModel: PassengerViewModel())) {
                        Text("Passenger")
                        .font(Font.custom("Helvetica", size: 50))
                        .bold()
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .background(Capsule().fill(Color.blue))
                }
                
                NavigationLink(destination: DistanceView(beaconUUID: testUUID ?? UUID())) {
                        Text("iBeacon Passenger Test")
                        .font(Font.custom("Helvetica", size: 20))
                        .bold()
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .background(Capsule().fill(Color.blue))
                }
                
                NavigationLink(destination: BeaconView(beaconUUID: testUUID ?? UUID())) {
                        Text("iBeacon Driver Test")
                        .font(Font.custom("Helvetica", size: 20))
                        .bold()
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .background(Capsule().fill(Color.blue))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

////
////  ContentView.swift
////  HandiGo
////
////  Created by Shishira Bhavimane on 5/17/23.
////
//
//import SwiftUI
//
//struct BlueButton: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        let isPressed = configuration.isPressed
//        return configuration.label
//            .padding()
//            .background(isPressed ? Color.gray : Color.blue)
//            .foregroundColor(.white)
//            .clipShape(Capsule())
//            .frame(width: 1000, height: 100)
//            .bold()
//            .font(.custom("Helvetica", size: 45))
//            .cornerRadius(10)
//            .scaleEffect(isPressed ? 0.9 : 1.0)
//            .animation(.easeInOut(duration: 0.2), value: isPressed)
//    }
//}
//
//struct ContentView: View {
//    let customFont = Font.custom("Helvetica", size: 65)
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Welcome to")
//                    .font(customFont)
//                    .bold()
//                    .offset(x: 0, y: -150)
//
//                Text("Handigo!")
//                    .font(customFont)
//                    .bold()
//                    .offset(x: 0, y: -140)
//
//                Text("Select what describes you:")
//                    .font(Font.custom("Helvetica", size: 25))
//                    .offset(x: 0, y: -50)
//
//                NavigationLink(destination: DriverView()) {
//                        Text("Driver")
//                        .font(Font.custom("Helvetica", size: 50))
//                        .bold()
//                        .foregroundColor(.white)
//                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
//                        .background(Capsule().fill(Color.blue))
//                        .offset(x: 0, y: -10)
//                }
//
//                NavigationLink(destination: PassengerView(viewModel: PassengerViewModel())) {
//                        Text("Passenger")
//                        .font(Font.custom("Helvetica", size: 50))
//                        .bold()
//                        .foregroundColor(.white)
//                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
//                        .background(Capsule().fill(Color.blue))
//                }
//            }
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
