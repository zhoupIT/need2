//
//  UHEmergencyRescueCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/9.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHEmergencyRescueCell.h"
#import "UHEmergencyRescueModel.h"
@interface UHEmergencyRescueCell()
{
    UIImageView *_iconView;
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    UILabel *_priceLabel;
}
@end
@implementation UHEmergencyRescueCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIView *contentView = self.contentView;
    _iconView = [UIImageView new];
    [contentView addSubview:_iconView];
    
    _titleLabel = [UILabel new];
    [contentView addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = ZPMyOrderDetailFontColor;
    
    _contentLabel = [UILabel new];
    [contentView addSubview:_contentLabel];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    _contentLabel.textColor = ZPMyOrderDeleteBorderColor;
    
    _priceLabel = [UILabel new];
    [contentView addSubview:_priceLabel];
    _priceLabel.font = [UIFont systemFontOfSize:15];
    _priceLabel.textColor = ZPMyOrderBorderColor;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, 15)
    .centerYEqualToView(contentView)
    .heightIs(80)
    .widthIs(80);
    _iconView.layer.cornerRadius = 5;
    _iconView.layer.masksToBounds = YES;
    
    _titleLabel.sd_layout
    .leftSpaceToView(_iconView, 10)
    .topEqualToView(_iconView)
    .heightIs(14);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _priceLabel.sd_layout
    .rightSpaceToView(contentView, 15)
    .centerYEqualToView(_titleLabel)
    .leftSpaceToView(_titleLabel, 5)
    .heightIs(15);
    
    _contentLabel.sd_layout
    .topSpaceToView(_titleLabel, 15)
    .rightSpaceToView(contentView, 15)
    .leftSpaceToView(_iconView, 10);
    [_contentLabel setMaxNumberOfLinesToShow:2];
}

- (void)setModel:(UHEmergencyRescueModel *)model {
    _model = model;
    _iconView.image = [UIImage imageNamed:model.imageName];
    _titleLabel.text = model.title;
    _contentLabel.text = model.content;
    _priceLabel.text = model.price;
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
