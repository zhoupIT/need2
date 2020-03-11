//
//  UHPlanItemCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/27.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHPlanItemCell.h"
#import "UHPlanItemModel.h"
@interface UHPlanItemCell()
{
    UIView *_dotView;
    UILabel *_titleLabel;
}
@end
@implementation UHPlanItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _dotView = [UIView new];
    _titleLabel = [UILabel new];
    
    [self.contentView sd_addSubviews:@[_dotView,_titleLabel]];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _dotView.sd_layout
    .leftSpaceToView(self.contentView, 17)
    .widthIs(12)
    .heightIs(12)
    .centerYEqualToView(self.contentView);
    _dotView.layer.cornerRadius = 6;
    _dotView.layer.masksToBounds = YES;
    _dotView.backgroundColor = ZPMyOrderDetailValueFontColor;
    
    _titleLabel.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(_dotView, 10)
    .rightSpaceToView(self.contentView, 17)
    .heightIs(14);
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = ZPMyOrderDetailFontColor;
    
}

- (void)setModel:(UHPlanItemModel *)model {
    _model = model;
    _titleLabel.text = model.content;
}
@end
