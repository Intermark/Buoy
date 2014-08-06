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

#import "BUOYListener.h"

// Constant Strings
NSString * const kBUOYBeaconRangeIdentifier = @"com.BUOYBeacon.Region";
NSString * const kBUOYDidFindBeaconNotification = @"kBUOYDidFindBeaconNotification";
NSString * const kBUOYBeacon = @"kBUOYBeacon";
NSTimeInterval const kBUOYDefaultTimeInterval = 0;


// Interface
@interface BUOYListener() <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableDictionary *beaconRegions;

// Listening
@property (nonatomic) BOOL isListening;
@property (nonatomic) NSTimeInterval beaconInterval;
@property (nonatomic, strong) NSMutableDictionary *seenBeacons;
@end


// Implementation
@implementation BUOYListener

#pragma mark - Singleton
+ (instancetype)defaultListener {
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
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        self.beaconInterval = kBUOYDefaultTimeInterval;
        self.beaconRegions = [NSMutableDictionary dictionary];
        self.seenBeacons = [NSMutableDictionary dictionary];
        if ([self.locationManager respondsToSelector:NSSelectorFromString(@"requestAlwaysAuthorization")]) {
            [self.locationManager performSelector:NSSelectorFromString(@"requestAlwaysAuthorization") withObject:nil afterDelay:0];
        }
    }
    
    return self;
}


#pragma mark - Start/Stop Listening
- (void)listenForBeaconsWithProximityUUIDs:(NSArray *)proximityIds {
    // Register for region monitoring
    for (NSUUID *proximityId in proximityIds) {
        // Create the beacon region tohv be monitored.
        CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityId identifier:kBUOYBeaconRangeIdentifier];
        beaconRegion.notifyEntryStateOnDisplay = YES;
        
        // Register the beacon region with the location manager.
        [self.locationManager startMonitoringForRegion:beaconRegion];
        [self.locationManager requestStateForRegion:beaconRegion];
        [self.beaconRegions setObject:beaconRegion forKey:proximityId.UUIDString];
    }
}

- (void)listenForBeaconsWithProximityUUIDs:(NSArray *)proximityIds notificationInterval:(NSTimeInterval)seconds {
    self.beaconInterval = seconds;
    [self listenForBeaconsWithProximityUUIDs:proximityIds];
}

- (void)stopListening {
    for (CLBeaconRegion *region in self.beaconRegions) {
        [self.locationManager stopMonitoringForRegion:region];
    }
}

- (void)stopListeningForBeaconsWithProximityUUID:(NSUUID *)uuid {
    if (self.beaconRegions[uuid.UUIDString]) {
        [self.locationManager stopMonitoringForRegion:self.beaconRegions[uuid.UUIDString]];
        [self.beaconRegions removeObjectForKey:uuid.UUIDString];
    }
}


#pragma mark - Notifications
- (void)setNotificationInterval:(NSTimeInterval)seconds {
    self.beaconInterval = seconds;
}

- (void)sendNotificationWithBeacon:(CLBeacon *)beacon {
    if ([self shouldSendNotificationForBeacon:beacon]) {
        [self addBeaconToSeenBeaconsDictionary:beacon];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBUOYDidFindBeaconNotification object:nil userInfo:@{kBUOYBeacon:beacon}];
    }
}

- (BOOL)shouldSendNotificationForBeacon:(CLBeacon *)beacon {
    if (self.seenBeacons[[beacon buoyIdentifier]]) {
        return abs([[NSDate date] timeIntervalSinceDate:self.seenBeacons[[beacon buoyIdentifier]]]) >= self.beaconInterval;
    }
    
    return YES;
}

- (void)addBeaconToSeenBeaconsDictionary:(CLBeacon *)beacon {
    [self.seenBeacons setObject:[NSDate date] forKey:[beacon buoyIdentifier]];
}


#pragma mark - Location Manager Delegate
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    // Notify for each Beacon found
    for (NSInteger b = 0; b < beacons.count; b++) {
        [self sendNotificationWithBeacon:beacons[b]];
    }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]] && state == CLRegionStateInside) {
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

@end
