//
//  UHCityServicesModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHCityServicesModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *medicalCityId;
@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSString *medicalServiceId;
@property (nonatomic,copy) NSString *serviceTypeName;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *serviceStatus;
@property (nonatomic,assign) BOOL isSel;
@end
