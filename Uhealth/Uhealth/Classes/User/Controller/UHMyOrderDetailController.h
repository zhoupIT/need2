//
//  UHMyOrderDetailController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/3/29.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHOrderModel.h"
@interface UHMyOrderDetailController : UIViewController
@property (nonatomic,strong) UHOrderModel *orderModel;

@property (nonatomic,copy) void (^updateTableBlock) (void);
@end
