//
//  UHMyOrderSubCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHOrderItemModel;
@interface UHMyOrderSubCell : UITableViewCell
+ (instancetype)cellWithTabelView:(UITableView *)tableView;
@property (nonatomic,strong) UHOrderItemModel *model;
@end
