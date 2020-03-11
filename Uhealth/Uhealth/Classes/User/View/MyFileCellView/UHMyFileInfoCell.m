//
//  UHMyFileInfoCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/6/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyFileInfoCell.h"
#import "UHMyFileDetailModel.h"
@interface UHMyFileInfoCell()
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *showView;
@property (nonatomic,strong) UIView *rightView;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *sexLabel;
@property (nonatomic,strong) UILabel *birthLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *locLabel;
@end
@implementation UHMyFileInfoCell

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
    self.backView = [UIView new];
    self.showView = [UIView new];
    self.titleLabel = [UILabel new];
    self.rightView = [UIView new];
    
    [contentView addSubview:self.backView];
    self.backView.sd_layout
    .leftSpaceToView(contentView, 8)
    .rightSpaceToView(contentView, 8)
    .topEqualToView(contentView)
    .bottomEqualToView(contentView);
    self.backView.backgroundColor =KControlColor;
    
    [self.backView sd_addSubviews:@[self.rightView,self.showView]];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 0;
    UIFont *font = [UIFont fontWithName:ZPPFSCMedium size:16];
    self.titleLabel.font = font;
    CGSize sizeWord = [@"一" sizeWithFont:font constrainedToSize:CGSizeMake(100, 1000.0) lineBreakMode:UILineBreakModeWordWrap];
    CGFloat width = sizeWord.width;//一个汉字的宽度
    
    self.rightView.sd_layout
    .widthIs(width+36)
    .rightSpaceToView(self.backView, 0)
    .topSpaceToView(self.backView, 2)
    .bottomEqualToView(self.backView);
    self.rightView.backgroundColor = RGB(78,178,255);
    [self.rightView addSubview:self.titleLabel];
    self.rightView.layer.cornerRadius = 10;
    self.rightView.layer.masksToBounds = YES;
    
    self.titleLabel.sd_layout
    .rightSpaceToView(self.rightView, 13)
    .topSpaceToView(self.rightView, 0)
    .bottomSpaceToView(self.rightView, 0)
    .widthIs(width);
    self.titleLabel.text = @"人员信息";
    
    
    self.showView.backgroundColor = [UIColor whiteColor];
    self.showView.sd_layout
    .leftSpaceToView(self.backView, 0)
    .topSpaceToView(self.backView, 0)
    .bottomSpaceToView(self.backView, 0)
    .rightSpaceToView(self.rightView, -10);
    
    self.nameLabel  = [UILabel new];
    self.sexLabel = [UILabel new];
    self.birthLabel  =[UILabel new];
    self.timeLabel = [UILabel new];
    self.locLabel  = [UILabel new];
    [self.showView sd_addSubviews:@[self.nameLabel,self.sexLabel,self.birthLabel, self.timeLabel,self.locLabel]];
    self.nameLabel.sd_layout
    .topSpaceToView(self.showView, 20)
    .leftSpaceToView(self.showView, 20)
    .heightIs(15)
    .rightSpaceToView(self.showView, 20);
    self.nameLabel.textColor = ZPMyOrderDetailFontColor;
    self.nameLabel.font = [UIFont fontWithName:ZPPFSCRegular size:14];
    self.nameLabel.text = @"姓名：Mandy";
    
    self.sexLabel.sd_layout
    .topSpaceToView(self.nameLabel, 12)
    .leftSpaceToView(self.showView, 20)
    .heightIs(15)
    .rightSpaceToView(self.showView, 20);
    self.sexLabel.textColor = ZPMyOrderDetailFontColor;
    self.sexLabel.font = [UIFont fontWithName:ZPPFSCRegular size:14];
    self.sexLabel.text = @"性别：女 ";
    
    self.birthLabel.sd_layout
    .topSpaceToView(self.sexLabel, 12)
    .leftSpaceToView(self.showView, 20)
    .heightIs(15)
    .rightSpaceToView(self.showView, 20);
    self.birthLabel.textColor = ZPMyOrderDetailFontColor;
    self.birthLabel.font = [UIFont fontWithName:ZPPFSCRegular size:14];
    self.birthLabel.text = @"生日：1989/04/10";
    
    self.timeLabel.sd_layout
    .topSpaceToView(self.birthLabel, 12)
    .leftSpaceToView(self.showView, 20)
    .heightIs(15)
    .rightSpaceToView(self.showView, 20);
    self.timeLabel.textColor = ZPMyOrderDetailFontColor;
    self.timeLabel.font = [UIFont fontWithName:ZPPFSCRegular size:14];
    self.timeLabel.text = @"检测时间：2017-12-25 15：35：56";
    
    self.locLabel.sd_layout
    .topSpaceToView(self.timeLabel, 12)
    .leftSpaceToView(self.showView, 20)
    .heightIs(15)
    .rightSpaceToView(self.showView, 20);
    self.locLabel.textColor = ZPMyOrderDetailFontColor;
    self.locLabel.font = [UIFont fontWithName:ZPPFSCRegular size:14];
    self.locLabel.text = @"检测地点：建设银行广东省东莞支行";
    __weak typeof(self) weakSelf = self;
//    [self.backView setDidFinishAutoLayoutBlock:^(CGRect frame) {
//        ZPLog(@"尺寸是:%@",NSStringFromCGRect(frame));
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, frame.size.width, frame.size.width) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.width);
//        maskLayer.path = maskPath.CGPath;
//        weakSelf.backView.layer.mask = maskLayer;
//    }];
    [self.showView setDidFinishAutoLayoutBlock:^(CGRect frame) {
        ZPLog(@"尺寸是:%@",NSStringFromCGRect(frame));
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, frame.size.width, frame.size.width) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.width);
        maskLayer.path = maskPath.CGPath;
        weakSelf.showView.layer.mask = maskLayer;
    }];
}

- (void)setModel:(UHMyFileDetailModel *)model {
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",model.filedForIos.name];
    self.sexLabel.text = [NSString stringWithFormat:@"性别：%@",model.filedForIos.gender.text];
    self.birthLabel.text = [NSString stringWithFormat:@"生日：%@",model.filedForIos.birthday];
    self.timeLabel.text = [NSString stringWithFormat:@"检测时间：%@",model.filedForIos.detectDate];
    self.locLabel.text = [NSString stringWithFormat:@"检测地点：%@",model.filedForIos.subordindateUnit];
}
@end
