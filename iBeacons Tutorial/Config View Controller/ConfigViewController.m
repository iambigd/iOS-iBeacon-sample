

//模擬 beacon 發送器

#import "ConfigViewController.h"

@interface ConfigViewController ()

@end

@implementation ConfigViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   }




- (IBAction)generateUUIDBtnClick:(UIButton *)sender {
    NSLog(@"Click generate UUID button");
    
    //ios6 later
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSLog(@"new uuid: %@", uuid);
    
    self.uuidText.text = uuid;
    
    [self initBeacon];
    //[self setLabels];

}

- (IBAction)transmitBeaconBtnClick:(UIButton *)sender {
     NSLog(@"Click transmit button");
    
    // Get the beacon data to advertise
    self.beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    
    // Start the peripheral manager
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
}



-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    
    NSLog(@"peripheralManagerDidUpdateState run");

    
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Powered On: boardcasting....");
        
        self.statusLabel.text = @"Boardcasting NOW...";
        
        // Start broadcasting
        [self.peripheralManager startAdvertising:self.beaconPeripheralData];
        
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        
        NSLog(@"Powered Off");
        
        self.statusLabel.text = @"Bluetooth isn't on";
        
        
        // Bluetooth isn't on. Stop broadcasting
        [self.peripheralManager stopAdvertising];
        
        
    }else if (peripheral.state == CBPeripheralManagerStateUnsupported){
        
        self.statusLabel.text = @"DEVICE is not support";
         
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initBeacon {
    
    NSLog(@"beacon init");
    
    
    //check beaon is run or not?
    
    //模擬一個beacon的UUID
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[NSString stringWithFormat:@"%@",self.uuidText ]];
    
    //實體化一個 beaconRegion
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                major:1
                                                                minor:1
                                                           identifier:@"com.devfright.myRegion"];
}


@end