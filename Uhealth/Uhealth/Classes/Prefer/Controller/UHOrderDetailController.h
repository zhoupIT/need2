//
//  UHOrderDetailController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/4.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHCommodity;
typedef NS_ENUM (NSInteger,ZPOrderEnterStatusType) {
    ZPOrderEnterStatusTypeNormal,//正常路径
    ZPOrderEnterStatusTypeBanner,//banner图
    ZPOrderEnterStatusTypeNoti//通知
};
@interface UHOrderDetailController : UIViewController
@property (nonatomic,strong) UHCommodity *commodity;
@property (nonatomic,assign) ZPOrderEnterStatusType enterStatusType;
@end
