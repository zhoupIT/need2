//
//  UHCheckOutSubTitleCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHCheckOutSubTitleCell.h"
#import "UHCheckOutModel.h"
@interface UHCheckOutSubTitleCell()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
@end
@implementation UHCheckOutSubTitleCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    UHCheckOutSubTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHCheckOutSubTitleCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UHCheckOutSubTitleCell class]) owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(UHCheckOutModel *)model {
    self.titleLabel.text = model.title;
    self.subTitleLabel.text = model.details;
}

- (void)setSubtitleStr:(NSString *)subtitle {
    self.subTitleLabel.text = subtitle;
}

- (void)setTitleStr:(NSString *)titleStr {
    self.titleLabel.text = titleStr;
}
@end
