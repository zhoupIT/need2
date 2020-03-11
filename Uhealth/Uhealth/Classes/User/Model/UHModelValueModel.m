//
//  UHModelValueModel.m
//  Uhealth
//
//  Created by Biao Geng on 2018/6/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHModelValueModel.h"

@implementation UHModelValueModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    
    if (oldValue == nil || [oldValue isKindOfClass:[NSNull class]])
        oldValue = @"";
    return oldValue;
}
@end
