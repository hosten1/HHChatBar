//
//  LDAccountSecurityTableViewController.m
//  Linkdood
//
//  Created by renxin-.- on 16/3/3.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDAccountSecurityTableViewController.h"

@interface LDAccountSecurityTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *doodNumber;

@end

@implementation LDAccountSecurityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号与安全";

    [self initView];
}

- (void)initView
{
    if (MYSELF.phones != NULL) {
        NSMutableString *str = [[NSMutableString alloc] initWithString:[MYSELF.phones firstObject]];
        [str deleteCharactersInRange:NSMakeRange(0,4)];
        [str insertString:@"-" atIndex:3];
        [str insertString:@"-" atIndex:8];
        self.phone.text = str;
    }
    self.email.text = [MYSELF.emails firstObject];
    self.doodNumber.text = MYSELF.nickID;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (self.doodNumber.text.length == 0) {
            [self performSegueWithIdentifier:@"informationToChange" sender:@"豆豆号"];
        }
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self performSegueWithIdentifier:@"accountToBindPhone" sender:nil];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        [self performSegueWithIdentifier:@"accountToBindEmail" sender:nil];
    }
    if (indexPath.section == 2) {
        [self performSegueWithIdentifier:@"accountToModifyPassword" sender:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
