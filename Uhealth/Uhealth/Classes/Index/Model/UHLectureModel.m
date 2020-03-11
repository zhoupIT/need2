//
//  UHLectureModel.m
//  Uhealth
//
//  Created by Biao Geng on 2018/8/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHLectureModel.h"

@implementation UHLectureModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    
    if (oldValue == nil || [oldValue isKindOfClass:[NSNull class]])
        oldValue = @"";
    return oldValue;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"lectureIntroductionImg" : @"UHlectureIntroductionImg"
             };
}
@end
