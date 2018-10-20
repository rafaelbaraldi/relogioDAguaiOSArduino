//
//  RelogioViewController.h
//  testArduino
//
//  Created by Rafael Baraldi on 29/09/2018.
//  Copyright © 2018 Rafael BAraldi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface RelogioViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *animationContentView;
@property (strong, nonatomic) CBPeripheral* btDevice;
@property (strong, nonatomic) CBCharacteristic* characteristc;

@end

NS_ASSUME_NONNULL_END
