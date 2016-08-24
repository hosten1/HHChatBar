//
//  LDDatePickerController.m
//  
//
//  Created by yue on 8/5/16.
//
//

#import "LDDatePickerController.h"

@interface LDDatePickerController ()

@end

@implementation LDDatePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.datePicker.timeZone = [NSTimeZone localTimeZone];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)confirm:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didPickDate:)]) {
        [self.delegate didPickDate:self.datePicker.date];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
