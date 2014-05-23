//
//  BUOYViewController.m
//  Buoy
//
//  Created by Ben Gordon on 5/23/14.
//  Copyright (c) 2014 intermark. All rights reserved.
//

#import "BUOYViewController.h"
#import "BUOYListener.h"

@interface BUOYViewController ()

@end

@implementation BUOYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSArray *uuids = @[[[NSUUID alloc] initWithUUIDString:@"A172A1F0-E28C-11E3-8B68-0800200C9A66"]];
    
    [[BUOYListener defaultListener] listenForBeaconsWithProximityUUIDs:uuids];
    
    __weak typeof(self) wSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:kBUOYDidFindBeaconNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        if (note.userInfo[kBUOYBeacon]) {
            CLBeacon *beacon = note.userInfo[kBUOYBeacon];
            NSLog(@"%@", [beacon accuracyStringWithDistanceType:kBuoyDistanceTypeFeet]);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
