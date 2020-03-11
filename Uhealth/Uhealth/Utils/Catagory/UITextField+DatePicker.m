//
//  UITextField+DatePicker.m
//  Sjyr_ERP
//
//  Created by tujinqiu on 15/11/28.
//  Copyright © 2015年 mysoft. All rights reserved.
//

#import "UITextField+DatePicker.h"

@implementation UITextField (DatePicker)

// 1
+ (UIDatePicker *)sharedDatePicker;
{
    static UIDatePicker *daterPicker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        daterPicker = [[UIDatePicker alloc] init];
        daterPicker.backgroundColor = [UIColor whiteColor];
//        daterPicker.datePickerMode = UIDatePickerModeDate;
        // 设置显示最小时间（此处为当前时间）
//        [daterPicker setMinimumDate:[NSDate date]];
    });
    
    return daterPicker;
}

// 2
- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    if (self.isFirstResponder)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
      
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    
        self.text = [formatter stringFromDate:sender.date];
    }
}

// 3
- (void)setDatePickerInput:(BOOL)datePickerInput
{
    if (datePickerInput)
    {
        
        
        self.inputView = [UITextField sharedDatePicker];
        
        [[UITextField sharedDatePicker] setDate:[NSDate date]];
        [[UITextField sharedDatePicker] addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    else
    {
        self.inputView = nil;
        [[UITextField sharedDatePicker] removeTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
}

// 4
- (BOOL)datePickerInput
{
    return [self.inputView isKindOfClass:[UIDatePicker class]];
}


- (void)setDatePickerSetMin:(BOOL)datePickerSetMin {
    if (datePickerSetMin) {
        [[UITextField sharedDatePicker] setMinimumDate:[NSDate date]];
    } else {
       [[UITextField sharedDatePicker] setMinimumDate:nil];
    }
}

- (void)setDatePickerSetMax:(BOOL)datePickerSetMax {
    if (datePickerSetMax) {
        [[UITextField sharedDatePicker] setMaximumDate:[NSDate date]];
    } else {
        [[UITextField sharedDatePicker] setMaximumDate:nil];
    }
}

- (void)setMode:(NSInteger)mode {
    [[UITextField sharedDatePicker] setDatePickerMode:mode];
}

@end
