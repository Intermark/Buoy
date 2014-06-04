//
//  BUOYListener.swift
//  Buoy-Swift
//
//  Created by Ben Gordon on 6/3/14.
//  Copyright (c) 2014 intermarkinteractive. All rights reserved.
//

import Foundation
import CoreLocation

let kBUOYRegionIdentifier = "com.BUOY.region.identifier"
let kBUOYDidFindBeaconNotification = "kBUOYDidFindBeaconNotification"
let kBUOYBeacon = "kBUOYBeacon"
var listener: BUOYListener? = nil

class BUOYListener: NSObject, CLLocationManagerDelegate {
    // Properties
    var manager: CLLocationManager
    var beaconRegions: Dictionary<String, CLBeaconRegion>
    var interval: NSTimeInterval? = 0
    var seenBeacons: Dictionary<String, NSDate>
    
    
    // Singleton Listener
    class func defaultListener() -> BUOYListener {
        if !listener {
            listener = BUOYListener()
        }
        return listener!
    }
    

    // Init
    init(){
        self.manager = CLLocationManager()
        self.beaconRegions = Dictionary()
        self.seenBeacons = Dictionary()
        super.init()
        self.manager.delegate = self
        self.manager.requestAlwaysAuthorization()
    }
    
    
    // Start Listening
    func listenForBeacons(uuids: Array<NSUUID>) {
        for uuid in uuids {
            var region = CLBeaconRegion(proximityUUID: uuid, identifier: kBUOYRegionIdentifier)
            region.notifyEntryStateOnDisplay = true
            self.manager.startMonitoringForRegion(region)
            self.manager.requestStateForRegion(region)
            self.beaconRegions[uuid.UUIDString] = region
        }
    }
    
    func listenForBeacons(uuids: Array<NSUUID>, interval: NSTimeInterval) {
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
            NSNotificationCenter.defaultCenter().postNotificationName(kBUOYDidFindBeaconNotification, object: nil, userInfo: [kBUOYBeacon:beacon])
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
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: AnyObject[]!, inRegion region: CLBeaconRegion!) {
        for beacon : AnyObject in beacons {
            if beacon is CLBeacon {
                self.sendNotification(beacon as CLBeacon)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
        if region is CLBeaconRegion {
            if state == CLRegionState.Inside {
                self.manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
            }
            else if state == CLRegionState.Outside {
                self.manager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
            }
        }
    }
    
}