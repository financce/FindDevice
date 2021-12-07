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
    
}
