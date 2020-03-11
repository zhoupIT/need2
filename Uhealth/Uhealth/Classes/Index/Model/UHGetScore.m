//
//  UHGetScore.m
//  Uhealth
//
//  Created by Biao Geng on 2018/6/21.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHGetScore.h"

@implementation UHGetScore
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    
    if (oldValue == nil || [oldValue isKindOfClass:[NSNull class]])
        oldValue = @"";
        if ([property.name isEqualToString:@"title"]) {
            if ([oldValue isEqualToString:@"情绪量表"]) {
                return @"情绪";
            } else if ([oldValue isEqualToString:@"睡眠量表"]) {
                return @"睡眠";
            } else if ([oldValue isEqualToString:@"焦虑与躯体不适量表"]) {
                return @"焦虑";
            } else if ([oldValue isEqualToString:@"疼痛量表"]) {
                return @"疼痛";
            }else if ([oldValue isEqualToString:@"性功能量表"]) {
                return @"性功能";
            }else if ([oldValue isEqualToString:@"快乐和满意度量表"]) {
                return @"满意度";
            }else if ([oldValue isEqualToString:@"疑病量表"]) {
                return @"疑病";
            }else if ([oldValue isEqualToString:@"社交障碍量表"]) {
                return @"社交";
            }
            
        }
    return oldValue;
}
@end
