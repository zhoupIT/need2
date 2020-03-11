//
//  UHHealthWindOneImageCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHHealthWindOneImageCell.h"
#import "UHHealthWindModel.h"
#import "SDWeiXinPhotoContainerView.h"
@interface UHHealthWindOneImageCell()
{
    UILabel *_titleLabel;
//    UIView *_lineView;
//    SDWeiXinPhotoContainerView *_photoContainerView;
    UIImageView *_iconView;
    UIView *_sepLine;
    UILabel *_pageViewLabel;

}
@end
@implementation UHHealthWindOneImageCell
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
    
    _titleLabel = [UILabel new];
    [contentView addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = ZPMyOrderDetailFontColor;
    

    _iconView = [UIImageView new];
    [contentView sd_addSubviews:@[_iconView]];
    _iconView.sd_layout
    .rightSpaceToView(contentView, 15)
    .heightIs(ZPHeight(76))
    .widthIs(ZPWidth(116))
    .topSpaceToView(self.contentView, 15);
    _iconView.contentMode = UIViewContentModeScaleAspectFill;
    _iconView.clipsToBounds = YES;
    
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, 15)
    .rightSpaceToView(_iconView, 10)
    .autoHeightRatio(0)
    .topSpaceToView(contentView, 15);
    _titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(15)];
    [_titleLabel setMaxNumberOfLinesToShow:2];
    

    _pageViewLabel = [UILabel new];
    [contentView addSubview:_pageViewLabel];
    _pageViewLabel.sd_layout
    .bottomEqualToView(_iconView)
    .leftSpaceToView(contentView, 15)
    .heightIs(11)
    .rightSpaceToView(_iconView, 5);
    _pageViewLabel.textColor = ZPMyOrderDeleteBorderColor;
    _pageViewLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(12)];
    
    _sepLine = [UIView new];
    [contentView addSubview:_sepLine];
    _sepLine.sd_layout
    .topSpaceToView(contentView, 0)
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .heightIs(1);
    _sepLine.backgroundColor  = KControlColor;
    
    [self setupAutoHeightWithBottomViewsArray:@[_iconView,_titleLabel] bottomMargin:10];
}




- (void)setModel:(UHHealthWindModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.titleImgList.firstObject] placeholderImage:[UIImage imageNamed:@"placeholder_comment"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:sss"];
    NSDate *resDate = [formatter dateFromString:model.createDate];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM月dd日";
    _pageViewLabel.text = [fmt stringFromDate:resDate];
}

@end
