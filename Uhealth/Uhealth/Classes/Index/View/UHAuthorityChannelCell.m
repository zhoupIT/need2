//
//  UHAuthorityChannelCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/8/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHAuthorityChannelCell.h"
#import "UHAdvisoryChannelModel.h"
@interface UHAuthorityChannelCell()
@property (nonatomic,strong) UIImageView *iconView;

@end
@implementation UHAuthorityChannelCell
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
    self.iconView.layer.cornerRadius = 5;
    int x = arc4random() % 100;
    if (x%2==0) {
        self.iconView.image = [UIImage imageNamed:@"脊椎病-首页"];
    } else {
        self.iconView.image = [UIImage imageNamed:@"微生态"];
    }
    
}

- (void)setModel:(UHAdvisoryChannelModel *)model {
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"placeholder_cart"]];
}

@end
