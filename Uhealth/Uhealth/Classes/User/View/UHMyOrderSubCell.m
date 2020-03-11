//
//  UHMyOrderSubCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyOrderSubCell.h"
#import "UHOrderItemModel.h"

@interface UHMyOrderSubCell()
@property (strong, nonatomic) IBOutlet UIImageView *orderImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *presentPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *originPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;

@end
@implementation UHMyOrderSubCell

+ (instancetype)cellWithTabelView:(UITableView *)tableView {
    UHMyOrderSubCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHMyOrderSubCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UHMyOrderSubCell class]) owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = RGB(249, 249, 249);
        [cell setupUI];
    }
    return cell;
}

- (void)setupUI {
    self.orderImageView.layer.cornerRadius = 5;
    self.orderImageView.layer.masksToBounds = YES;
}

- (void)setModel:(UHOrderItemModel *)model {
    _model = model;
    [self.orderImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    self.nameLabel.text = model.commodityName;
    self.presentPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.presentUnitPrice];
    self.originPriceLabel.text = model.costUnitPrice;
    
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",self.originPriceLabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.originPriceLabel.attributedText = newPrice;
    
    self.countLabel.text = [NSString stringWithFormat:@"x%@",model.number];;
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
