//
//  UHHomeFunctionCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/9/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHHomeFunctionCell.h"
#import "UIButton+UHButton.h"
@implementation UHHomeFunctionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *contentView = self.contentView;
    NSArray *titleData = @[@"绿色通道",@"症状自查",@"身心咨询",@"直播讲堂",@"我的档案",@"健康资讯",@"个人保障",@"救援服务",@"家人服务",@"企业福利"];
    NSArray *imgData = @[@"home_functionGreen_icon",@"home_selfTest_icon",@"home_physicalCounsel_icon",@"home_onlinelecture_icon",@"home_myfile_icon",@"home_healthInfo_icon",@"home_personal_icon",@"home_service_icon",@"home_familyservice_icon",@"home_companyWelfare_icon"];
    UIButton *tempBtn;
    UIButton *tempBtn1;
    for (int i = 0; i<10; i++) {
        UIButton *btn = [UIButton new];
        [btn setImage:[UIImage imageNamed:imgData[i]] forState:UIControlStateNormal];
        [btn setTitle:titleData[i] forState:UIControlStateNormal];
        [btn setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(12)];
        btn.tag = 10001+i;
        [btn addTarget:self action:@selector(didClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
        CGFloat w = (SCREEN_WIDTH-ZPWidth(10)*2)/5;
        if (i == 0) {
            btn.sd_layout
            .widthIs(w)
            .heightIs(ZPHeight(58))
            .topSpaceToView(contentView, ZPHeight(20))
            .leftSpaceToView(contentView, ZPWidth(10));
             tempBtn = btn;
        } else if (i < 5) {
           btn.sd_layout
           .leftSpaceToView(tempBtn, 0)
           .widthIs(w)
            .topSpaceToView(contentView,ZPHeight(20))
            .heightIs(ZPHeight(58));
             tempBtn = btn;
        } else if (i == 5) {
            btn.sd_layout
            .leftSpaceToView(contentView, ZPWidth(10))
            .widthIs(w)
            .topSpaceToView(tempBtn, ZPHeight(15))
            .heightIs(ZPHeight(58));
             tempBtn1 = btn;
        } else if (i < 10) {
            btn.sd_layout
            .leftSpaceToView(tempBtn1, 0)
            .widthIs(w)
            .topSpaceToView(tempBtn,ZPHeight(15))
            .heightIs(ZPHeight(58));
            tempBtn1 = btn;
        }
        
        __weak UIButton *weakBtn = btn;
        btn.didFinishAutoLayoutBlock = ^(CGRect frame) {
            [weakBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:ZPHeight(15)];
            //修正在iPhone5上图片过大的bug
            weakBtn.imageView.sd_layout
            .widthIs(ZPWidth(33))
            .heightIs(ZPHeight(30))
            .topSpaceToView(weakBtn, 0);
            weakBtn.titleLabel.sd_layout
            .bottomSpaceToView(weakBtn, 0);
        };
    }
    
}

- (void)didClickEvent:(UIButton *)btn {
    if (self.didClickBlock) {
        self.didClickBlock(btn.tag);
    }
}

@end
