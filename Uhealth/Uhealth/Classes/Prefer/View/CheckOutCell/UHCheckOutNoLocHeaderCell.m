//
//  UHCheckOutNoLocHeaderCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHCheckOutNoLocHeaderCell.h"

@implementation UHCheckOutNoLocHeaderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    UHCheckOutNoLocHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHCheckOutNoLocHeaderCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UHCheckOutNoLocHeaderCell class]) owner:nil options:nil] firstObject];
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

- (IBAction)addLoc:(UIButton *)sender {
    if (self.addLocBlock) {
        self.addLocBlock();
    }
}


@end
