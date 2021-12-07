//
//  BLEManager.swift
//  FindDevice
//
//  Created by slava on 07/12/2021.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate {
    //MARK: Property
    @Published var peripherals = [Peripheral]()
    @Published var isSwitchedOn = false
    
    
    var myCentral: CBCentralManager!
    
    override init() {
           super.init()

           myCentral = CBCentralManager(delegate: self, queue: nil)
           myCentral.delegate = self
       }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
                
        } else {
            isSwitchedOn = false
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var peripheralName: String!
        
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
                peripheralName = name
        } else {
            peripheralName = "Unknown"
        }
        
        let newPeripheral = Peripheral(id: peripherals.count, name: peripheralName, rssi: RSSI.intValue)
            print(newPeripheral)
            peripherals.append(newPeripheral)
    }
    
    //Start
    func startScanning () {
           print ("startScanning")
           myCentral.scanForPeripherals (withServices: nil, options: nil)
       }
    
    func stopScanning () {
           print ("stopScanning")
           myCentral.stopScan ()
       }
}
