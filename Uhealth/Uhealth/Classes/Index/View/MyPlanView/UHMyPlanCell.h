//
//  UHMyPlanCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/27.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHMyPlanModel;
@interface UHMyPlanCell : UITableViewCell
@property (nonatomic,strong) UHMyPlanModel *model;
@property (nonatomic,copy) void (^changeRemindStatus) (BOOL isRemind);
@end
