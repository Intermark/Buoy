//
//  BUOYDevice.m
//  Buoy
//
//  Created by Ben Gordon on 5/26/14.
//  Copyright (c) 2014 intermark. All rights reserved.
//

#import "BUOYDevice.h"

NSString * const kBUOYDeviceBeaconIdentifier = @"kBUOYDeviceBeaconIdentifier";

@interface BUOYDevice() <CBPeripheralManagerDelegate>
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@end

@implementation BUOYDevice

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