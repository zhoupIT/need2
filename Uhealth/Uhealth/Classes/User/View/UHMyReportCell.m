//
//  UHMyReportCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyReportCell.h"
#import "UHMyReportModel.h"
#import "YYText.h"
@interface UHMyReportCell()
{
    UILabel *_timeLabel;
    UIView *_boardView;
    YYLabel *_contentLabel;
}
@end

@implementation UHMyReportCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *contentView = self.contentView;
    _boardView = [UIView new];
    _timeLabel = [UILabel new];
    _contentLabel = [YYLabel new];
    [contentView sd_addSubviews:@[_boardView,_timeLabel]];
    _timeLabel.sd_layout
    .centerXEqualToView(contentView)
    .widthIs(142)
    .heightIs(24)
    .topSpaceToView(contentView, 9);
    _timeLabel.layer.cornerRadius = 5;
    _timeLabel.layer.masksToBounds = YES;
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.backgroundColor = RGB(204, 204, 204);
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:15];
    
    _boardView.sd_layout
    .leftSpaceToView(contentView, 15)
    .rightSpaceToView(contentView, 15)
    .topSpaceToView(_timeLabel, 10)
    .heightIs(0);
    _boardView.layer.borderColor = RGB(204, 204, 204).CGColor;
    _boardView.layer.borderWidth = 1;
    
    [_boardView addSubview:_contentLabel];
    
    _contentLabel.sd_layout
    .leftSpaceToView(_boardView, 5)
    .rightSpaceToView(_boardView, 5)
    .topSpaceToView(_boardView, 5)
    .bottomSpaceToView(_boardView, 5);
   
    
//    _contentLabel.textColor = ZPMyOrderDetailFontColor;
//    _contentLabel.font = [UIFont systemFontOfSize:15];
//    _contentLabel.layer.borderColor = RGB(204, 204, 204).CGColor;
//    _contentLabel.layer.borderWidth = 1;
    
   
    
    /*
     _contentLabel.sd_layout
     .leftEqualToView(_titleLabel)
     .heightIs(38)
     .rightSpaceToView(contentView, 15)
     .topSpaceToView(_titleLabel, 22);
     NSMutableAttributedString *text = [NSMutableAttributedString new];
     
     NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:@"您在漕河泾交通银行健康小屋的检测结果已经出来了"];
     contentString.yy_color = ZPMyOrderDeleteBorderColor;
     contentString.yy_font = [UIFont systemFontOfSize:14];
     contentString.yy_lineSpacing = 5;
     
     NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc] initWithString:@"  查看检测结果>>"];
     hintString.yy_font = [UIFont systemFontOfSize:14];
     hintString.yy_color = ZPMyOrderDetailValueFontColor;
     hintString.yy_lineSpacing = 5;
     YYTextHighlight *highLight = [YYTextHighlight new];
     [highLight setColor:ZPMyOrderDetailValueFontColor];
     
     highLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
     ZPLog(@"查看报告");
     };
     [hintString yy_setTextHighlight:highLight range:NSMakeRange(0, hintString.length)];
     
     [text appendAttributedString:contentString];
     [text appendAttributedString:hintString];
     _contentLabel.attributedText = text;
     
     
     _contentLabel.numberOfLines = 2;
     */
}

- (void)setModel:(UHMyReportModel *)model {
    _model = model;
    _timeLabel.text = model.createDate;
    NSString *str = [NSString stringWithFormat:@"%@",model.message];
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:str];
    one.yy_font = [UIFont systemFontOfSize:15];
    one.yy_color = ZPMyOrderDetailFontColor;
    
    [text appendAttributedString:one];
    
    if (self.pageIndex == 1) {
        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc] initWithString:@"  查看详情>>"];
        hintString.yy_font = [UIFont systemFontOfSize:14];
        hintString.yy_color = ZPMyOrderDetailValueFontColor;
        hintString.yy_lineSpacing = 5;
        YYTextHighlight *highLight = [YYTextHighlight new];
        [highLight setColor:ZPMyOrderDetailValueFontColor];
        
        highLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            ZPLog(@"查看详情");
        };
        [hintString yy_setTextHighlight:highLight range:NSMakeRange(0, hintString.length)];
        [text appendAttributedString:hintString];
    }

    _contentLabel.numberOfLines = 0;
    _contentLabel.attributedText = text;
    _contentLabel.backgroundColor = [UIColor whiteColor];

    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(SCREEN_WIDTH-40, CGFLOAT_MAX) text:text];
    
    _boardView.sd_layout.heightIs(layout.textBoundingSize.height+10)
    .widthIs(SCREEN_WIDTH-30);
    [_boardView updateLayout];
    
     [self setupAutoHeightWithBottomViewsArray:@[_boardView] bottomMargin:10];
}
@end
