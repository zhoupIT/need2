//
//  UHMyServiceCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/3/30.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHMyServiceModel;
@interface UHMyServiceCell : UITableViewCell
+ (instancetype)cellWithTabelView:(UITableView *)tableView;
@property (nonatomic,strong) UHMyServiceModel *model;
@end
