//
//  LoadingViewController.m
//  testArduino
//
//  Created by Rafael Baraldi on 29/09/2018.
//  Copyright © 2018 Rafael BAraldi. All rights reserved.
//

#import "LoadingViewController.h"
#import <Lottie/Lottie.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ListTableViewController.h"
#import "RelogioViewController.h"

@interface LoadingViewController () <CBCentralManagerDelegate, CBPeripheralManagerDelegate, CBPeripheralDelegate>

@property (weak, nonatomic) IBOutlet UIView *loadingViewContainer;

@property (strong, nonatomic) NSMutableArray<CBPeripheral*>* lista;
@property (strong, nonatomic) CBCentralManager* centrallManager;
@property (strong, nonatomic) CBPeripheralManager* deviceManager;
@property (strong, nonatomic) CBCharacteristic* characteristc;
@property (strong, nonatomic) CBPeripheral* btDevice;
@property (strong, nonatomic) RelogioViewController* relogioController;

@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LOTAnimationView *animation = [LOTAnimationView animationNamed:@"loading"];
    CGRect frame = self.loadingViewContainer.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    animation.frame = frame;
    animation.loopAnimation = YES;
    animation.contentMode = UIViewContentModeScaleAspectFit;
    [self.loadingViewContainer addSubview:animation];
    [animation play];
    
    
    self.lista = [NSMutableArray new];
    
    self.centrallManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.deviceManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Relógio D'agua";
    
    [NSTimer scheduledTimerWithTimeInterval:6.0f repeats:NO block:^(NSTimer * _Nonnull timer) {
        for (CBPeripheral* bt in self.lista) {
            if ([bt.name isEqualToString:@"HMSoft"]) {
                self.btDevice = bt;
                self.relogioController.btDevice = bt;
                [self.centrallManager connectPeripheral:bt options:nil];
                return;
            }
        }
        [self performSegueWithIdentifier:@"showListSegue" sender:nil];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@",[advertisementData description]]);
    
    NSLog(@"%@",[NSString stringWithFormat:@"Discover:%@,RSSI:%@\n",[advertisementData objectForKey:@"kCBAdvDataLocalName"],RSSI]);
    NSLog(@"Discovered %@", peripheral.name);
    
    for (CBPeripheral* bt in self.lista) {
        if ([bt.name isEqualToString:peripheral.name]) {
            return;
        }
    }
    
    [self.lista addObject:peripheral];
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSLog(@"%@", peripheral.services);
    
    for (CBService* service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    NSLog(@"%@", service.characteristics);
    for (int i = 0; i < service.characteristics.count; i++) {
        self.characteristc = [service.characteristics objectAtIndex:i];
        self.relogioController.characteristc = self.characteristc;
        [peripheral setNotifyValue:YES forCharacteristic:self.characteristc];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (error) {
        NSLog(@"Error reading characteristics: %@", [error localizedDescription]);
        return;
    }
    
    if (characteristic.value != nil) {
        
        NSString* value = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        NSLog(@"%@", value);
        
        value = [value stringByReplacingOccurrencesOfString:@"mL" withString:@""];
        
        double ml = value.doubleValue;
        double litro = ml / 1000.0f;
        
        self.relogioController.label.text = [NSString stringWithFormat:@"%.0fml\n\n\n%.0f litros", ml, litro];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    NSString* connected = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    NSLog(@"%@", connected);
    
    [self performSegueWithIdentifier:@"showRelogioSegue" sender:nil];
}
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [self performSegueWithIdentifier:@"showListSegue" sender:nil];
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    NSLog(@"%ld", (long)peripheral.state);
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSString *messtoshow;
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
        {
            messtoshow=[NSString stringWithFormat:@"State unknown, update imminent."];
            break;
        }
        case CBCentralManagerStateResetting:
        {
            messtoshow=[NSString stringWithFormat:@"The connection with the system service was momentarily lost, update imminent."];
            break;
        }
        case CBCentralManagerStateUnsupported:
        {
            messtoshow=[NSString stringWithFormat:@"The platform doesn't support Bluetooth Low Energy"];
            break;
        }
        case CBCentralManagerStateUnauthorized:
        {
            messtoshow=[NSString stringWithFormat:@"The app is not authorized to use Bluetooth Low Energy"];
            break;
        }
        case CBCentralManagerStatePoweredOff:
        {
            messtoshow=[NSString stringWithFormat:@"Bluetooth is currently powered off."];
            NSLog(@"%@",messtoshow);
            break;
        }
        case CBCentralManagerStatePoweredOn:
        {
            
            messtoshow=[NSString stringWithFormat:@"Bluetooth is currently powered on and available to use."];
            
            [self.centrallManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey :@NO}];
            
            NSLog(@"%@",messtoshow);
            break;
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showListSegue"]) {
        ((ListTableViewController*)segue.destinationViewController).lista = self.lista;
        ((ListTableViewController*)segue.destinationViewController).centrallManager = self.centrallManager;
    } else if ([segue.identifier isEqualToString:@"showRelogioSegue"]) {
        self.relogioController = (RelogioViewController*)segue.destinationViewController;
        self.relogioController.btDevice = self.btDevice;
    }
}

@end
