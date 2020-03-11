//
//  UHMyServiceModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/25.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHMyServiceModel : NSObject
@property (nonatomic,copy) NSString *serviceId;
@property (nonatomic,copy) NSString *customerId;
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,copy) NSString *medicalCity;
@property (nonatomic,copy) NSString *note;
@property (nonatomic,copy) NSString *cityServiceId;
@property (nonatomic,copy) NSString *medicalService;
@property (nonatomic,copy) NSString *linkPhone;
@property (nonatomic,copy) NSString *patientName;
@property (nonatomic,copy) NSString *patientTelephone;
@property (nonatomic,copy) NSString *idCardType;
@property (nonatomic,copy) NSString *idCardNo;
@property (nonatomic,copy) NSString *isAvailable;
@property (nonatomic,strong) UHCommonEnumType *greenChannelServiceStatus;
@property (nonatomic,copy) NSString *serialNumber;
@property (nonatomic,copy) NSString *payTime;
@property (nonatomic,copy) NSString *reducedPrice;
@property (nonatomic,copy) NSString *originProductAmountTotal;
@property (nonatomic,copy) NSString *orderAmountTotal;
@end
