//
//  UHConsultDoctorModel.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/17.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHConsultDoctorModel.h"

@implementation UHConsultDoctorModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    
    if (oldValue == nil || [oldValue isKindOfClass:[NSNull class]])
        oldValue = @"";
    return oldValue;
}
@end
