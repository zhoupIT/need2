//
//  UHMyOrderDetailCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/29.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyOrderDetailCell.h"

@interface UHMyOrderDetailCell()
@property (strong, nonatomic) IBOutlet UILabel *leftLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;

@end
@implementation UHMyOrderDetailCell

+ (instancetype)cellWithTabelView:(UITableView *)tableView {
    UHMyOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHMyOrderDetailCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UHMyOrderDetailCell class]) owner:nil options:nil] firstObject];
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
