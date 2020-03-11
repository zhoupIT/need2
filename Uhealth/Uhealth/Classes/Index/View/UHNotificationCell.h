//
//  UHNotificationCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/5/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHNotiModel;
@interface UHNotificationCell : UITableViewCell
@property (nonatomic,strong) UHNotiModel *model;
@property (nonatomic,copy) void (^detailContentBlock) (UHNotiModel *model);
@end
