//
//  BUOYViewController.m
//  Buoy
//
//  Created by Ben Gordon on 5/23/14.
//  Copyright (c) 2014 intermark. All rights reserved.
//

#import "BUOYViewController.h"
#import "BUOYListener.h"
#import "BUOYDevice.h"

NSString * const kDemoUUIDString = @"A172A1F0-E28C-11E3-8B68-0800200C9A66";

@interface BUOYViewController ()

@end

@implementation BUOYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSArray *uuids = @[[[NSUUID alloc] initWithUUIDString:kDemoUUIDString]];
    
    
    // Listen for iBeacons
    [[BUOYListener defaultListener] listenForBeaconsWithProximityUUIDs:uuids];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kBUOYDidFindBeaconNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        if (note.userInfo[kBUOYBeacon]) {
            CLBeacon *beacon = note.userInfo[kBUOYBeacon];
            NSLog(@"%@", [beacon accuracyStringWithDistanceType:kBuoyDistanceTypeFeet]);
        }
    }];
    
    
    // Transmit as iBeacon
    [[BUOYDevice deviceBeacon] setWithProximityUUID:[[NSUUID alloc] initWithUUIDString:kDemoUUIDString]
                                              major:@10001
                                              minor:@69
                                         identifier:nil];
    [[BUOYDevice deviceBeacon] startTransmitting];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
