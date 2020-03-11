//
//  UHCheckOutOrderCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHCheckOutOrderCell.h"
#import "UHCarCommodity.h"
#import "UHCommodity.h"
#import "UHOrderItemModel.h"
@interface UHCheckOutOrderCell()
@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *presentLabel;
@property (strong, nonatomic) IBOutlet UILabel *orginLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation UHCheckOutOrderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    UHCheckOutOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHCheckOutOrderCell class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UHCheckOutOrderCell class]) owner:nil options:nil] firstObject];
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

- (void)setModel:(UHCarCommodity *)model {
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.commodity.coverImage]];
    self.nameLabel.text = model.commodity.name;
    self.presentLabel.text = [NSString stringWithFormat:@"￥%@",model.commodity.presentPrice];
    self.orginLabel.text = model.commodity.originalPrice;
    
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", self.orginLabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.orginLabel.attributedText = newPrice;
    
    self.numLabel.text = [NSString stringWithFormat:@"x%@",model.commodityCount];
}

- (void)setCommodityModel:(UHCommodity *)commodityModel {
    _commodityModel = commodityModel;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:commodityModel.coverImage]];
    self.nameLabel.text = commodityModel.name;
    self.presentLabel.text = [NSString stringWithFormat:@"￥%@",commodityModel.presentPrice];
    self.orginLabel.text = commodityModel.originalPrice;
    
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", self.orginLabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.orginLabel.attributedText = newPrice;
    
    self.numLabel.text = [NSString stringWithFormat:@"x%@",@"1"];
}


- (void)setItemModel:(UHOrderItemModel *)itemModel {
    _itemModel = itemModel;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:itemModel.imageUrl]];
    self.nameLabel.text = itemModel.commodityName;
    self.presentLabel.text = [NSString stringWithFormat:@"￥%@",itemModel.presentUnitPrice];
    self.orginLabel.text = itemModel.costUnitPrice;
    
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", self.orginLabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.orginLabel.attributedText = newPrice;
    
    self.numLabel.text = [NSString stringWithFormat:@"x%@",itemModel.number];
}

- (void)setType:(NSString *)type {
    _type = type;
    self.iconView.image = [UIImage imageNamed:@"greenPath"];
    self.iconView.layer.cornerRadius = 5;
    self.iconView.layer.masksToBounds = YES;
    self.nameLabel.text = @"商品名：绿色通道";
    self.typeLabel.text = [NSString stringWithFormat:@"商品类型：%@",type];
}

- (void)setTotal:(NSString *)total {
    _total = total;
    self.presentLabel.text = [NSString stringWithFormat:@"￥%@",total];
}

- (void)setOrginTotal:(NSString *)orginTotal {
    _orginTotal = orginTotal;
    self.orginLabel.text = orginTotal;
    
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", self.orginLabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.orginLabel.attributedText = newPrice;
    
    self.numLabel.text = [NSString stringWithFormat:@"x1"];
}
@end
