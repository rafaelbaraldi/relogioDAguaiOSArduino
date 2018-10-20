//
//  ListTableViewController.h
//  testArduino
//
//  Created by Rafael Baraldi on 29/09/2018.
//  Copyright © 2018 Rafael BAraldi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray<CBPeripheral*>* lista;
@property (strong, nonatomic) CBCentralManager* centrallManager;

@end

@interface WaterCell : UITableViewCell

@end

NS_ASSUME_NONNULL_END
