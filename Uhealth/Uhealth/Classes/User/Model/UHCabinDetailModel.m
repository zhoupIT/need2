//
//  UHCabinDetailModel.m
//  Uhealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHCabinDetailModel.h"

@implementation UHCabinDetailModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    
    if (oldValue == nil || [oldValue isKindOfClass:[NSNull class]])
        oldValue = @"";
    return oldValue;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"nurseList" : @"UHNurseModel",
             @"innerImgList":@"UHInnerImgModel",
             @"cabinServiceList":@"UHCabinServiceModel"
             };
}
@end
