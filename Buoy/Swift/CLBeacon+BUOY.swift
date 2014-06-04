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