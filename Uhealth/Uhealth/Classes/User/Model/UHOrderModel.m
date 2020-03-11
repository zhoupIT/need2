//
//  UHOrderModel.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHOrderModel.h"

@implementation UHOrderModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"needInvoice":@"needInvoice.text"};
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"orderItems" : @"UHOrderItemModel"
             };
}
@end
