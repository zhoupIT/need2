//
//  UHInnerImgList.m
//  Uhealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHInnerImgModel.h"

@implementation UHInnerImgModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    
    if (oldValue == nil || [oldValue isKindOfClass:[NSNull class]])
        oldValue = @"";
    return oldValue;
}
@end
