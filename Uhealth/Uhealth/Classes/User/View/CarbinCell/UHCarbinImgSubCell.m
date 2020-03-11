//
//  UHCarbinImgSubCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHCarbinImgSubCell.h"
#import "UHInnerImgModel.h"
@interface UHCarbinImgSubCell()
@property (nonatomic,strong) UIImageView *iconView;
@end
@implementation UHCarbinImgSubCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.iconView = [[UIImageView alloc] init];
    self.iconView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.iconView];
    self.iconView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = 4;
}

- (void)setModel:(UHInnerImgModel *)model {
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"placeholder_cart"]];
}
@end
