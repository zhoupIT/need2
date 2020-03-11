//
//  UHHomeCenterCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/9/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHHomeCenterCell.h"
#import "UIButton+UHButton.h"
@interface UHHomeCenterCell()
{
    UIButton *_WCenterButton;//微生态
    UIButton *_JCenterButton;//颈椎调理中心
    UIButton *_ZCenterButton;//中医养生中心
}
@end
@implementation UHHomeCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *contentView = self.contentView;
    contentView.backgroundColor = KControlColor;
    _WCenterButton = [UIButton new];
    _JCenterButton = [UIButton new];
    _ZCenterButton = [UIButton new];
    [contentView sd_addSubviews:@[_WCenterButton,_JCenterButton,_ZCenterButton]];
    _WCenterButton.sd_layout
    .leftSpaceToView(contentView, 0)
    .topSpaceToView(contentView, 0)
    .bottomSpaceToView(contentView, 0)
    .widthIs((SCREEN_WIDTH-1)*0.5);
    
    __weak UIButton *weakWCenterButton = _WCenterButton;
    _WCenterButton.didFinishAutoLayoutBlock = ^(CGRect frame) {
         [weakWCenterButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:10];
    };
    _WCenterButton.tag = 10001;
    [_WCenterButton addTarget:self action:@selector(didClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_WCenterButton setBackgroundColor:[UIColor whiteColor]];
    [_WCenterButton setTitle:@"微生态中心" forState:UIControlStateNormal];
    [_WCenterButton setImage:[UIImage imageNamed:@"home_wCenter_icon"] forState:UIControlStateNormal];
    [_WCenterButton setImage:[UIImage imageNamed:@"home_wCenter_icon"] forState:UIControlStateHighlighted];
    _WCenterButton.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(14)];
     [_WCenterButton setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
    
    
    _JCenterButton.sd_layout
    .rightSpaceToView(contentView, 0)
    .topSpaceToView(contentView, 0)
    .heightRatioToView(contentView, 0.5)
    .widthIs((SCREEN_WIDTH-1)*0.5);
    __weak UIButton *weakJCenterButton = _JCenterButton;
    _JCenterButton.didFinishAutoLayoutBlock = ^(CGRect frame) {
        [weakJCenterButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:10];
    };
    _JCenterButton.tag = 10002;
    [_JCenterButton addTarget:self action:@selector(didClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_JCenterButton setBackgroundColor:[UIColor whiteColor]];
    [_JCenterButton setTitle:@"颈椎调理中心" forState:UIControlStateNormal];
    [_JCenterButton setImage:[UIImage imageNamed:@"home_jCenter_icon"] forState:UIControlStateNormal];
    [_JCenterButton setImage:[UIImage imageNamed:@"home_jCenter_icon"] forState:UIControlStateHighlighted];
    _JCenterButton.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(14)];
    [_JCenterButton setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
    
    _ZCenterButton.sd_layout
    .rightSpaceToView(contentView, 0)
    .topSpaceToView(_JCenterButton, 1)
    .bottomSpaceToView(contentView, 0)
    .widthIs((SCREEN_WIDTH-1)*0.5);
    __weak UIButton *weakZCenterButton = _ZCenterButton;
    _ZCenterButton.didFinishAutoLayoutBlock = ^(CGRect frame) {
         [weakZCenterButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:10];
    };
    _ZCenterButton.tag = 10003;
    [_ZCenterButton addTarget:self action:@selector(didClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_ZCenterButton setBackgroundColor:[UIColor whiteColor]];
    [_ZCenterButton setTitle:@"中医养生中心" forState:UIControlStateNormal];
    [_ZCenterButton setImage:[UIImage imageNamed:@"home_zCenter_icon"] forState:UIControlStateNormal];
    [_ZCenterButton setImage:[UIImage imageNamed:@"home_zCenter_icon"] forState:UIControlStateHighlighted];
    _ZCenterButton.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(14)];
     [_ZCenterButton setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
    
}

- (void)didClickEvent:(UIButton *)btn {
    if (self.didClickBlock) {
        self.didClickBlock(btn.tag);
    }
}

@end
