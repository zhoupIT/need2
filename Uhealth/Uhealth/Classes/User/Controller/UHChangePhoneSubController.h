//
//  UHChangePhoneSubController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHChangePhoneSubController : UIViewController
@property (nonatomic,copy) NSString *currentPhone;
@property (nonatomic,copy) void (^updatePhoneBlock) (NSString *phone);
@end
