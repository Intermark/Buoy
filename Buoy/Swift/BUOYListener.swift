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
import CoreLocation

let kBUOYRegionIdentifier = "com.BUOY.region.identifier"
let kBUOYDidFindBeaconNotification = "kBUOYDidFindBeaconNotification"
let kBUOYBeacon = "kBUOYBeacon"
var listener: BUOYListener? = nil

class BUOYListener: NSObject, CLLocationManagerDelegate {
    // Properties
    var manager: CLLocationManager
    var beaconRegions: [String : CLBeaconRegion]
    var interval: NSTimeInterval? = 0
    var seenBeacons: [String:NSDate]
    

    // Singleton Listener
    class func defaultListener() -> BUOYListener {
        if (listener == nil) {
            listener = BUOYListener()
        }
        return listener!
    }
    

    // Init
    override init(){
        self.manager = CLLocationManager()
        self.beaconRegions = Dictionary()
        self.seenBeacons = Dictionary()
        super.init()
        self.manager.delegate = self
        self.manager.requestAlwaysAuthorization()
    }
    
    
    // Start Listening
    func listenForBeacons(uuids: [NSUUID]) {
        for uuid in uuids {
            var region = CLBeaconRegion(proximityUUID: uuid, identifier: "\(kBUOYRegionIdentifier)-\(uuid)")
            region.notifyEntryStateOnDisplay = true
            self.manager.startMonitoringForRegion(region)
            self.manager.requestStateForRegion(region)
            self.beaconRegions[uuid.UUIDString] = region
        }
    }
    
    func listenForBeacons(uuids: [NSUUID], interval: NSTimeInterval) {
        self.interval = interval
        self.listenForBeacons(uuids)
    }
    
    
    // Stop Listening
    func stopListening() {
        for (uuid, region) in self.beaconRegions {
            self.manager.stopRangingBeaconsInRegion(region)
            self.manager.stopMonitoringForRegion(region)
            self.beaconRegions[uuid] = nil
        }
    }
    
    func stopListening(uuid: String) {
        if let beaconRegion = self.beaconRegions[uuid] {
            self.manager.stopRangingBeaconsInRegion(beaconRegion)
            self.manager.stopMonitoringForRegion(beaconRegion)
            self.beaconRegions[uuid] = nil
        }
    }
    
    
    // Notifications
    func setNotificationInterval(interval: NSTimeInterval) {
        self.interval = interval
    }
    
    func sendNotification(beacon: CLBeacon) {
        if self.shouldSendNotification(beacon) {
            self.addBeaconToSeenBeacons(beacon)
            NSNotificationCenter.defaultCenter().postNotificationName(kBUOYDidFindBeaconNotification, object:nil, userInfo:[kBUOYBeacon:beacon])
        }
    }
    
    func shouldSendNotification(beacon: CLBeacon) -> Bool {
        if let date = self.seenBeacons[beacon.buoyIdentifier()] {
            return abs(date.timeIntervalSinceNow) >= self.interval
        }
        
        return true
    }
    
    func addBeaconToSeenBeacons(beacon: CLBeacon) {
        self.seenBeacons[beacon.buoyIdentifier()] = NSDate()
    }
    
    
    // Location Manager Delegate
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        for beacon : AnyObject in beacons {
            if beacon is CLBeacon {
                self.sendNotification(beacon as! CLBeacon)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
        if region.isKindOfClass(CLBeaconRegion.self) && state == CLRegionState.Inside {
            self.manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        }
        else if region.isKindOfClass(CLBeaconRegion.self) && state == CLRegionState.Outside {
            self.manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        }
    }
}