//
//  UHRadarPopTableViewCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/7/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHRadarPopTableViewCell.h"
#import "UHGetScore.h"
@interface UHRadarPopTableViewCell()
{
    UILabel *_nameLabel;//量表的名字
    UILabel *_scoreLabel;
}
@end
@implementation UHRadarPopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initAll];
    }
    return self;
}

- (void)initAll {
    self.backgroundColor = [UIColor clearColor];
    UIView *contenView =self.contentView;
    _nameLabel = [UILabel new];
    [contenView addSubview:_nameLabel];
    _nameLabel.sd_layout
    .leftSpaceToView(contenView, 8)
    .topSpaceToView(contenView, 0)
    .widthIs(115)
    .autoHeightRatio(0);
    _nameLabel.textColor = ZPMyOrderDetailFontColor;
    _nameLabel.font = [UIFont fontWithName:ZPPFSCRegular size:12];
    
    _scoreLabel = [UILabel new];
    [contenView addSubview:_scoreLabel];
    _scoreLabel.sd_layout
    .leftSpaceToView(_nameLabel, 0)
    .rightSpaceToView(contenView, 12)
    .topSpaceToView(contenView, 0)
    .autoHeightRatio(0);
    _scoreLabel.textAlignment = NSTextAlignmentRight;
    _scoreLabel.textColor = RGB(255,215,59);
    _scoreLabel.font = [UIFont fontWithName:ZPPFSCMedium size:13];
    
    [self setupAutoHeightWithBottomView:_nameLabel bottomMargin:13];
    
}

- (void)setModel:(UHGetScore *)model {
    _nameLabel.text = [NSString stringWithFormat:@"%@:",[self updateTitle:model.title]];
    _scoreLabel.text = [NSString stringWithFormat:@"%@分",model.score];
    _scoreLabel.textColor = [self colorWithScore:model.score];
}

- (NSString *)updateTitle:(NSString *)title {
    if ([title isEqualToString:@"情绪"]) {
        return @"情绪量表";
    } else if ([title isEqualToString:@"睡眠"]) {
        return @"睡眠量表";
    } else if ([title isEqualToString:@"焦虑"]) {
        return @"焦虑与躯体不适量表";
    } else if ([title isEqualToString:@"疼痛"]) {
        return @"疼痛量表";
    }else if ([title isEqualToString:@"性功能"]) {
        return @"性功能量表";
    }else if ([title isEqualToString:@"满意度"]) {
        return @"快乐和满意度量表";
    }else if ([title isEqualToString:@"疑病"]) {
        return @"疑病量表";
    }else if ([title isEqualToString:@"社交"]) {
        return @"社交障碍量表";
    }
    return @"";
}

- (UIColor *)colorWithScore:(NSString *)score {
    float s = [score floatValue];
    if (s>2 && s<=3) {
        return RGB(255, 0, 0);
    } else if (s>1 && s<=2) {
        return RGB(255, 210, 0);
    }
    return RGB(51, 203, 111);
}
@end
