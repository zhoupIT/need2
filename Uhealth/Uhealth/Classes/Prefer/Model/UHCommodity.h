//
//  UHCommodity.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHCommodity : NSObject
@property (nonatomic,assign) NSInteger commodityId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) UHCommonEnumType *commoditytype;
@property (nonatomic,strong) UHCommonEnumType *status;
@property (nonatomic,copy) NSString *note;
@property (nonatomic,assign) NSString *originalPrice;
@property (nonatomic,assign) NSString *costPrice;
@property (nonatomic,assign) NSString *presentPrice;
@property (nonatomic,copy) NSString *coverImage;
@property (nonatomic,copy) NSString *priceName;
//轮播图
@property (nonatomic,strong) NSArray *commodityAttachmentsAtCenterPosition;
//详情图
@property (nonatomic,strong) NSArray *commodityAttachmentsAtCommodityParticularsPosition;
@end

