//
//  UHCabinDetailModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHCabinDetailModel : NSObject
@property (nonatomic,strong) NSArray *cabinServiceList;
@property (nonatomic,strong) NSArray *nurseList;
@property (nonatomic,copy) NSString *cabinDetail;
@property (nonatomic,copy) NSString *healthCabinLogo;
@property (nonatomic,strong) NSArray *innerImgList;
@property (nonatomic,copy) NSString *healthCabinName;
@end
