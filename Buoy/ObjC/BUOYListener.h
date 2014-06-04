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

#import <Foundation/Foundation.h>
#import "CLBeacon+Buoy.h"
@import CoreLocation;

// Notification
extern NSString * const kBUOYDidFindBeaconNotification;
extern NSString * const kBUOYBeacon;

@interface BUOYListener : NSObject

#pragma mark - Singleton
/**
 *  Singleton listener. Use this to register and listen for iBeacons across your app.
 *
 *  @return BUOYListener Singleton
 */
+ (instancetype)defaultListener;


#pragma mark - Start Listening
/**
 *  Tells the listener to start listening for iBeacons with an array of proximity UUIDs to listen for. The default notification interval of 0 seconds is used.
 *
 *  @param proximityIds NSArray of NSUUIDs
 */
- (void)listenForBeaconsWithProximityUUIDs:(NSArray *)proximityIds;

/**
 *  Tells the listener to start listening for iBeacons with an array of proximity UUIDs to listen for. The notification interval sets the number of seconds to wait after seeing a beacon before notifying again.
 *
 *  @param proximityIds NSArray
 *  @param seconds      NSTimeInterval
 */
- (void)listenForBeaconsWithProximityUUIDs:(NSArray *)proximityIds notificationInterval:(NSTimeInterval)seconds;


#pragma mark - Stop Listening
/**
 *  Stop listening for all iBeacon Proximity UUIDs
 */
- (void)stopListening;

/**
 *  Stop listening for beacons with a certain Proximity UUID
 *
 *  @param uuid NSUUID
 */
- (void)stopListeningForBeaconsWithProximityUUID:(NSUUID *)uuid;


#pragma mark - Notification
/**
 *  Sets the notification interval duration for how often the Listener should update the app about each new beacon found.
 *
 *  @param seconds NSTimeInterval
 */
- (void)setNotificationInterval:(NSTimeInterval)seconds;

@end
