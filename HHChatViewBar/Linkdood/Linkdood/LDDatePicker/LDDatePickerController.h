//
//  LDDatePickerController.h
//  
//
//  Created by yue on 8/5/16.
//
//

#import <UIKit/UIKit.h>

@protocol LDDatePickerDelegate <NSObject>

- (void)didPickDate:(NSDate*)date;

@end

@interface LDDatePickerController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) id<LDDatePickerDelegate> delegate;

@end
