#import "TrackViewController.h"

@interface TrackViewController ()

@end

@implementation TrackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    
    //need to add 'CLLocationManagerDelegate' @interface TrackViewController
    self.locationManager.delegate = self;
    
    //init beacon region
    [self initRegion];
    
    //testing Without Entering or Exiting the Region
    //manual to call didStartMonitoringForRegion
    [self locationManager:self.locationManager didStartMonitoringForRegion:self.beaconRegion];
}

- (void)initRegion {
    
    NSLog(@"init Beacon");

    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"23542266-18D1-4FE4-B4A1-23F8195B9D39"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.devfright.myRegion"];
    
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager requestStateForRegion:self.beaconRegion];
    
}

/*
 *location manager event delegate
 */

//for testing

- (void)requestStateForRegion:(CLRegion *)region
{
    NSLog(@"requestStateForRegion");
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"didStartMonitoringForRegion");

    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
   
    
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    NSLog(@"Beacon Found");
    
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Left Region");
    
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    self.beaconFoundLabel.text = @"No";
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    NSLog(@"didRangeBeacons");
    
    //get one beacon
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons lastObject];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end