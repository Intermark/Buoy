![banner](/Resources/banner.png)

# Buoy

**Buoy** is a simple iBeacon listener/manager that handles all of the hard stuff for you, matey!

Now written in [Swift](#swift) as well!

#### Requirements

* iOS 7+

## Instsallation

Use [Cocoapods](http://www.cocoapods.org) to install Buoy.

`pod 'Buoy'`

## Table of Contents

* [Listen for iBeacons](#listen-for-ibeacons)
  * [Set Up](#set-up)
  * [Handle Finding iBeacons](#handle-finding-ibeacons)
  * [Notification Interval](#notification-interval)
  * [Stop Listening](#stop-listening)
  * [Buoy CLBeacon Methods](#buoy-clbeacon-methods)
* [Turn your iPhone/iPad into an iBeacon](#turn-your-iphoneipad-into-an-ibeacon)
* [Swift](#swift)
* [License](#license)

## Listen for iBeacons

To begin, `#import <BUOY.h>` in the classes you want to use the Listener and it's notifications in. Buoy works by listening for iBeacons and broadcasting NSNotifications through the `[NSNotificationCenter defaultCenter]` so any of your classes can key in on these and do something with the data.

#### Set Up

Before you can get a notification from the BUOYListener, you need to set it up. You will need a list of the different `Proximity UUIDs` you want to listen for. These are specific to the iBeacons themselves, and you can configure your different iBeacons to have new UUIDs with most major kinds. Here's how you set up the Listener.

```objc
// AppDelegate.m

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ...

    NSArray *uuids = @[[[NSUUID alloc] initWithUUIDString:@"00000000-0000-0000-0000-000000000000"],[NSUUID alloc] initWithUUIDString:@"11111111-1111-1111-1111-111111111111"]];
    [[BUOYListener defaultListener] listenForBeaconsWithProximityUUIDs:uuids];

    ...
}
```

#### Handle Finding iBeacons

When the Listener finds an iBeacon it will broadcast a notification with that beacon in the `notification userInfo` dictionary object. Found beacons are of the type `CLBeacon`.

```objc
// Set Up Notifications

[[NSNotificationCenter defaultCenter] addObserverForName:kBUOYDidFindBeaconNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        if (note.userInfo[kBUOYBeacon]) {
            CLBeacon *beacon = note.userInfo[kBUOYBeacon];
            // Do something here!
        }
}];
```

#### Notification Interval

Because iBeacons have advertising intervals that can sometimes fire 20+ times per second, you may not want to receive notifications constantly in your app. So you can set the notification interval that fires after `x` number of seconds for each beacon found. The listener keeps track of the time it sends a notification for each specific beacon, then whenever it sees that beacon again, it will check that time against the current time then send a new notification if necessary.

The default interval is `0 seconds`.

```objc
// Set the notification interval to 5 seconds.
[[BUOYListener defaultListener] setNotificationInterval:5];
```

#### Stop Listening

If, for any reason, you'd like to stop listening, there are a couple methods which can handle doing this.

```objc
// Stop listening to one Proximity UUID
NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"00000000-0000-0000-0000-000000000000"];
[[BUOYListener defaultListener] stopListeningForBeaconsWithProximityUUID:uuid];

// Stop listening to all Proximity UUIDs
[[BUOYListener defaultListener] stopListening];
```

#### Buoy CLBeacon Methods

Each `CLBeacon` object has a few properties that you can key off to handle internal logic specific for your app.

* `major` - NSNumber
* `minor` - NSNumber
* `proximityUUID` - NSUUID
* `accuracy` - CLLocationAccuracy (meters)
* `proximity` - CLProximity (enum)
* `rssi` - NSInteger (dB of signal strength)

Beyond these base properties, the included `CLBeacon+Buoy.{h,m}` category class has some included methods to make your life a little easier as well.

**Beacon Accuracy String**

```objc
CLBeacon *someBeacon;
NSString *accuracy = [someBeacon accuracyStringWithDistanceType:kBuoyUnitTypeFeet];
```

This uses the following enum for `kBuoyUnitType`

* `kBuoyUnitTypeMeters`
* `kBuoyUnitTypeFeet`
* `kBuoyUnitTypeYards`

**Major/Minor**

```objc
NSString *M = [someBeacon majorString];
NSString *m = [someBeacon minorString];
```

## Turn your iPhone/iPad into an iBeacon

Beyond just listening, Buoy can turn your iPhone into an iBeacon as well. To begin, you need to call a method on the other singleton included in Buoy, `[BUOYBeacon deviceBeacon]`.

```objc
[[BUOYBeacon deviceBeacon] setWithProximityUUID:[NSUUID UUID]
                                          major:@10001
                                          minor:@69
                                     identifier:@"com.someIdentifier.Id"];
```

This sets up the properties necessary for an iBeacon, but does not start transmitting anything. You just need to call the following method when you're ready to transmit.

`[[BUOYBeacon deviceBeacon] startTransmitting]`

And then when you're ready to stop transmitting, you just call the opposite.

`[[BUOYBeacon deviceBeacon] stopTransmitting]`

## Swift

As an awesome addition, and learning tool - this code has been ported to [Swift](https://developer.apple.com/swift/). To get this code working on your device, you will need to add one key to your `Info.plist` file.

```
NSLocationAlwaysUsageDescription : "Some Description of why you want to take location"
```

This is necessary starting in iOS 8+.

With that said, all of the Swift classes can be found under the [/Buoy/Swift](/Buoy/Swift) directory, and the Example project can be found under [/Examples/Buoy-Swift](/Examples/Buoy-Swift).

## License

This project is licensed under the standard MIT License, which can be found [here](/LICENSE.md)
