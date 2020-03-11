//
//  UHLittleAimController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHMyPlanModel,UHPlanItemModel;
@interface UHLittleAimController : UIViewController
@property (nonatomic,copy) void (^successBlock) (void);
@property (nonatomic,strong) UHMyPlanModel *model;
@property (nonatomic,strong) UHPlanItemModel *itemModel;

@end
