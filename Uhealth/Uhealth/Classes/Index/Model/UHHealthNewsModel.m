//
//  UHHealthNewsModel.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHHealthNewsModel.h"

@implementation UHHealthNewsModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"toatalCommentsCount"]) {
        if (oldValue == nil || [oldValue isKindOfClass:[NSNull class]]){
            oldValue = @"0";
        }
    }
    return oldValue;
}
@end
