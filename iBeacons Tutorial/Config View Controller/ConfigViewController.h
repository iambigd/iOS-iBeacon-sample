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

//beacon
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) NSDictionary *beaconPeripheralData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;

//UI
@property (weak, nonatomic) IBOutlet UITextField *uuidText;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


- (IBAction)transmitBeaconBtnClick:(UIButton *)sender;
- (IBAction)generateUUIDBtnClick:(UIButton *)sender;

@end
