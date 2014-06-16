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

import UIKit
import CoreLocation

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set Up
        var uuid = NSUUID(UUIDString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6")
        
        // Listen
        self.listenForBeaconsWithUUID(uuid)
        
        // Transmit
       // self.transmitAsBeaconWithUUID(uuid)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Listen for Beacons
    func listenForBeaconsWithUUID(uuid: NSUUID) {
        self.registerNotifications()
        BUOYListener.defaultListener().listenForBeacons([uuid], interval:2)
    }
    
    
    // Transmit as iBeacon
    func transmitAsBeaconWithUUID(uuid: NSUUID) {
        BUOYBeacon.deviceBeacon().setUpBeacon(proximityUUID: uuid, major: 1001, minor: 1000, identifier: "HelloWorld")
        BUOYBeacon.deviceBeacon().startTransmitting()
    }

    
    // Listening Notifications
    func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector.convertFromStringLiteral("handleNotification:"), name: kBUOYDidFindBeaconNotification, object: nil)
    }
    
    func handleNotification(note: NSNotification) {
        if let b = note.userInfo[kBUOYBeacon] as? CLBeacon {
            println(b.buoyIdentifier())
        }
    }

}

