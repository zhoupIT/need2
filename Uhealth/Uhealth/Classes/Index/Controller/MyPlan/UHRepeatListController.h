//
//  UHRepeatListController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHRepeatListController : UIViewController
@property (nonatomic,copy) void (^selectedBlock) (NSString *str);
@property (nonatomic,copy) NSString *str;
@end
