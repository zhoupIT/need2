//
//  UHCheckOutSubTitleCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHCheckOutModel;
@interface UHCheckOutSubTitleCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) UHCheckOutModel *model;
@property (nonatomic,copy) NSString *subtitleStr;
@property (nonatomic,copy) NSString *titleStr;
@end
