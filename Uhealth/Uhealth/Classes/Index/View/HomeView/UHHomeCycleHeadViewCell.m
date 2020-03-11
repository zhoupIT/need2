//
//  UHHomeCycleHeadViewCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/9/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHHomeCycleHeadViewCell.h"
#import "SDCycleScrollView.h"
@interface UHHomeCycleHeadViewCell()<SDCycleScrollViewDelegate>
{
    SDCycleScrollView *_imgCycleView;//图片轮播
    UIView *_cardView;//卡片View
    
    UIButton *_psyAssessmentBtn;//心理测评
    UIView *_sepLine;//分割线
    UIButton *_phyTestBtn;//生理检测
}
@end
@implementation UHHomeCycleHeadViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *contentView = self.contentView;
    _imgCycleView = [SDCycleScrollView new];
    _cardView = [UIView new];
    [contentView sd_addSubviews:@[_imgCycleView,_cardView]];
    _imgCycleView.sd_layout
    .topSpaceToView(contentView, 0)
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .heightIs(ZPHeight(180));
    _imgCycleView.delegate = self;
    _imgCycleView.autoScrollTimeInterval = 3;
    
    _cardView.sd_layout
    .topSpaceToView(_imgCycleView, -5)
    .leftSpaceToView(contentView, 8)
    .rightSpaceToView(contentView, 8)
    .heightIs(ZPHeight(80));
    _cardView.backgroundColor = [UIColor whiteColor];
    _cardView.layer.cornerRadius = 10;
    _cardView.layer.shadowColor = RGB(232, 232, 232).CGColor;//设置阴影颜色
    _cardView.layer.shadowOpacity = 1.0f;////设置阴影透明度
    _cardView.layer.shadowOffset = CGSizeMake(0,5);//x轴和y轴的偏移量
    _cardView.layer.shadowRadius=10;//设置阴影半径
    
    
    _psyAssessmentBtn = [UIButton new];
    _phyTestBtn = [UIButton new];
    _sepLine = [UIView new];
    [_cardView sd_addSubviews:@[_psyAssessmentBtn,_phyTestBtn,_sepLine]];
    _psyAssessmentBtn.sd_layout
    .leftSpaceToView(_cardView, 0)
    .topSpaceToView(_cardView, 0)
    .bottomSpaceToView(_cardView, 0)
    .widthIs((SCREEN_WIDTH-17)*0.5);
    [_psyAssessmentBtn setImage:[UIImage imageNamed:@"home_psyAssessment_icon"] forState:UIControlStateNormal];
    [_psyAssessmentBtn setImage:[UIImage imageNamed:@"home_psyAssessment_icon"] forState:UIControlStateHighlighted];
    [_psyAssessmentBtn setTitle:@"心理测评" forState:UIControlStateNormal];
    [_psyAssessmentBtn setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
    _psyAssessmentBtn.titleLabel.font = [UIFont fontWithName:ZPPFSCMedium size:ZPFontSize(15)];
    [_psyAssessmentBtn addTarget:self action:@selector(psyEvent) forControlEvents:UIControlEventTouchUpInside];
    
    _sepLine.sd_layout
    .leftSpaceToView(_psyAssessmentBtn, 0)
    .topSpaceToView(_cardView, 0)
    .bottomSpaceToView(_cardView, 0)
    .widthIs(1);
    _sepLine.backgroundColor = KControlColor;
    
    _phyTestBtn.sd_layout
    .leftSpaceToView(_sepLine, 0)
    .topSpaceToView(_cardView, 0)
    .bottomSpaceToView(_cardView, 0)
    .widthIs((SCREEN_WIDTH-17)*0.5);
    [_phyTestBtn setImage:[UIImage imageNamed:@"home_phyTest_icon"] forState:UIControlStateNormal];
    [_phyTestBtn setImage:[UIImage imageNamed:@"home_phyTest_icon"] forState:UIControlStateHighlighted];
    [_phyTestBtn setTitle:@"生理检测" forState:UIControlStateNormal];
    [_phyTestBtn setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
    _phyTestBtn.titleLabel.font = [UIFont fontWithName:ZPPFSCMedium size:ZPFontSize(15)];
    [_phyTestBtn addTarget:self action:@selector(phyEvent) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setData:(NSArray *)data {
    _data = data;
    _imgCycleView.imageURLStringsGroup = data;
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.bannerImgClickBlock) {
        self.bannerImgClickBlock(index);
    }
}

- (void)psyEvent {
    if (self.psyClickBlock) {
        self.psyClickBlock();
    }
}

- (void)phyEvent {
    if (self.phyClickBlock) {
        self.phyClickBlock();
    }
}
@end
