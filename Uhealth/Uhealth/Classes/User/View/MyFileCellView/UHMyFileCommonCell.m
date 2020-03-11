//
//  UHMyFileCommonCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/6/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyFileCommonCell.h"
#import "UHMyFileDetailModel.h"
#import "UHMyfileDetailDataCell.h"
#import "UHMyFileCommonView.h"
@interface UHMyFileCommonCell()
@property (nonatomic,strong) UIView *rightView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UHMyFileCommonView *commonView;
@end
@implementation UHMyFileCommonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *contentView = self.contentView;
    contentView.backgroundColor = KControlColor;
  
    self.titleLabel = [UILabel new];
    self.rightView = [UIView new];
    
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 0;
    UIFont *font = [UIFont fontWithName:ZPPFSCMedium size:16];
    self.titleLabel.font = font;
    CGSize sizeWord = [@"一" sizeWithFont:font constrainedToSize:CGSizeMake(100, 1000.0) lineBreakMode:UILineBreakModeWordWrap];
    CGFloat width = sizeWord.width;//一个汉字的宽度
    
    [contentView addSubview:self.rightView];
    self.rightView.sd_layout
    .widthIs(42+10)
    .rightSpaceToView(contentView, 8)
    .topSpaceToView(contentView, 2)
    .bottomEqualToView(contentView);
    self.rightView.backgroundColor = RGB(78,178,255);
    [self.rightView addSubview:self.titleLabel];
    self.rightView.layer.cornerRadius = 10;
    self.rightView.layer.masksToBounds = YES;
    
    self.titleLabel.sd_layout
    .rightSpaceToView(self.rightView, 13)
    .topSpaceToView(self.rightView, 0)
    .bottomSpaceToView(self.rightView, 0)
    .widthIs(width);
    
    self.commonView = [UHMyFileCommonView new];
    [contentView addSubview:self.commonView];
    self.commonView.sd_layout
    .leftSpaceToView(contentView, 8)
    .rightSpaceToView(self.rightView, -10)
    .topSpaceToView(contentView, 0); // 已经在内部实现高度自适应所以不需要再设置高度
}

- (void)setModel:(UHMyFileDetailModel *)model {
    _model = model;
    self.titleLabel.text = model.modelName;
    if (!model.modelValue.count) {
        //获取右边的title的高度
        CGSize sizeWord2 = [model.modelName sizeWithFont:[UIFont fontWithName:ZPPFSCMedium size:16] constrainedToSize:CGSizeMake(self.titleLabel.width, 1000.0) lineBreakMode:UILineBreakModeWordWrap];
        [self.commonView setupNOData:sizeWord2.height];
    } else {
        self.commonView.modeName = model.modelName;
        [self.commonView setupWithItemsArray:model.modelValue];
       
    }
    [self setupAutoHeightWithBottomView:self.commonView bottomMargin:0];
}

- (void)setIsLastData:(BOOL)isLastData {
    _isLastData = isLastData;
}
@end
