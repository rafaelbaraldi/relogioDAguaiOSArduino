//
//  ListTableViewController.m
//  testArduino
//
//  Created by Rafael Baraldi on 29/09/2018.
//  Copyright © 2018 Rafael BAraldi. All rights reserved.
//

#import "ListTableViewController.h"
#import "RelogioViewController.h"

@interface ListTableViewController ()

@end

@implementation ListTableViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:WaterCell.class forCellReuseIdentifier:@"waterCell"];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Selecione";
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lista.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WaterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"waterCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[WaterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"waterCell"];
    }
    
    cell.textLabel.text = ((CBPeripheral*)self.lista[indexPath.row]).name;
    
    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CBPeripheral* bt = self.lista[self.tableView.indexPathForSelectedRow.row];
    [self.centrallManager connectPeripheral:bt options:nil];
    ((RelogioViewController*)segue.destinationViewController).btDevice = bt;
}

@end

@implementation WaterCell

@end
