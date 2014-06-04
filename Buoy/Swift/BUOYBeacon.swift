//  The MIT License (MIT)
//
//  Copyright (c) 2014 Intermark Interactive
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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