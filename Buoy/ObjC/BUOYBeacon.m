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

#import "BUOYBeacon.h"

NSString * const kBUOYDeviceBeaconIdentifier = @"com.BUOY.BeaconRegionIdentifier";

@interface BUOYBeacon() <CBPeripheralManagerDelegate>
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@end

@implementation BUOYBeacon

#pragma mark - Singleton
+ (instancetype)deviceBeacon {
	static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}


#pragma mark - Init
- (instancetype)init {
    if (self = [super init]) {
        
    }
    
    return self;
}


#pragma mark - Create Beacon
- (void)setWithProximityUUID:(NSUUID *)uuid major:(NSNumber *)major minor:(NSNumber *)minor identifier:(NSString *)identifier {
    // Set Up
    self.proximityUUID = uuid ? uuid : [NSUUID UUID];
    self.major = major ? major : @1;
    self.minor = minor ? minor : @1;
    self.identifier = identifier ? identifier : kBUOYDeviceBeaconIdentifier;
    
    // Create Region
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.proximityUUID major:[self.major integerValue] minor:[self.minor integerValue] identifier:self.identifier];
}

#pragma mark - Transmitting
- (void)startTransmitting {
    if (!self.proximityUUID) {
        NSLog(@"Buoy: Error - Must call setWithProximityUUID:major:minor:identifier before advertising as a periphery.");
        return;
    }
    
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
}

- (void)stopTransmitting {
    self.peripheralManager = nil;
}


#pragma mark - Core Bluetooth
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        [peripheral startAdvertising:[self.beaconRegion peripheralDataWithMeasuredPower:nil]];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        [peripheral stopAdvertising];
    }
}

@end