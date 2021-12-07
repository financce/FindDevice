//
//  Service.swift
//  FindDevice
//
//  Created by slava on 06/12/2021.
//

import SwiftUI
import CoreBluetooth
import Combine

class Service: ObservableObject {
    
    //MARK: Manager propertys
    @Published var status: [String] = []
    @Published var state: CBManagerState = .unknown
    @Published var peripherals: [CBPeripheral] = []
    
    private lazy var manager: BluetoothManager = BluetoothManager()
    private lazy var cancellables: Set<AnyCancellable> = .init()
    
    deinit {
        for item in cancellables {
            item.cancel()
        }
    
    
    func start() {
        
          manager.stateSubject
              .sink { [weak self] state in
                  self?.state = state
              }
              .store(in: &cancellables)
        
          manager.peripheralSubject
              .filter { [weak self] in self?.peripherals.contains($0) == false }
              .sink { [weak self] in self?.peripherals.append($0) }
              .store(in: &cancellables)
        
          manager.start()
      }
    
    

    

    
        
//        manager.servicesSubject
//            .map { $0.filter { Constants.serviceUUIDs.contains($0.uuid) } }
//            .sink { [weak self] services in
//                services.forEach { service in
//                    self?.peripheral.discoverCharacteristics(nil, for: service)
//                }
//            }
//            .store(in: &cancellables)
    }
    
    
    
}


enum Constants {
    static let readServiceUUID: CBUUID = .init(string: "FFD0")
    static let writeServiceUUID: CBUUID = .init(string: "FFD5")
    static let serviceUUIDs: [CBUUID] = [readServiceUUID, writeServiceUUID]
    static let readCharacteristicUUID: CBUUID = .init(string: "FFD4")
    static let writeCharacteristicUUID: CBUUID = .init(string: "FFD9")
}
