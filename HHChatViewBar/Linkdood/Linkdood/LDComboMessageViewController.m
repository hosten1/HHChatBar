//
//  LDComboMessageViewController.m
//  Linkdood
//
//  Created by yue on 7/8/16.
//  Copyright © 2016 xiong qing. All rights reserved.
//

#import "LDComboMessageCell.h"
#import "LDComboMessageViewController.h"

@interface LDComboMessageViewController ()

@end

@implementation LDComboMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - Table view data source




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LDComboMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LDComboMessageCell" forIndexPath:indexPath];
    
    LDMessageModel *message = [self.combo.messages objectAtIndex:indexPath.row];
    
    [cell bindData:message userInfo:self.combo.userInfo];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.combo.messages.count;
}

@end
