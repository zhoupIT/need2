//
//  UHMyServiceCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/30.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyServiceCell.h"
#import "UHMyServiceModel.h"

@interface UHMyServiceCell()
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *medicalServiceLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderAmountTotalLabel;
@property (strong, nonatomic) IBOutlet UILabel *originProductAmountTotalLabel;
@property (strong, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *picImageView;

@end
@implementation UHMyServiceCell

+ (instancetype)cellWithTabelView:(UITableView *)tableView {
    UHMyServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHMyServiceCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UHMyServiceCell class]) owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.separatorInset = UIEdgeInsetsZero;
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.picImageView.layer.cornerRadius = 5;
    self.picImageView.layer.masksToBounds = YES;
}

- (void)setModel:(UHMyServiceModel *)model {
    self.payTimeLabel.text = [NSString stringWithFormat:@"下单时间:%@",model.payTime];
    self.statusLabel.text = model.greenChannelServiceStatus.text;
    self.medicalServiceLabel.text = model.medicalService;
    self.orderAmountTotalLabel.text = [NSString stringWithFormat:@"￥%@",model.orderAmountTotal];
    self.originProductAmountTotalLabel.text = [NSString stringWithFormat:@"%@",model.originProductAmountTotal];
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",self.originProductAmountTotalLabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.originProductAmountTotalLabel.attributedText = newPrice;
}

@end
