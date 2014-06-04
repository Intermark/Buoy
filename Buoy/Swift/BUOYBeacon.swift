//
//  BUOYBeacon.swift
//  Buoy-Swift
//
//  Created by Ben Gordon on 6/3/14.
//  Copyright (c) 2014 intermarkinteractive. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation

let kBUOYDeviceBeaconIdentifier = "com.BUOY.BeaconRegionIdentifier"
var transmitter: BUOYBeacon? = nil

class BUOYBeacon: NSObject, CBPeripheralManagerDelegate {
    // Properties
    var manager: CBPeripheralManager
    var beaconRegion: CLBeaconRegion
    
    
    // Singleton Beacon
    class func deviceBeacon() -> BUOYBeacon {
        if !transmitter {
            transmitter = BUOYBeacon()
        }
        
        return transmitter!
    }
    
    
    // Init
    init()  {
        self.manager = CBPeripheralManager()
        self.beaconRegion = CLBeaconRegion()
        super.init()
    }
    
    
    // Set Up
    func setUpBeacon(proximityUUID uuid:NSUUID?, major M:CLBeaconMajorValue?, minor m:CLBeaconMinorValue?, identifier i:String?) {
        self.beaconRegion = CLBeaconRegion(proximityUUID: uuid ? uuid : NSUUID(), major: M!, minor: m!, identifier: i ? i : kBUOYDeviceBeaconIdentifier)
        println("\(self.beaconRegion.proximityUUID.UUIDString)")
    }
    
    
    // Transmitting
    func startTransmitting() {
        self.manager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func stopTransmitting() {
        self.manager.delegate = nil
    }
    
    
    // CBPeripheralManager Delegate
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        if peripheral.state == CBPeripheralManagerState.PoweredOn {
            self.manager.startAdvertising(self.beaconRegion.peripheralDataWithMeasuredPower(nil))
        }
        else if peripheral.state == CBPeripheralManagerState.PoweredOff {
            self.manager.stopAdvertising()
        }
    }
}