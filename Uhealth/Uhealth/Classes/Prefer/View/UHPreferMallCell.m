//
//  UHPreferMallCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/2.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHPreferMallCell.h"
#import "UHCommodity.h"
@interface UHPreferMallCell()
@property (nonatomic,strong) UILabel *orderNameLabel;
@property (nonatomic,strong) UIImageView *orderImageView;
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *originPriceLabel;
@property (nonatomic,strong) UIButton *addToMarketCarButton;
@end
@implementation UHPreferMallCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
    _orderNameLabel = [UILabel new];
    _orderImageView = [UIImageView new];
    _tipLabel = [UILabel new];
    _priceLabel = [UILabel new];
    _originPriceLabel = [UILabel new];
    _addToMarketCarButton = [UIButton new];
    
    [self.contentView sd_addSubviews:@[_orderNameLabel,_orderImageView,_tipLabel,_priceLabel,_originPriceLabel,_addToMarketCarButton]];
    
    _orderNameLabel.sd_layout
    .leftSpaceToView(self.contentView,20)
    .topSpaceToView(self.contentView, 15)
    .heightIs(16)
    .rightSpaceToView(self.contentView, 20);
    _orderNameLabel.font = [UIFont systemFontOfSize:16];
    _orderNameLabel.textColor = ZPMyOrderDetailFontColor;
    _orderNameLabel.text = @"--";
    
    _orderImageView.sd_layout
    .leftSpaceToView(self.contentView,15)
    .rightSpaceToView(self.contentView, 20)
    .heightIs(200)
    .topSpaceToView(_orderNameLabel, 15);
    _orderImageView.layer.cornerRadius = 5;
    _orderImageView.layer.masksToBounds = YES;
    _orderImageView.image = [UIImage imageNamed:@"placeholder_detail"];
    _orderImageView.contentMode = UIViewContentModeScaleAspectFill;
    _orderImageView.clipsToBounds = YES;
    
    _tipLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .widthIs(60)
    .heightIs(24)
    .topSpaceToView(_orderImageView, 15);
    _tipLabel.layer.cornerRadius = 5;
    _tipLabel.layer.masksToBounds = YES;
    _tipLabel.layer.borderColor = ZPMyOrderBorderColor.CGColor;
    _tipLabel.layer.borderWidth = 1;
    _tipLabel.font = [UIFont systemFontOfSize:14];
    _tipLabel.textColor = ZPMyOrderBorderColor;
    _tipLabel.text = @"优选价";
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    
    _priceLabel.sd_layout
    .leftSpaceToView(_tipLabel, 10)
    .centerYEqualToView(_tipLabel)
    .heightIs(18);
    [_priceLabel setSingleLineAutoResizeWithMaxWidth:100];
    _priceLabel.font = [UIFont systemFontOfSize:18];
    _priceLabel.textColor = ZPMyOrderBorderColor;
    _priceLabel.text = @"¥0";
    
    _originPriceLabel.sd_layout
    .bottomEqualToView(_priceLabel)
    .leftSpaceToView(_priceLabel, 10)
    .heightIs(14);
    [_originPriceLabel setSingleLineAutoResizeWithMaxWidth:100];
    _originPriceLabel.font = [UIFont systemFontOfSize:14];
    _originPriceLabel.textColor = RGB(153, 153, 153);
    _originPriceLabel.text = @"0";
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",_originPriceLabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    _originPriceLabel.attributedText = newPrice;
    
    _addToMarketCarButton.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .heightIs(33)
    .widthIs(91)
    .centerYEqualToView(_tipLabel);
    _addToMarketCarButton.layer.cornerRadius = 33*0.5;
    _addToMarketCarButton.layer.masksToBounds = YES;
    _addToMarketCarButton.backgroundColor = ZPMyOrderBorderColor;
    _addToMarketCarButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_addToMarketCarButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [_addToMarketCarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_addToMarketCarButton addTarget:self action:@selector(addToCart:) forControlEvents:UIControlEventTouchUpInside];
     [self setupAutoHeightWithBottomView:_addToMarketCarButton bottomMargin:7];
}

- (void)addToCart:(UIButton *)btn {
    
    if (self.cartBlock) {
        btn.userInteractionEnabled = NO;
        self.cartBlock(btn);
    }
}

- (void)setModel:(UHCommodity *)model {
    _model = model;
    _orderNameLabel.text = model.name;
    NSString *rule = [NSString stringWithFormat:@"%@",model.coverImage];
    [_orderImageView sd_setImageWithURL:[NSURL URLWithString:rule] placeholderImage:[UIImage imageNamed:@"placeholder_order"]];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",model.presentPrice];
    
    _originPriceLabel.text = [NSString stringWithFormat:@"%@",model.originalPrice];
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",_originPriceLabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    _originPriceLabel.attributedText = newPrice;
    _tipLabel.text = model.priceName;
    
}
@end
