#import "TrackViewController.h"

@interface TrackViewController ()

@end

@implementation TrackViewController

- (void)viewDidLoad
{
    
     NSLog(@"init tracker in viewDidLoad");
    
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    
    //need to add 'CLLocationManagerDelegate' @interface TrackViewController
    self.locationManager.delegate = self;
    
    //init beacon region
    [self initRegion];
    
    //testing Without Entering or Exiting the Region
    //manual to call didStartMonitoringForRegion
//    [self locationManager:self.locationManager didStartMonitoringForRegion:self.beaconRegion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initRegion {
    
    NSLog(@"init Beacon");

    //This beacon's UUID is from Beacons vender
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
    
    //Create the beacon region to be monitored.
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"x-beacon"];
    
//    self.beaconRegion.notifyOnEntry = YES;
//    self.beaconRegion.notifyOnExit = YES;
//    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    
    //Create the beacon region to be monitored.
    //Tell location manager to start monitoring for the beacon region
    //it will trigger 'didStartMonitoringForRegion' delegate
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
     NSLog(@"init Beacon done");
}

/*
 *location manager event delegate
 */



- (void)requestStateForRegion:(CLRegion *)region
{
    NSLog(@"requestStateForRegion");
}

//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
//{
//    NSLog(@"didChangeAuthorizationStatus");
//    
//}

//for manaul testing
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"didStartMonitoringForRegion");

    //it will trigger 'didDetermineState' delegate
    [self.locationManager requestStateForRegion:self.beaconRegion];
    
    //it will trigger 'startRangingBeaconsInRegion' delegate
//    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];

}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    NSLog(@"Enter Beacons Region");
    
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Exit Beacons Region");
    
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    self.beaconFoundLabel.text = @"No";
}

- (void) locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"didDetermineState");
    switch (state) {
        case CLRegionStateInside:
             NSLog(@"Region State Inside");
            [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
            
            break;
        case CLRegionStateOutside:
            
             NSLog(@"Region State Outside");
            
        case CLRegionStateUnknown:
             NSLog(@"Region State Unknown");
            
        default:
            // stop ranging beacons, etc
            NSLog(@"Region unknown");
    }
}

//Determining the relative distance between a beacon and a device
-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    NSLog(@"didRangeBeacons");
    
    int beaconsCount = beacons.count ;
    if (beaconsCount == 0) {
        NSLog(@"No beacons found nearby.");
    }else{
        
         NSLog(@"Beacons are found: %d" ,beaconsCount);
        
        //
        //get one beacon
        //
        
        CLBeacon *beacon = [[CLBeacon alloc] init];
        beacon = [beacons lastObject];
        
        //
        //beacon properties data-binding
        //
        self.beaconFoundLabel.text = @"Yes";
        
        //beacon infomation (These will change depending on what the transmitter is sending.)
        self.proximityUUIDLabel.text = beacon.proximityUUID.UUIDString;
        self.majorLabel.text = [NSString stringWithFormat:@"%@", beacon.major];
        self.minorLabel.text = [NSString stringWithFormat:@"%@", beacon.minor];
        
        self.accuracyLabel.text = [NSString stringWithFormat:@"%f", beacon.accuracy];
        
        //   The accuracy will constantly change depending on interference. The proximity provides 4 values. Unknown, immediate, near, far
        if (beacon.proximity == CLProximityUnknown) {
            self.distanceLabel.text = @"Unknown Proximity";
        } else if (beacon.proximity == CLProximityImmediate) {
            self.distanceLabel.text = @"Immediate";
        } else if (beacon.proximity == CLProximityNear) {
            self.distanceLabel.text = @"Near";
        } else if (beacon.proximity == CLProximityFar) {
            self.distanceLabel.text = @"Far";
        }
        
        //RSSI is the signal strength in decibels.
        self.rssiLabel.text = [NSString stringWithFormat:@"%i", beacon.rssi];
    }
    
   
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //Do nothing here, but enjoy ranging callbacks in background :-)
    NSLog(@"didUpdateToLocation");

}

@end