//
//  UHMyShoppingCarCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/2.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHCarCommodity;
@interface UHMyShoppingCarCell : UITableViewCell
@property (nonatomic,strong) UHCarCommodity *model;
@property (nonatomic,copy) void (^refreshViewBlock) (BOOL isSel);

@property (nonatomic,copy) void (^refreshPriceBlock) (NSInteger num);
@end
