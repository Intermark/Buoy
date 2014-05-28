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

#import "CLBeacon+Buoy.h"

@implementation CLBeacon (Buoy)

#pragma mark - String Formats
- (NSString *)accuracyStringWithDistanceType:(kBuoyDistanceType)type {
    // Create Values
    NSString *unitString = @"";

    switch (type) {
        case kBuoyDistanceTypeMeters:
            unitString = @"m";
            break;
        case kBuoyDistanceTypeFeet:
            unitString = @"ft";
            break;
        case kBuoyDistanceTypeYards:
            unitString = @"yd";
            break;
        default:
            break;
    }
    
    // Create Distance
    return self.accuracy >= 0 ? [NSString stringWithFormat:@"%0.2f %@", [self accuracyWithDistanceType:type], unitString] : @"N/A";
}

- (NSString *)majorString {
    return [self.major stringValue];
}

- (NSString *)minorString {
    return [self.minor stringValue];
}


#pragma mark - Distance Float
- (CGFloat)accuracyWithDistanceType:(kBuoyDistanceType)type {
    CGFloat distanceModifier = 1.0f;
    switch (type) {
        case kBuoyDistanceTypeFeet:
            distanceModifier = 3.28084f;
            break;
        case kBuoyDistanceTypeYards:
            distanceModifier = 1.09361f;
            break;
        default:
            break;
    }
    
    return self.accuracy*distanceModifier;
}


#pragma mark - Key for BUOY
- (NSString *)buoyIdentifier {
    return [NSString stringWithFormat:@"Buoy:%@:%@:%@", self.proximityUUID.UUIDString, self.major, self.minor];
}

@end
