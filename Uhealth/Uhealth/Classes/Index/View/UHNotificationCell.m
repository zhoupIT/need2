//
//  UHNotificationCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHNotificationCell.h"
#import "TTTAttributedLabel.h"
#import "YYText.h"
#import "UHNotiModel.h"
@interface UHNotificationCell()
{
    UILabel *_titleLabel;
    UILabel *_timeLabel;
//    YYLabel *_contentLabel;
    UILabel *_contentLabel;
    UIButton *_detailBtn;
    
    UIView *_redDot;
}
@end
@implementation UHNotificationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsZero;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *contentView = self.contentView;
    _titleLabel = [UILabel new];
    _timeLabel = [UILabel new];
    _contentLabel = [UILabel new];
    _detailBtn = [UIButton new];
    _redDot = [UIView new];
    [contentView sd_addSubviews:@[_titleLabel,_timeLabel,_contentLabel,_detailBtn,_redDot]];
    
    _titleLabel.sd_layout
    .topSpaceToView(contentView, 19)
    .leftSpaceToView(contentView, 15)
    .heightIs(14)
    .rightSpaceToView(contentView, 50);
    _titleLabel.textColor = ZPMyOrderDetailFontColor;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
    _timeLabel.sd_layout
    .rightSpaceToView(contentView, 15)
    .heightIs(11)
    .centerYEqualToView(_titleLabel);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:100];
    _timeLabel.textColor = ZPMyOrderDeleteBorderColor;
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textAlignment= NSTextAlignmentRight;
    
    _contentLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .rightSpaceToView(contentView, 15)
    .topSpaceToView(_titleLabel, 22)
    .autoHeightRatio(0);
    _contentLabel.textColor = ZPMyOrderDeleteBorderColor;
    _contentLabel.font = [UIFont fontWithName:ZPPFSCRegular size:14];
    
    
    _detailBtn.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_contentLabel, 22);
    [_detailBtn setupAutoSizeWithHorizontalPadding:0 buttonHeight:14];
    [_detailBtn setTitleColor:ZPMyOrderDetailValueFontColor forState:UIControlStateNormal];
    _detailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_detailBtn addTarget:self action:@selector(detailContentEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    _redDot.sd_layout
    .leftSpaceToView(_detailBtn, 5)
    .widthIs(7)
    .heightIs(7)
    .centerYEqualToView(_detailBtn);
    _redDot.backgroundColor = RGB(255,78,78);
    _redDot.layer.cornerRadius = 3.5;
    _redDot.layer.masksToBounds = YES;
    _redDot.hidden = YES;
    
    [self setupAutoHeightWithBottomView:_detailBtn bottomMargin:15];
}

- (void)setModel:(UHNotiModel *)model {
    _model = model;
    _titleLabel.text = model.messageType.text;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH-mm-sss"];
    NSDate *resDate = [formatter dateFromString:model.sendTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString *currentDateString = [dateFormatter stringFromDate:resDate];
    _timeLabel.text = currentDateString;
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    
    _contentLabel.text = model.content;
//    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:model.content];
//    contentString.yy_color = ZPMyOrderDeleteBorderColor;
//    contentString.yy_font = [UIFont systemFontOfSize:14];
//    contentString.yy_lineSpacing = 5;
//    [text appendAttributedString:contentString];
    if ([model.messageType.name isEqualToString:@"BODY_CHECK_SYSTEM_NOTICE"]) {
//        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc] initWithString:@"  查看检测结果>>"];
//        hintString.yy_font = [UIFont systemFontOfSize:14];
//        hintString.yy_color = ZPMyOrderDetailValueFontColor;
//        hintString.yy_lineSpacing = 5;
//        YYTextHighlight *highLight = [YYTextHighlight new];
//        [highLight setColor:ZPMyOrderDetailValueFontColor];
//
//        highLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//            ZPLog(@"查看报告");
//            if (self.detailContentBlock) {
//                self.detailContentBlock(model);
//            }
//        };
//        [hintString yy_setTextHighlight:highLight range:NSMakeRange(0, hintString.length)];
//         [text appendAttributedString:hintString];
        [_detailBtn setTitle:@"查看检测结果>>" forState:UIControlStateNormal];

        
    } else {
        [_detailBtn setTitle:@"" forState:UIControlStateNormal];
    }
    
    if ([model.messageStatus.name isEqualToString:@"UNREAD"]) {
        _redDot.hidden = NO;
    } else {
        _redDot.hidden = YES;
    }
//    _contentLabel.attributedText = text;
    
}

- (void)detailContentEvent:(UIButton *)btn {
    if (self.detailContentBlock) {
        self.detailContentBlock(self.model);
    }
}
@end
