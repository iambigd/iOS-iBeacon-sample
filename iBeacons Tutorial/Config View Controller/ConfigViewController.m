

//模擬 beacon 發送器

#import "ConfigViewController.h"

@interface ConfigViewController ()

@end

@implementation ConfigViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //init
    beaconStartOnOrNot = false;
    
    self.uuidText.text = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
    self.majorText.text = @"1";
    self.minorText.text = @"1";
}


- (IBAction)generateUUIDBtnClick:(UIButton *)sender {
    NSLog(@"Click generate UUID button");
    
    //ios6 later
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSLog(@"new uuid: %@", uuid);
    
    self.uuidText.text = uuid;

}

- (IBAction)transmitBeaconBtnClick:(UIButton *)sender {
    
    NSLog(@"Click transmit button");
    
    if(!beaconStartOnOrNot){
        [self initBeacon];
    }else{
        [self stopBeacon];
    }
   
}


-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    
    NSLog(@"peripheralManagerDidUpdateState run");

    
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Powered On: boardcasting....");
        
        self.statusLabel.text = @"POWER ON";
        
        // Start broadcasting
        [self.peripheralManager startAdvertising:self.beaconPeripheralData];
        
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        
        NSLog(@"Powered Off");
        
        self.statusLabel.text = @"POWER OFF";
        
        
        // Bluetooth isn't on. Stop broadcasting
        [self.peripheralManager stopAdvertising];
        
        
    }else if (peripheral.state == CBPeripheralManagerStateUnsupported){
        
        self.statusLabel.text = @"DEVICE NOT SUPPORT";
         
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
// beacon transmitter
//

- (void)initBeacon {
    
    NSLog(@"start beacon advertising");
    
    
    //check beaon is run or not?
    
    //模擬一個beacon的UUID
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[NSString stringWithFormat:@"%@",self.uuidText ]];
    
    //實體化一個 beaconRegion
    int majorNum =[self.majorText.text intValue];
    int minorNum =[self.minorText.text intValue];

    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                major:majorNum
                                                                minor:minorNum
                                                           identifier:@"x-beacon"];
    
    // Get the beacon data to advertise
    self.beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    
    // Start the peripheral manager
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
    
    beaconStartOnOrNot = true;
  
    [ self.statusBtn setTitle:@"Stop Broadcasting" forState:UIControlStateNormal]; // To set the title
//    [ self.statusBtn setEnabled:NO]; // To toggle enabled / disabled
    
    
}

- (void)stopBeacon {

    NSLog(@"stop beacon advertising");

    //To stop transmitting
    [self.peripheralManager stopAdvertising];
    
    beaconStartOnOrNot = false;
    [ self.statusBtn setTitle:@"Start Broadcasting" forState:UIControlStateNormal]; // To set the title
    self.statusLabel.text = @"OFF";
}

@end