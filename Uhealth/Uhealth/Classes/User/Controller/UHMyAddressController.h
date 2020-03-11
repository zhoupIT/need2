//
//  UHMyAddressController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/3/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHAddressModel;
@interface UHMyAddressController : UIViewController
@property (nonatomic,copy) void (^selectLocBlock) (UHAddressModel *model);
@end
