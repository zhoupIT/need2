//
//  UHPlanItemModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/27.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHPlanItemModel : NSObject
@property (nonatomic,strong) UHCommonEnumType *needRemindFlag;
@property (nonatomic,strong) UHCommonEnumType *repeatType;
@property (nonatomic,copy) NSString *itemId;
@property (nonatomic,copy) NSString *planId;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *remindTime;
@end
