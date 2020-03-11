//
//  UHMyFileTitleView.m
//  Uhealth
//
//  Created by Biao Geng on 2018/7/5.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyFileTitleView.h"
#import "UHModelValueModel.h"
@interface UHMyFileTitleView()
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *titlelable1;
@property (nonatomic,strong) UILabel *titlelable2;
@property (nonatomic,strong) UILabel *titlelable3;
@property (nonatomic, strong) NSArray *itemsArray;

@property (nonatomic, strong) NSMutableArray *labelsArray;
@property (nonatomic, strong) NSMutableArray *valuelabelArray;
@property (nonatomic, strong) NSMutableArray *unitlabelsArray;

@end

@implementation UHMyFileTitleView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    
    self.backgroundColor = [UIColor whiteColor];
    self.iconView = [UIImageView new];
    [self addSubview:self.iconView];
    self.iconView.sd_layout
    .topEqualToView(self)
    .leftSpaceToView(self, 17)
    .heightIs(3)
    .rightSpaceToView(self, 9);
    self.iconView.image = [UIImage imageNamed:@"myfile_separator_icon"];
    
    self.titlelable1 = [UILabel new];
    self.titlelable2 = [UILabel new];
    self.titlelable3 = [UILabel new];
    [self sd_addSubviews:@[self.titlelable1,self.titlelable2,self.titlelable3]];
    
    CGFloat w = (SCREEN_WIDTH-42-16-19-10)/3;
    
    self.titlelable1.sd_layout
    .topSpaceToView(self, 13)
    .leftSpaceToView(self, 19)
    .heightIs(15)
    .widthIs(w);
    self.titlelable1.textColor = RGB(78, 178, 255);
    self.titlelable1.font = [UIFont fontWithName:ZPPFSCRegular size:14];
    self.titlelable1.text = @"参数";
    
    self.titlelable2.sd_layout
    .centerYEqualToView(self.titlelable1)
    .leftSpaceToView(self.titlelable1, 5)
    .heightIs(15)
    .widthIs(w);
    self.titlelable2.textColor = RGB(78, 178, 255);
    self.titlelable2.font = [UIFont fontWithName:ZPPFSCRegular size:14];
    self.titlelable2.text = @"结果";
    
    self.titlelable3.sd_layout
    .centerYEqualToView(self.titlelable1)
    .leftSpaceToView(self.titlelable2, 5)
    .heightIs(15)
    .rightSpaceToView(self, -10);
    self.titlelable3.textColor = RGB(78, 178, 255);
    self.titlelable3.font = [UIFont fontWithName:ZPPFSCRegular size:14];
    self.titlelable3.text = @"单位";
}

- (void)setItemsArray:(NSArray *)itemsArray {
    _itemsArray = itemsArray;
    long originalLabelsCount = self.labelsArray.count;
    long needsToAddCount = itemsArray.count > originalLabelsCount ? (itemsArray.count - originalLabelsCount) : 0;
    for (int i = 0; i < needsToAddCount; i++) {
        UILabel *label = [UILabel new];
        label.font = [UIFont fontWithName:ZPPFSCRegular size:14];
        label.textColor = ZPMyOrderDetailFontColor;
        
        UILabel *label2 = [UILabel new];
        label2.font = [UIFont fontWithName:ZPPFSCRegular size:14];
        label2.textColor = ZPMyOrderDetailFontColor;
        
        UILabel *label3 = [UILabel new];
        label3.font = [UIFont fontWithName:ZPPFSCRegular size:14];
        label3.textColor = ZPMyOrderDetailFontColor;
        [self addSubview:label];
        [self addSubview:label2];
        [self addSubview:label3];
        [self.labelsArray addObject:label];
        [self.valuelabelArray addObject:label2];
        [self.unitlabelsArray addObject:label3];
    }
    
    for (int i = 0; i < itemsArray.count; i++) {
        UHModelValueModel *model = itemsArray[i];
        UILabel *label = self.labelsArray[i];
        label.text = [NSString stringWithFormat:@"%@",model.parameter];
        
        UILabel *label2 = self.valuelabelArray[i];
        label2.text = [NSString stringWithFormat:@"%@",model.value];
        
        UILabel *label3 = self.unitlabelsArray[i];
        label3.text = [NSString stringWithFormat:@"%@",model.unit];
    }
}

- (void)setupWithItemsArray:(NSArray *)itemsArray {
    
    self.itemsArray = itemsArray;
    
    if (self.labelsArray.count) {
        [self.labelsArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
            [label sd_clearAutoLayoutSettings];
            label.hidden = YES; //重用时先隐藏label，然后根据个数显示label
        }];
    }
    if (self.valuelabelArray.count) {
        [self.valuelabelArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
            [label sd_clearAutoLayoutSettings];
            label.hidden = YES; //重用时先隐藏label，然后根据个数显示label
        }];
    }
    
    if (self.unitlabelsArray.count) {
        [self.unitlabelsArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
            [label sd_clearAutoLayoutSettings];
            label.hidden = YES; //重用时先隐藏label，然后根据个数显示label
        }];
    }
    if (!itemsArray.count) {
        self.fixedWidth = @(0); //（设置了fixedWith的控件将不再在自动布局过程中调整宽度）
        self.fixedHeight = @(0); // （设置了fixedHeight的控件将不再在自动布局过程中调整高度）
        return;
    } else {
        self.fixedHeight = nil; // 取消固定宽度约束
        self.fixedWidth = nil; // 取消固定高度约束
    }
    
    UILabel *lastTopView = nil;
    CGFloat w = (SCREEN_WIDTH-42-16-19-10)/3;
    for (int i = 0; i < self.itemsArray.count; i++) {
        UILabel *label = (UILabel *)self.labelsArray[i];
        label.hidden = NO;
        
        if (i == 0) {
            label.sd_layout
            .leftSpaceToView(self, 19)
            .widthIs(w)
            .topSpaceToView(self.titlelable1, 33+3)
            .autoHeightRatio(0);
        } else {
            label.sd_layout
            .leftSpaceToView(self, 19)
            .widthIs(w)
            .topSpaceToView(lastTopView, 10)
            .autoHeightRatio(0);
        }
        lastTopView = label;
        
        UILabel *label2 = (UILabel *)self.valuelabelArray[i];
        label2.hidden = NO;
        
        label2.sd_layout
        .leftSpaceToView(label, 5)
        .widthIs(w)
        .centerYEqualToView(label)
        .heightRatioToView(label, 1);
        
        UILabel *label3 = (UILabel *)self.unitlabelsArray[i];
        label3.hidden = NO;
        
        label3.sd_layout
        .leftSpaceToView(label2, 5)
        .widthIs(w)
        .centerYEqualToView(label)
        .heightRatioToView(label, 1);
        
    }
    
    
    
    [self setupAutoHeightWithBottomView:lastTopView bottomMargin:22];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (NSMutableArray *)labelsArray
{
    if (!_labelsArray) {
        _labelsArray = [NSMutableArray new];
    }
    return _labelsArray;
}

- (NSMutableArray *)valuelabelArray
{
    if (!_valuelabelArray) {
        _valuelabelArray = [NSMutableArray new];
    }
    return _valuelabelArray;
}

- (NSMutableArray *)unitlabelsArray
{
    if (!_unitlabelsArray) {
        _unitlabelsArray = [NSMutableArray new];
    }
    return _unitlabelsArray;
}
@end

