//
//  UHCabinServiceModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHCabinServiceModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *cabinId;
@property (nonatomic,copy) NSString *serviceName;
@property (nonatomic,copy) NSString *serviceIntroduction;
@property (nonatomic,copy) NSString *serviceImg;
@end
