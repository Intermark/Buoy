//
//  CLBeacon+BUOY.swift
//  Buoy-Swift
//
//  Created by Ben Gordon on 6/3/14.
//  Copyright (c) 2014 intermarkinteractive. All rights reserved.
//

import Foundation
import CoreLocation

extension CLBeacon {
    // Unit Types
    enum BUOYUnitType {
        case Feet, Yards, Meters
    }
    
    // Buoy Identifier
    func buoyIdentifier() -> String {
        return "Buoy:\(self.proximityUUID.UUIDString):\(self.major):\(self.minor)"
    }
    
    // String Formats
    func majorString() -> String {
        return "\(self.major)"
    }
    
    func minorString() -> String {
        return "\(self.minor)"
    }
    
    func accuracyString(u: BUOYUnitType) -> String {
        let unit = self.unitTuple(u)
        return "\(self.accuracyWithUnits(u)) \(unit.0)"
    }
    
    // Distance
    func accuracyWithUnits(u: BUOYUnitType) -> Double {
        let unit = self.unitTuple(u)
        return self.accuracy * unit.1
    }
    
    // Helper
    func unitTuple(u: BUOYUnitType) -> (String, Double) {
        switch u {
            case BUOYUnitType.Feet:
                return ("ft", 3.28084)
            case BUOYUnitType.Yards:
                return ("yd", 1.09361)
            case BUOYUnitType.Meters:
                return ("m", 1.0)
        }
    }
}