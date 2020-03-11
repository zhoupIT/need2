//
//  UHHealthTestCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHHealthTestCell.h"
#import "UHHealthTestModel.h"
@interface UHHealthTestCell()
{
    UIImageView *_iconView;
}
@end
@implementation UHHealthTestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _iconView = [UIImageView new];
    [self.contentView addSubview:_iconView];
    
    _iconView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (void)setModel:(UHHealthTestModel *)model {
    _model = model;
    _iconView.image = [UIImage imageNamed:model.imageName];
}

@end
