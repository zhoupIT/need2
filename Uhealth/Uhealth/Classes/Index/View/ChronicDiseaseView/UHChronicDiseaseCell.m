//
//  UHChronicDiseaseCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHChronicDiseaseCell.h"
#import "UHChronicDiseaseModel.h"
@interface UHChronicDiseaseCell()
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *label;
@end
@implementation UHChronicDiseaseCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加自己需要个子视图控件
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.backgroundColor = [UIColor whiteColor];
    UIView *contentView = self.contentView;
    self.iconView = [UIImageView new];
    self.label = [UILabel new];
    [contentView sd_addSubviews:@[self.iconView,self.label]];
    
    self.iconView.sd_layout
    .centerXEqualToView(contentView)
    .topSpaceToView(contentView, 23*[Utils ZPDeviceHeightRation])
    .widthIs(60*[Utils ZPDeviceWidthRation])
    .heightIs(60*[Utils ZPDeviceWidthRation]);
//    self.iconView.layer.cornerRadius = 10;
//    self.iconView.layer.masksToBounds = YES;
    
    self.label.sd_layout
    .topSpaceToView(self.iconView, 11)
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .heightIs(15);
    self.label.font = [UIFont systemFontOfSize:14];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = ZPMyOrderDetailFontColor;
    
}

- (void)setModel:(UHChronicDiseaseModel *)model {
    _model = model;
    self.iconView.image = [UIImage imageNamed:model.iconName];
    self.label.text = model.name;
}
@end
