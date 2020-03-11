//
//  UHCheckOutTitleCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHCheckOutTitleCell.h"

@interface UHCheckOutTitleCell()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@end
@implementation UHCheckOutTitleCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    UHCheckOutTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHCheckOutTitleCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UHCheckOutTitleCell class]) owner:nil options:nil] firstObject];
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

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleLabel.text = titleStr;
    
}
@end
