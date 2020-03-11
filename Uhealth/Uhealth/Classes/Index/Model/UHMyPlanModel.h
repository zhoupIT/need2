//
//  UHMyPlanModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/27.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHMyPlanModel : NSObject
@property (nonatomic,copy) NSString *planId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *customerId;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *remindStatus;
@end
