//
//  UHCheckOutScoreCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHCheckOutScoreCell.h"

@implementation UHCheckOutScoreCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    UHCheckOutScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHCheckOutScoreCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UHCheckOutScoreCell class]) owner:nil options:nil] firstObject];
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
- (IBAction)selectScoreDiscount:(UIButton *)sender {
    sender.selected = !sender.selected;
}

@end
