//
//  UHCheckOutFavourCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHCheckOutFavourCell.h"

@implementation UHCheckOutFavourCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    UHCheckOutFavourCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHCheckOutFavourCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UHCheckOutFavourCell class]) owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end