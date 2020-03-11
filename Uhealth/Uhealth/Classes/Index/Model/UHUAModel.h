//
//  UHUAModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/5/24.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHUAModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *customerId;
@property (nonatomic,copy) NSString *testRecordId;
@property (nonatomic,copy) NSString *ua;
@property (nonatomic,strong) UHCommonEnumType *level;
@property (nonatomic,strong) UHCommonEnumType *collectType;
@property (nonatomic,copy) NSString *detectDate;
@end
