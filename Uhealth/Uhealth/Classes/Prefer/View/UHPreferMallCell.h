//
//  UHPreferMallCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/2.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHCommodity;
@interface UHPreferMallCell : UITableViewCell
@property (nonatomic,strong) UHCommodity *model;
@property (nonatomic,copy) void (^cartBlock) (UIButton *btn);
@end
