//
//  UHCheckOutOrderCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHCarCommodity,UHOrderItemModel,UHCommodity;
@interface UHCheckOutOrderCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) UHCarCommodity *model;
@property (nonatomic,strong) UHOrderItemModel *itemModel;
@property (nonatomic,strong) UHCommodity *commodityModel;

@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *orginTotal;
@property (nonatomic,copy) NSString *total;
@end
