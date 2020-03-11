//
//  UHCheckOutNoLocHeaderCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHCheckOutNoLocHeaderCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,copy) void (^addLocBlock) (void);
@end
