//
//  UHUserModel.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/9.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHUserModel.h"

@implementation UHUserModel
MJCodingImplementation
/**
 如果属性是系统的关键字,那就重写方法, 将属性名换为其他key去字典中取值
 @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
    //,@"gender":@"gender.text"
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    
    if (oldValue == nil || [oldValue isKindOfClass:[NSNull class]])
        oldValue = @"";
//    if ([property.name isEqualToString:@"birthday"]) {
//        if (![oldValue isEqualToString:@""]) {
//            return [oldValue stringByReplacingOccurrencesOfString:@"-" withString:@"."];
//        }
//    }
    return oldValue;
}
@end
