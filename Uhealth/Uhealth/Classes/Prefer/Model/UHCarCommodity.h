//
//  UHCarCommodity.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UHCommodity;
@interface UHCarCommodity : NSObject
@property (nonatomic,strong) UHCommodity *commodity;
@property (nonatomic,copy) NSString *itemId;
@property (nonatomic,copy) NSString *customerId;
@property (nonatomic,copy) NSString *commodityCount;

@property (nonatomic,assign) BOOL isSel;
@end
