//
//  UHCheckOutModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    /// 商店
    UHDetailsCellType_shop = 1,
    /// 商品
    UHDetailsCellType_goods ,
    /// 输入数量
    UHDetailsCellType_inputNums,
    /// 配送方式
    UHDetailsCellType_delivery,
    /// 配送时间
    UHDetailsCellType_time,
    /// 运费险
    UHDetailsCellType_insurance,
    /// 留言
    UHDetailsCellType_message
} UHDetailsCellType;

@interface UHCheckOutModel : NSObject

@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *details;
@property (nonatomic , assign) NSInteger cellHeight;
@property (nonatomic , assign) UHDetailsCellType cellType;
+ (NSMutableArray *)creatDetailsData;
@end
