//
//  UHCheckOutSubtitleIconCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHCheckOutSubtitleIconCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,copy) NSString *leftstr;
@property (nonatomic,copy) NSString *rightstr;
@end
