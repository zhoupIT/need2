//
//  UHMyFileCommonView.m
//  Uhealth
//
//  Created by Biao Geng on 2018/7/5.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyFileCommonView.h"
#import "UHModelValueModel.h"
@interface UHMyFileCommonView()
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic, strong) NSArray *itemsArray;

@property (nonatomic, strong) NSMutableArray *labelsArray;
@property (nonatomic, strong) NSMutableArray *valuelabelArray;
@property (nonatomic, strong) NSMutableArray *unitlabelsArray;
@end

@implementation UHMyFileCommonView
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
    
//    for (int i = 0; i < needsToAddCount; i++) {
//        UILabel *label = [UILabel new];
//        label.font = [UIFont systemFontOfSize:14];
//        label.textColor = [UIColor redColor];
//        [self addSubview:label];
//        [self.valuelabelArray addObject:label];
//    }
    
    
    
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
    CGFloat w = (SCREEN_WIDTH-87)/3;
    
    CGFloat esHeight = 0;
    for (int i = 0; i < self.itemsArray.count; i++) {
        UILabel *label = (UILabel *)self.labelsArray[i];
        label.hidden = NO;
        
        if (i == 0) {
            label.sd_layout
            .leftSpaceToView(self, 19)
            .widthIs(w)
            .topSpaceToView(self, 22+3)
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
       
        CGSize sizeWord2 = [label.text sizeWithFont:[UIFont fontWithName:ZPPFSCRegular size:14] constrainedToSize:CGSizeMake(w, 1000.0) lineBreakMode:UILineBreakModeWordWrap];
        esHeight += sizeWord2.height;
    }
    if ([self.modeName isEqualToString:@"用药情况"]) {
        //判断右边的title与文字的高度
        if (esHeight < 115) {
            [self setupAutoHeightWithBottomView:lastTopView bottomMargin:(115-esHeight)];
        }else {
            [self setupAutoHeightWithBottomView:lastTopView bottomMargin:22];
        }
    } else {
       [self setupAutoHeightWithBottomView:lastTopView bottomMargin:22];
    }
    
}

- (void)setupNOData:(CGFloat)height {
    //设置一个空的view 占位置
    UILabel *label = [UILabel new];
    [self addSubview:label];
    label.sd_layout
    .leftSpaceToView(self, 19)
    .widthIs(10)
    .topSpaceToView(self, 22+3)
    .heightIs(height);
    [self setupAutoHeightWithBottomView:label bottomMargin:0];
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
