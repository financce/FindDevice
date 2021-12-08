//
//  HeartMonitorService.swift
//  FindDevice
//
//  Created by slava on 08/12/2021.
//

import UIKit
import CoreBluetooth

let heartRateServiceCBUUID = CBUUID(string: "0x004c")
let battery = CBUUID(string: "00000007-0000-3512-2118-0009AF100700")
let myUuid = UUID(uuidString: "598110AF-091F-D325-71CF-7F5BDA0492D8")
let versionID = CBUUID(string: "00001530-0000-3512-2118-0009af100700")

let battaryNew = CBUUID(string: "00000006-0000-3512-2118-0009af100700")
let MI_CHARACTERISTIC_COUNT_STEPS_UUID = CBUUID.init(string: "00000007-0000-3512-2118-0009AF100700")
//6E400007-B5A3-F393-E0A9-E50E24DCCA9E
let uknown = CBUUID(string: "6E400007-B5A3-F393-E0A9-E50E24DCCA9E")

let characterisctic1 = CBUUID(string: "6E400004-B5A3-F393-E0A9-E50E24DCCA9E")
let characterisctic2 = CBUUID(string: "6E400006-B5A3-F393-E0A9-E50E24DCCA9E")
let characterisctic3 = CBUUID(string: "6E400007-B5A3-F393-E0A9-E50E24DCCA9E")
let characterisctic4 = CBUUID(string: "6E400005-B5A3-F393-E0A9-E50E24DCCA9E")
let characterisctic5 = CBUUID(string: "6E400005-B5A3-F393-E0A9-E50E24DCCA9E")




class HRMViewController: UIViewController {

  @IBOutlet weak var heartRateLabel: UILabel!
  @IBOutlet weak var bodySensorLocationLabel: UILabel!
  
  var centralManager: CBCentralManager!
  var heartRatePeripheral: CBPeripheral!
  var characteristic: CBCharacteristic!
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    centralManager = CBCentralManager(delegate: self, queue: nil)
   

    // Make the digits monospaces to avoid shifting when the numbers change
    heartRateLabel.font = UIFont.monospacedDigitSystemFont(ofSize: heartRateLabel.font!.pointSize, weight: .regular)
  }

  func onHeartRateReceived(_ heartRate: Int) {
    heartRateLabel.text = String(heartRate)
    print("BPM: \(heartRate)")
  }
}

extension HRMViewController: CBCentralManagerDelegate {
  //example wwwdc
  
  
  func centralManagerDidUpdateState(_ central: CBCentralManager) {

    switch central.state {
      case .unknown:
        print("central.state is .unknown")
      case .resetting:
        print("central.state is .resetting")
      case .unsupported:
        print("central.state is .unsupported")
      case .unauthorized:
        print("central.state is .unauthorized")
      case .poweredOff:
        print("central.state is .poweredOff")
      case .poweredOn:
        print("central.state is .poweredOn")
        //centralManager.scanForPeripherals(withServices: [heartRateServiceCBUUID])
        centralManager.scanForPeripherals(withServices: nil)
      

    }
  }
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    print(peripheral)
    let device = peripheral.identifier
    if device == myUuid {
      heartRatePeripheral = peripheral
      centralManager.stopScan()
      centralManager.connect(peripheral)
    }
  }
  
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    print("Conect")
    heartRatePeripheral.discoverServices(nil)
    heartRatePeripheral.delegate =  self
    //heartRatePeripheral.discoverServices ([heartRateServiceCBUUID])
    
    
  }
}

extension HRMViewController: CBPeripheralDelegate {

//  И так, мы подключились к устройству, давайте с ним что-нибудь сделаем. Ранее я упоминал про сервисы и характеристики, про значения которые они содержат, вот что нам нужно. Теперь у нас есть устройство, оно подключено и мы можем получить его сервисы, вызвав peripheral.discoverServices.
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    
    guard let services = peripheral.services else { return }

    for service in services {
      peripheral.discoverCharacteristics(nil, for: service)
      
    }
    
  }
  
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                  error: Error?) {
    
    
    guard let characteristics = service.characteristics else { return }
  
    for characteristic in characteristics {
      peripheral.readValue(for: characteristic)
      
      if characteristic.properties.contains(.notify)  {
        
        peripheral.setNotifyValue(true, for: characteristic)
        
      }
     
      
      print("Characteristic = \(characteristic.uuid.uuidString)")
//      //peripheral.setNotifyValue(true, for: self.characteristic)
//      peripheral.readValue(for: self.characteristic)
      
      if (characteristic.uuid.uuidString == characterisctic4.uuidString) {
        print("Have information characteristic1")
        peripheral.readValue(for: characteristic)
        
      }
      
//      if (characteristic.uuid.uuidString == versionID.uuidString) {
//         print("Have information version")
//       }
      
//      if (characteristic.uuid.uuidString == uknown.uuidString) {
//         print("Have information unknown \(characteristic)")
//         peripheral.readValue(for: characteristic)
//         peripheral.setNotifyValue(true, for: characteristic)
//       }
      
      
      if characteristic.properties.contains(.read) {
        print("\(characteristic.uuid): properties contains .read")
        peripheral.readValue(for: characteristic)
      }
      if characteristic.properties.contains(.notify) {
        print("\(characteristic.uuid): properties contains .notify")
      }
    }
  }
  
  
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                  error: Error?) {
    if characteristic.uuid.uuidString == "6E400005-B5A3-F393-E0A9-E50E24DCCA9E" {
      let parseData = parseStepsFromData(data: characteristic.value!)
      print(parseData)
      let parseString = String(data: characteristic.value!, encoding: .utf8)
      print(parseString)
    }
    if characteristic.uuid.uuidString == "2A27"{
      
      let parseData = parseStepsFromData(data: characteristic.value!)
      print(parseData)
      let parseString = String(data: characteristic.value!, encoding: .utf8)
      print(parseString)
    }
    if characteristic.uuid.uuidString == "2A19"{
      
     // let parseData = parseStepsFromData(data: characteristic.value!)
     // print(parseData)
      let parseString = String(data: characteristic.value!, encoding: .utf8)
      print(parseString)
    }
 
    
    //let steps = parseStepsFromData(data: characteristic.value!)
//    print("steps = \(steps)")
    //let characteristic1 = parseStepsFromData(data: characteristic.value!)
    print("Value = \(characteristic.value) \(characteristic.uuid.uuidString)" )
    
    //print("characteristic.uuid =  \(characteristic.uuid.uuidString)")
   
//    switch characteristic.uuid {
//    case battery:
//      print("Info: \(String(describing: characteristic.value))")
//
//    case uknown:
//      print( characteristic.value)
//      //let steps = parseStepsFromData(data: characteristic.value ?? Data())
//      //print("steps = \(steps)")
//
//    default:
//      print("Epmty")
//      break
//    }
    
//    switch characteristic.uuid {
//      case bodySensorLocationCharacteristicCBUUID:
//        print(characteristic.value ?? "no value")
//      default:
//        print("Unhandled Characteristic UUID: \(characteristic.uuid)")
//    }
  }


      private func parseStepsFromData(data: Data) -> UInt32 {
          return UInt32((data[1] & 0xFF)) + (UInt32(data[2]) << 8) + (UInt32(data[3]) << 16)
      }
  
}
