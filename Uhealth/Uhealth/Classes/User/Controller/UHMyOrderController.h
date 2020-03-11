//
//  UHMyOrderController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/3/29.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHOrderModel;
typedef NS_ENUM (NSInteger,ZPOrderStatusType) {
    ZPOrderStatusTypeAll,
    ZPOrderStatusTypeNON_PAYMENT,
    ZPOrderStatusTypeNON_SEND,
    ZPOrderStatusTypeNON_RECIEVE,
    ZPOrderStatusTypeNON_EVALUATED
};
@interface UHMyOrderController : UITableViewController
@property (nonatomic,copy) void (^detailClickEventBlock) (UHOrderModel *model);
@property (nonatomic,copy) void (^payBlock) (UHOrderModel *model);
//订单状态
@property (nonatomic,assign) ZPOrderStatusType orderStatusType;
@property (nonatomic,copy) void (^refreshTableBlock) (void);

@property (nonatomic,copy) void (^traceBlock) (UHOrderModel *model);
@end
