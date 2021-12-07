//
//  ContentView.swift
//  FindDevice
//
//  Created by slava on 06/12/2021.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel: Service = .init()
    @State private var didAppear = false

    var body: some View {

        MainView()
        
        
//            .onAppear {
//                guard didAppear == false else {
//                    return
//                }
//                didAppear = true
//                //viewModel.manager.connect(<#T##peripheral: CBPeripheral##CBPeripheral#>)
//      }
   }
}
