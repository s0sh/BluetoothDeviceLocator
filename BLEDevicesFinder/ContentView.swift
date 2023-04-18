//
//  ContentView.swift
//  BLEDevicesFinder
//
//  Created by Roman Bigun on 18.04.2023.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var bluetoothManager = BluetoothManager()
    
    var body: some View {
        VStack (spacing: 10) {
            Text("Bluetooth Devices")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .center)
            List(bluetoothManager.peripherals) { peripheral in
                if peripheral.name.count > 0 {
                    HStack {
                        peripheral.name.count > 0 ? Text(peripheral.name) : Text("None")
                        Spacer()
                        Text(String(peripheral.rssi))
                    }
                }
            }.frame(height: 300)
            Spacer()
            Text("STATUS").font(.headline)
            
            if bluetoothManager.isSwitchedOn {
                Text("Bluetooth is ON")
                    .foregroundColor(.green)
            } else {
                Text("Bluetooth is OFF")
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            HStack {
                VStack (spacing: 10) {
                    Button(action: { bluetoothManager.startScanning() }) {
                        Text("Start Scanning")
                    }
                    Button(action: { bluetoothManager.stopScanning() }) {
                        Text("Stop Scanning")
                    }
                }.padding()
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
