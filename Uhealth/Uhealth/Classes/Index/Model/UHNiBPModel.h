//
//  UHNiBPModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/5/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHNiBPModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *customerId;
@property (nonatomic,copy) NSString *testRecordId;
@property (nonatomic,strong) UHCommonEnumType *level;
@property (nonatomic,strong) UHCommonEnumType *collectType;
@property (nonatomic,copy) NSString *detectDate;

@property (nonatomic,copy) NSString *sbp;
@property (nonatomic,copy) NSString *dbp;

//血尿酸
@property (nonatomic,copy) NSString *ua;
//血氧
@property (nonatomic,copy) NSString *spo2;
//血糖
@property (nonatomic,copy) NSString *glu;
@property (nonatomic,strong) UHCommonEnumType *dietaryStatus;
//身体指数bfr
@property (nonatomic,copy) NSString *bfr;
@property (nonatomic,strong) UHCommonEnumType *bfrLevel;
//体重
@property (nonatomic,copy) NSString *weight;
//血脂
@property (nonatomic,copy) NSString *mark;
@property (nonatomic,copy) NSString *value;
@property (nonatomic,strong) UHCommonEnumType *tcLevel;
@property (nonatomic,strong) UHCommonEnumType *tgLevel;
@property (nonatomic,strong) UHCommonEnumType *hdlcLevel;
@property (nonatomic,strong) UHCommonEnumType *ldlcLevel;
@end
