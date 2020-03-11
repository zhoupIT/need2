//
//  UHBuaCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/9.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHBuaCell.h"
#import "UHBloodPressureModel.h"
#import "UHUserModel.h"
#import "UHNiBPModel.h"
@interface UHBuaCell()
{
    UILabel *_buaValueLabel;
    UILabel *_stateLabel;
    UILabel *_timeLabel;
    UIButton *_checkBtn;
}
@end
@implementation UHBuaCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _buaValueLabel = [UILabel new];
    _stateLabel = [UILabel new];
    _timeLabel = [UILabel new];
    _checkBtn = [UIButton new];
    [self.contentView sd_addSubviews:@[_buaValueLabel,_stateLabel,_timeLabel,_checkBtn]];
    #warning 这边暂时不开放企业用户的功能,注释掉
    /*
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        UHUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
        if (![model.companyName isEqualToString:@""]) {
            self.isCompany = YES;
        }
    }
     */
    
    _buaValueLabel.sd_layout
    .leftEqualToView(self.contentView)
    .heightIs(40)
    .widthIs(100)
    .topEqualToView(self.contentView);
    _buaValueLabel.textColor = ZPMyOrderDetailFontColor;
    _buaValueLabel.textAlignment = NSTextAlignmentCenter;
    _buaValueLabel.font = [UIFont systemFontOfSize:12];
    
    _stateLabel.sd_layout
    .leftSpaceToView(_buaValueLabel, 0)
    .heightIs(40)
    .widthIs(100)
    .topEqualToView(self.contentView);
    _stateLabel.textColor = ZPMyOrderDetailFontColor;
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    _stateLabel.font = [UIFont systemFontOfSize:12];
    
    if (self.isCompany) {
        
        _checkBtn.sd_layout
        .widthIs(40)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(40)
        .topEqualToView(self.contentView);
        [_checkBtn setTitleColor:RGB(99, 187, 255) forState:UIControlStateNormal];
        [_checkBtn setTitle:@"查看" forState:UIControlStateNormal];
        _checkBtn.titleLabel.font = [UIFont systemFontOfSize:12];
         [_checkBtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _timeLabel.sd_layout
        .leftSpaceToView(_stateLabel, 0)
        .heightIs(40)
        .rightSpaceToView(_checkBtn, 0)
        .topEqualToView(self.contentView);
        _timeLabel.textColor = ZPMyOrderDetailFontColor;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        
        
    } else {
        _timeLabel.sd_layout
        .leftSpaceToView(_stateLabel, 0)
        .heightIs(40)
        .rightSpaceToView(self.contentView, 0)
        .topEqualToView(self.contentView);
        _timeLabel.textColor = ZPMyOrderDetailFontColor;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    
}

- (void)setModel:(UHBloodPressureModel *)model {
    _model = model;
    _buaValueLabel.text = model.bloodValue;
    _stateLabel.text = model.type;

    _timeLabel.text  =model.time;
}


- (void)setUaModel:(UHNiBPModel *)uaModel {
    _uaModel = uaModel;
    _buaValueLabel.text = uaModel.ua;
    _stateLabel.text = uaModel.collectType.text;
    _timeLabel.text  =uaModel.detectDate;
}

- (void)checkAction:(UIButton *)btn {
    if (self.checkBlock) {
        self.checkBlock(self.uaModel);
    }
}
@end
