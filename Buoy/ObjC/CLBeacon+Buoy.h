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

#import <CoreLocation/CoreLocation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, kBuoyUnitType) {
    kBuoyUnitTypeMeters,
    kBuoyUnitTypeFeet,
    kBuoyUnitTypeYards
};

@interface CLBeacon (Buoy)

#pragma mark - String Formats
/**
 *  Returns a string formatted like so: 0.5 m or 1.64 ft
 *
 *  @param type kBuoyUnitType
 *
 *  @return NSString
 */
- (NSString *)accuracyStringWithUnitType:(kBuoyUnitType)type;

/**
 *  Returns the major number in string format.
 *
 *  @return NSString
 */
- (NSString *)majorString;

/**
 *  Returns the minor number in string format.
 *
 *  @return NSString
 */
- (NSString *)minorString;


#pragma mark - Distance Float
/**
 *  Returns the accuracy of the beacon using a given unit type.
 *
 *  @param type kBuoyUnitType
 *
 *  @return CGFloat
 */
- (CGFloat)accuracyWithUnitType:(kBuoyUnitType)type;


#pragma mark - Key for BUOY
/**
 *  Returns the identifier used by the BUOYListener to handle notifications/dates for each beacon.
 *
 *  @return NSString
 */
- (NSString *)buoyIdentifier;

@end