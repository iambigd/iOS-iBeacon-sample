//
//  ConfigViewController.h
//  iBeacons Tutorial
//
//  Created by PoloMac on 2014/5/9.
//  Copyright (c) 2014年 PoloMac. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>

@interface ConfigViewController : UIViewController<CBPeripheralManagerDelegate>
{
    bool beaconStartOnOrNot;
}

//beacon
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) NSDictionary *beaconPeripheralData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;

//UI
@property (weak, nonatomic) IBOutlet UITextField *uuidText;
@property (weak, nonatomic) IBOutlet UITextField *majorText;
@property (weak, nonatomic) IBOutlet UITextField *minorText;


@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;



- (IBAction)transmitBeaconBtnClick:(UIButton *)sender;
- (IBAction)generateUUIDBtnClick:(UIButton *)sender;

@end
