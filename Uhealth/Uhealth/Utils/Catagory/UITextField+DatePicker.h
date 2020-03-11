//
//  UITextField+DatePicker.h
//  Sjyr_ERP
//
//  Created by tujinqiu on 15/11/28.
//  Copyright © 2015年 mysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (DatePicker)

@property (nonatomic, assign) BOOL datePickerInput;
@property (nonatomic, assign) BOOL datePickerSetMin;
@property (nonatomic, assign) BOOL datePickerSetMax;
@property (nonatomic,assign) NSInteger mode;
+ (UIDatePicker *)sharedDatePicker;

@end
