//
//  RelogioViewController.m
//  testArduino
//
//  Created by Rafael Baraldi on 29/09/2018.
//  Copyright © 2018 Rafael BAraldi. All rights reserved.
//

#import "RelogioViewController.h"
#import <Lottie/Lottie.h>

@interface RelogioViewController ()

@end

@implementation RelogioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LOTAnimationView *animation = [LOTAnimationView animationNamed:@"water_loader"];
    CGRect frame = self.animationContentView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    animation.frame = frame;
    animation.loopAnimation = YES;
    animation.contentMode = UIViewContentModeScaleAspectFit;
    [self.animationContentView addSubview:animation];
    [animation play];
    
    UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithTitle:@"Reiniciar" style:UIBarButtonItemStyleDone target:self action:@selector(restart)];
    
    self.navigationItem.rightBarButtonItem = button;
}

-(void)restart {
    [self.btDevice writeValue:[@"A" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.characteristc type:CBCharacteristicWriteWithoutResponse];
}

@end
