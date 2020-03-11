//
//  UHReservationCityListCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHReservationCityListCell.h"
#import "UHReservationCityModel.h"
#import "UHCityServicesModel.h"
@interface UHReservationCityListCell()
{
    UILabel *_cityNameLabel;
    UIButton *_isSelButton;
}
@end
@implementation UHReservationCityListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIView *contentView = self.contentView;
    _cityNameLabel = [UILabel new];
    _isSelButton = [UIButton new];
    [contentView sd_addSubviews:@[_cityNameLabel,_isSelButton]];
    
    [_isSelButton setImage:[UIImage imageNamed:@"noselected"] forState:UIControlStateNormal];
    [_isSelButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [_isSelButton addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
    _isSelButton.sd_layout
    .rightSpaceToView(contentView, 15)
    .widthIs(22)
    .heightIs(22)
    .centerYEqualToView(contentView);
    
    _cityNameLabel.textColor = ZPMyOrderDetailFontColor;
    _cityNameLabel.font = [UIFont systemFontOfSize:14];
    _cityNameLabel.sd_layout
    .leftSpaceToView(contentView, 15)
    .centerYEqualToView(contentView)
    .rightSpaceToView(_isSelButton, 5)
    .heightIs(14);
}

- (void)didSelect:(UIButton *)btn {
    if (self.didClickBlock) {
        self.didClickBlock(btn);
    }
}

- (void)setModel:(UHReservationCityModel *)model {
    _model = model;
    _cityNameLabel.text = model.name;
    _isSelButton.selected = model.isSel;
}

- (void)setServicesModel:(UHCityServicesModel *)servicesModel {
    _servicesModel = servicesModel;
    _cityNameLabel.text = servicesModel.serviceTypeName;
    _isSelButton.selected = servicesModel.isSel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
