//
//  BluetoothManager.swift
//  BLEDevicesFinder
//
//  Created by Roman Bigun on 18.04.2023.
//

import Foundation
import CoreBluetooth

struct Peripheral: Identifiable {
    let id: Int
    let name: String
    let rssi: Int
    
    /* RSSI VALUES (quality of signal) *
     
    dBm: deciBel*milliwatts
    
    Nice signall: from -50 to -65 dBm
    Good signall: from -65 to -75 dBm
    Bad signall: from -75 to -85 dBm
    Unused values: from -85 to -100 dBm
     
    */
}

class BluetoothManager: NSObject, ObservableObject {
    var centralManager: CBCentralManager?
    
    @Published var isSwitchedOn = false
    @Published var peripherals = [Peripheral]()
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager?.delegate = self
    }
    
    func startScanning() {
        print("Scanner started...\n")
        centralManager?.scanForPeripherals(withServices: nil)
    }
    
    func stopScanning() {
        print("Scanning stopped\n")
        centralManager?.stopScan()
    }
    
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
        } else {
            isSwitchedOn = false
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        
        var peripheralName: String!
        
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            peripheralName = name
        }
        else {
            peripheralName = "Unknown"
        }
        
        let newPeripheral = Peripheral(id: peripherals.count, name: peripheralName, rssi: RSSI.intValue)
        print(newPeripheral)
        peripherals.append(newPeripheral)
    }
}
