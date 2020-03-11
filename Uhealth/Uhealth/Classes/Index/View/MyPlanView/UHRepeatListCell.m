//
//  UHRepeatListCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHRepeatListCell.h"
#import "UHRepeatListModel.h"
@interface UHRepeatListCell()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *btn;
@end
@implementation UHRepeatListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.titleLabel = [UILabel new];
    self.btn = [UIButton new];
    [self.contentView sd_addSubviews:@[self.titleLabel,self.btn]];
    
    self.btn.sd_layout
    .rightSpaceToView(self.contentView, 16)
    .heightIs(24)
    .widthIs(24)
    .centerYEqualToView(self.contentView);
    [self.btn setImage:[UIImage imageNamed:@"noselected"] forState:UIControlStateNormal];
    [self.btn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [self.btn addTarget:self action:@selector(sel:) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 16)
    .heightIs(14)
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.btn, 5);
    self.titleLabel.textColor = ZPMyOrderDetailFontColor;
    self.titleLabel.font  = [UIFont systemFontOfSize:14];
}

- (void)sel:(UIButton *)btn {
    if (self.selBlock) {
        self.selBlock();
    }
}

- (void)setModel:(UHRepeatListModel *)model {
    _model = model;
     self.titleLabel.text = model.title;
    self.btn.selected = model.isSel;
}
@end
