//
//  UHPatientListModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/24.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHPatientListModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *customerId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) UHCommonEnumType *relation;
@property (nonatomic,copy) NSString *telephone;
@property (nonatomic,strong) UHCommonEnumType *idCardType;
@property (nonatomic,copy) NSString *idCardNo;
@property (nonatomic,assign) BOOL isSel;
@end
