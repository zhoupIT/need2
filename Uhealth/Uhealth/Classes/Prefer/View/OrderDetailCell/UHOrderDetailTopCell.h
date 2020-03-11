//
//  UHOrderDetailTopCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/4.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHCommodity;
@interface UHOrderDetailTopCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) UHCommodity *model;
@end
