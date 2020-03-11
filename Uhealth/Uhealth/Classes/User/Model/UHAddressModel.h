//
//  UHAddressModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHAddressModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *customerId;
@property (nonatomic,copy) NSString *receiver;
@property (nonatomic,copy) NSString *relation;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *provinceId;
@property (nonatomic,copy) NSString *provinceName;
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSString *countryId;
@property (nonatomic,copy) NSString *countryName;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,strong) UHCommonEnumType *addressStatus;
@property (nonatomic,copy) NSString *tag;
@end
