//
//  UHBloodPressureCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/9.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHBloodPressureCell.h"
#import "UHBloodPressureModel.h"
#import "UHUserModel.h"
#import "UHNiBPModel.h"
@interface UHBloodPressureCell()
{
    UILabel *_bloodValueLabel;
    UILabel *_stateLabel;
    UILabel *_fromLabel;
    UILabel *_timeLabel;
    UIButton *_checkBtn;
}
@end
@implementation UHBloodPressureCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _bloodValueLabel = [UILabel new];
    _stateLabel = [UILabel new];
    _fromLabel = [UILabel new];
    _timeLabel = [UILabel new];
    _checkBtn = [UIButton new];
    [self.contentView sd_addSubviews:@[_bloodValueLabel,_stateLabel,_fromLabel,_timeLabel,_checkBtn]];
    #warning 这边暂时不开放企业用户的功能,注释掉
    
    /*
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        UHUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
        if (![model.companyName isEqualToString:@""]) {
            self.isCompany = YES;
        }
    }
    */
    
    CGFloat bloodValueLabelWidth = self.isCompany?50:80;
    
    _bloodValueLabel.sd_layout
    .leftEqualToView(self.contentView)
    .heightIs(40)
    .widthIs(bloodValueLabelWidth)
    .topEqualToView(self.contentView);
    _bloodValueLabel.textColor = ZPMyOrderDetailFontColor;
    _bloodValueLabel.textAlignment = NSTextAlignmentCenter;
    _bloodValueLabel.font = [UIFont systemFontOfSize:12];
    
    _stateLabel.sd_layout
    .leftSpaceToView(_bloodValueLabel, 0)
    .heightIs(40)
    .widthIs(100)
    .topEqualToView(self.contentView);
    _stateLabel.textColor = ZPMyOrderDetailFontColor;
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    _stateLabel.font = [UIFont systemFontOfSize:12];
    
    _fromLabel.sd_layout
    .leftSpaceToView(_stateLabel, 0)
    .heightIs(40)
    .widthIs(60)
    .topEqualToView(self.contentView);
    _fromLabel.textColor = ZPMyOrderDetailFontColor;
    _fromLabel.textAlignment = NSTextAlignmentCenter;
    _fromLabel.font = [UIFont systemFontOfSize:12];
    
    
    if (self.isCompany) {
        
        _checkBtn.sd_layout
        .widthIs(40)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(40)
        .topEqualToView(self.contentView);
        [_checkBtn setTitleColor:RGB(99, 187, 255) forState:UIControlStateNormal];
        [_checkBtn setTitle:@"查看" forState:UIControlStateNormal];
        [_checkBtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
        _checkBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        _timeLabel.sd_layout
        .leftSpaceToView(_fromLabel, 0)
        .heightIs(40)
        .rightSpaceToView(_checkBtn, 0)
        .topEqualToView(self.contentView);
        _timeLabel.textColor = ZPMyOrderDetailFontColor;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        
        
    } else {
        _timeLabel.sd_layout
        .leftSpaceToView(_fromLabel, 0)
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
    _bloodValueLabel.text = model.bloodValue;
    _stateLabel.text = model.type;
    _fromLabel.text = model.fromType;
    _timeLabel.text  =model.time;
}

//血压
- (void)setBibpModel:(UHNiBPModel *)bibpModel {
    _bibpModel = bibpModel;
    _bloodValueLabel.text = [NSString stringWithFormat:@"%@/%@",bibpModel.sbp,bibpModel.dbp];
    _stateLabel.text = bibpModel.level.text;
    _fromLabel.text = bibpModel.collectType.text;
    _timeLabel.text  =bibpModel.detectDate;
}

//血氧
- (void)setSpoModel:(UHNiBPModel *)spoModel {
    _spoModel = spoModel;
    _bloodValueLabel.text = spoModel.spo2;
    _stateLabel.text = spoModel.level.text;
    _fromLabel.text = spoModel.collectType.text;
    _timeLabel.text  =spoModel.detectDate;
}

//血糖
- (void)setGluModel:(UHNiBPModel *)gluModel {
    _gluModel = gluModel;
    _bloodValueLabel.text = gluModel.glu;
    _stateLabel.text = gluModel.level.text;
    _fromLabel.text = gluModel.collectType.text;
    _timeLabel.text  =gluModel.detectDate;
}

//身体指数
- (void)setBodyIndexModel:(UHNiBPModel *)bodyIndexModel {
    _bodyIndexModel = bodyIndexModel;
    _bloodValueLabel.text = bodyIndexModel.bfr;
    _stateLabel.text = bodyIndexModel.bfrLevel.text;
    _fromLabel.text = bodyIndexModel.collectType.text;
    _timeLabel.text  =bodyIndexModel.detectDate;
}

//体重
- (void)setWeightModel:(UHNiBPModel *)weightModel {
    _weightModel = weightModel;
    _bloodValueLabel.text = weightModel.weight;
    _stateLabel.text = weightModel.level.text;
    _fromLabel.text = weightModel.collectType.text;
    _timeLabel.text  =weightModel.detectDate;
}

//血脂
- (void)setBfModel:(UHNiBPModel *)bfModel {
    _bfModel = bfModel;
    _bloodValueLabel.text = bfModel.mark;
    _stateLabel.text = bfModel.value;
    _fromLabel.text = bfModel.level.text;
    _timeLabel.text  =bfModel.detectDate;
}

- (void)checkAction:(UIButton *)btn {
    if (self.checkBlock) {
        switch (self.diseaseType) {
            case 0:
                {
                    self.checkBlock(self.bibpModel);
                }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                self.checkBlock(self.spoModel);
            }
                break;
            case 3:
            {
                self.checkBlock(self.gluModel);
            }
                break;
            case 4:
            {
                self.checkBlock(self.bodyIndexModel);
            }
                break;
            case 5:
            {
                self.checkBlock(self.weightModel);
            }
                break;
            case 6:
            {
                self.checkBlock(self.bfModel);
            }
                break;
            default:
                break;
        }
       
    }
}
@end
