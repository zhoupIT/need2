//
//  UHHealthWindCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHHealthWindCell.h"
#import "SDWeiXinPhotoContainerView.h"
#import "UHHealthWindModel.h"
@interface UHHealthWindCell()
{
    UILabel *_titleLabel;
    UIImageView *_iconView0;
    UIImageView *_iconView1;
    UIImageView *_iconView2;
    UILabel *_pageViewLabel;
    UIView *_sepLine;
}
@end
@implementation UHHealthWindCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsZero;
    UIView *contentView = self.contentView;
    
    _sepLine = [UIView new];
    [contentView addSubview:_sepLine];
    _sepLine.sd_layout
    .topSpaceToView(contentView, 0)
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .heightIs(1);
    _sepLine.backgroundColor  = KControlColor;
    
    _titleLabel = [UILabel new];
    [contentView addSubview:_titleLabel];
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, 15)
    .rightSpaceToView(contentView, 15)
    .heightIs(15)
    .topSpaceToView(contentView, 15);
    _titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(15)];
    _titleLabel.textColor = ZPMyOrderDetailFontColor;
    
    _iconView0 = [UIImageView new];
    _iconView1 = [UIImageView new];
    _iconView2 = [UIImageView new];
    [contentView sd_addSubviews:@[_iconView0,_iconView1,_iconView2]];
    _iconView0.sd_layout
    .leftSpaceToView(contentView,15)
    .heightIs(ZPHeight(76))
    .widthIs((SCREEN_WIDTH-40)/3)
    .topSpaceToView(_titleLabel, 10);
    _iconView0.contentMode = UIViewContentModeScaleAspectFill;
    _iconView0.clipsToBounds = YES;
    
    _iconView1.sd_layout
    .leftSpaceToView(_iconView0,5)
    .heightIs(ZPHeight(76))
    .widthRatioToView(_iconView0, 1)
    .topSpaceToView(_titleLabel, 10);
    _iconView1.contentMode = UIViewContentModeScaleAspectFill;
    _iconView1.clipsToBounds = YES;
    
    _iconView2.sd_layout
    .leftSpaceToView(_iconView1,5)
    .heightIs(ZPHeight(76))
    .widthRatioToView(_iconView0, 1)
    .topSpaceToView(_titleLabel, 10);
    _iconView2.contentMode = UIViewContentModeScaleAspectFill;
    _iconView2.clipsToBounds = YES;
    
    _pageViewLabel = [UILabel new];
    [contentView addSubview:_pageViewLabel];
    _pageViewLabel.sd_layout
    .rightSpaceToView(contentView, 15)
    .topSpaceToView(_iconView0, 10)
    .heightIs(12)
    .leftSpaceToView(contentView, 15);
    _pageViewLabel.textColor = ZPMyOrderDeleteBorderColor;
    _pageViewLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(12)];
    
    [self setupAutoHeightWithBottomViewsArray:@[_pageViewLabel,_iconView0,_titleLabel] bottomMargin:10];
}

- (void)setModel:(UHHealthWindModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:sss"];
    NSDate *resDate = [formatter dateFromString:model.createDate];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM月dd日";
    _pageViewLabel.text = [fmt stringFromDate:resDate];
    [_iconView0 sd_setImageWithURL:[NSURL URLWithString:model.titleImgList[0]] placeholderImage:[UIImage imageNamed:@"placeholder_comment"]];
    [_iconView1 sd_setImageWithURL:[NSURL URLWithString:model.titleImgList[1]] placeholderImage:[UIImage imageNamed:@"placeholder_comment"]];
    [_iconView2 sd_setImageWithURL:[NSURL URLWithString:model.titleImgList[2]] placeholderImage:[UIImage imageNamed:@"placeholder_comment"]];
}

@end
