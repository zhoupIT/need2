//
//  UHMyFileModel.m
//  Uhealth
//
//  Created by Biao Geng on 2018/7/2.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyFileModel.h"

@implementation UHMyFileModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
    //,@"gender":@"gender.text"
}
@end
