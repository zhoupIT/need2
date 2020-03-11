//
//  UHMyfileDetailDataCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/6/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyfileDetailDataCell.h"
#import "UHModelValueModel.h"
@interface UHMyfileDetailDataCell()
@property (nonatomic,strong) UILabel *paramLabel;
@property (nonatomic,strong) UILabel *resultLabel;
@property (nonatomic,strong) UILabel *unitLabel;
@end
@implementation UHMyfileDetailDataCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *contentView = self.contentView;
    
    self.paramLabel  = [UILabel new];
    self.resultLabel = [UILabel new];
    self.unitLabel  =[UILabel new];

    [contentView sd_addSubviews:@[self.paramLabel,self.resultLabel,self.unitLabel]];

    
    self.paramLabel.sd_layout
    .centerYEqualToView(contentView)
    .leftSpaceToView(contentView, 19)
    .heightIs(15)
    .widthIs((SCREEN_WIDTH-56)/3);
    self.paramLabel.textColor = ZPMyOrderDetailFontColor;
    self.paramLabel.font = [UIFont fontWithName:ZPPFSCRegular size:14];
    self.paramLabel.text = @"体温";

    self.resultLabel.sd_layout
    .centerYEqualToView(contentView)
    .leftSpaceToView(self.paramLabel, 0)
    .heightIs(15)
    .widthIs((SCREEN_WIDTH-56)/3);
    self.resultLabel.textColor = ZPMyOrderDetailFontColor;
    self.resultLabel.font = [UIFont fontWithName:ZPPFSCRegular size:14];
    self.resultLabel.text = @"37";

    self.unitLabel.sd_layout
    .centerYEqualToView(contentView)
    .leftSpaceToView(self.resultLabel, 0)
    .heightIs(15)
    .rightSpaceToView(contentView, 0);
    self.unitLabel.textColor = ZPMyOrderDetailFontColor;
    self.unitLabel.font = [UIFont fontWithName:ZPPFSCRegular size:14];
    self.unitLabel.text = @"℃";
}

- (void)setModel:(UHModelValueModel *)model {
    _model = model;
    self.paramLabel.text = model.parameter;
    self.resultLabel.text = model.value;
    self.unitLabel.text = model.unit;
}
@end
