//
//  BUOYViewController.m
//  Buoy
//
//  Created by Ben Gordon on 5/23/14.
//  Copyright (c) 2014 intermark. All rights reserved.
//

#import "BUOYViewController.h"
#import "BUOY.h"

NSString * const kDemoUUIDString = @"34C41400-E285-11E3-8B68-0800200C9A66";

@interface BUOYViewController ()

@end

@implementation BUOYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSArray *uuids = @[[[NSUUID alloc] initWithUUIDString:kDemoUUIDString]];
    
    
    // Listen for iBeacons
    [[BUOYListener defaultListener] listenForBeaconsWithProximityUUIDs:uuids notificationInterval:5];
    
    // Handle Beacon Notification
    [[NSNotificationCenter defaultCenter] addObserverForName:kBUOYDidFindBeaconNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"%@", note.userInfo);
        if (note.userInfo[kBUOYBeacon]) {
            CLBeacon *beacon = note.userInfo[kBUOYBeacon];
            NSLog(@"%@", [beacon accuracyStringWithUnitType:kBuoyUnitTypeFeet]);
        }
    }];
    
    /*
    // Transmit as iBeacon
    [[BUOYBeacon deviceBeacon] setWithProximityUUID:[NSUUID UUID]
                                              major:@10001
                                              minor:@69
                                         identifier:nil];
    [[BUOYBeacon deviceBeacon] startTransmitting];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
