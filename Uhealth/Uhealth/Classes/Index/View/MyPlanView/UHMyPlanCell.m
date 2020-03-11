//
//  UHMyPlanCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/27.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyPlanCell.h"
#import "UHMyPlanModel.h"
@interface UHMyPlanCell()
{
 UIImageView *_iconView;
 UILabel *_titleLabel;
 UIImageView *_rightIconView;
 UILabel *_timeLabel;
 UILabel *_timeValueLabel;
 UISwitch *_remaindSwitch;
 UILabel *_remaindLabel;
    
  UIView *_sepLineLabel;
}
@end
@implementation UHMyPlanCell

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
    UIView *contentView = self.contentView;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _iconView = [UIImageView new];
    _titleLabel = [UILabel new];
    _rightIconView = [UIImageView new];
    _timeLabel = [UILabel new];
    _timeValueLabel = [UILabel new];
    _remaindLabel = [UILabel new];
    _remaindSwitch = [UISwitch new];
    _sepLineLabel = [UIView new];
    
    [contentView sd_addSubviews:@[_iconView,_titleLabel,_rightIconView,_timeLabel,_timeValueLabel,_remaindLabel,_remaindSwitch,_sepLineLabel]];
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, 17)
    .topSpaceToView(contentView, 15)
    .heightIs(24)
    .widthIs(24);
    _iconView.image = [UIImage imageNamed:@"index_plan"];
    
    _rightIconView.sd_layout
    .rightSpaceToView(contentView, 15)
    .centerYEqualToView(_iconView)
    .widthIs(18)
    .heightIs(18);
    _rightIconView.image = [UIImage imageNamed:@"arrow_right"];
    
    _titleLabel.sd_layout
    .rightSpaceToView(_rightIconView, 15)
    .heightIs(15)
    .centerYEqualToView(_iconView)
    .leftSpaceToView(_iconView, 15);
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = ZPMyOrderDetailFontColor;
    
    _sepLineLabel.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .heightIs(1)
    .topSpaceToView(_iconView, 15);
    _sepLineLabel.backgroundColor = KControlColor;
    
    _timeLabel.sd_layout
    .topSpaceToView(_sepLineLabel, 15)
    .leftSpaceToView(contentView, 17)
    .heightIs(14);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:100];
    _timeLabel.text = @"创建时间:";
    _timeLabel.textColor = ZPMyOrderDetailFontColor;
    _timeLabel.font = [UIFont systemFontOfSize:14];
    
    _timeValueLabel.sd_layout
    .leftSpaceToView(_timeLabel, 5)
    .heightIs(14)
    .centerYEqualToView(_timeLabel);
    [_timeValueLabel setSingleLineAutoResizeWithMaxWidth:100];
    _timeValueLabel.textColor = ZPMyOrderDetailValueFontColor;
    _timeValueLabel.font = [UIFont systemFontOfSize:14];
    
    _remaindSwitch.sd_layout
    .rightSpaceToView(contentView, 15)
    .centerYEqualToView(_timeLabel);
    [_remaindSwitch addTarget:self action:@selector(switchRemind:) forControlEvents:UIControlEventValueChanged];
    
    _remaindLabel.sd_layout
    .rightSpaceToView(_remaindSwitch, 5)
    .heightIs(14)
    .centerYEqualToView(_timeLabel);
    [_remaindLabel setSingleLineAutoResizeWithMaxWidth:100];
    _remaindLabel.text = @"关闭提醒";
    _remaindLabel.font = [UIFont systemFontOfSize:14];
    _remaindLabel.textColor = ZPMyOrderDeleteBorderColor;
    _remaindLabel.textAlignment = NSTextAlignmentRight;
    
    [self setupAutoHeightWithBottomView:_timeLabel bottomMargin:15];
}

- (void)switchRemind:(UISwitch *)sw {
    _remaindLabel.text = sw.isOn?@"开启提醒":@"关闭提醒";
    if (self.changeRemindStatus) {
        self.changeRemindStatus(sw.isOn);
    }
}

- (void)setModel:(UHMyPlanModel *)model {
    _model = model;
    _titleLabel.text  =model.title;
    _timeValueLabel.text  = [model.createDate substringToIndex:10];
    if ([model.remindStatus isEqualToString:@""]) {
        _remaindSwitch.on = YES;
        _remaindLabel.text = @"开启提醒";
    } else {
         _remaindSwitch.on = NO;
        _remaindLabel.text = @"关闭提醒";
    }
}
@end
