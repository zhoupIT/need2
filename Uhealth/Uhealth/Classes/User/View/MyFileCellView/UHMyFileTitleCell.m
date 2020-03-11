//
//  UHMyFileTitleCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/6/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyFileTitleCell.h"
#import "UHMyFileDetailModel.h"
#import "UHMyfileDetailDataCell.h"
#import "UHMyFileTitleView.h"
@interface UHMyFileTitleCell()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *titlelable1;
@property (nonatomic,strong) UILabel *titlelable2;
@property (nonatomic,strong) UILabel *titlelable3;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *showView;
@property (nonatomic,strong) UIView *rightView;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *datas;

@property (nonatomic,strong) UHMyFileTitleView *commonView;
@end

@implementation UHMyFileTitleCell

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
    self.iconView = [UIImageView new];
    self.rightView = [UIView new];
    
//    [contentView addSubview:self.backView];
//    
//    self.backView.sd_layout
//    .leftSpaceToView(contentView, 8)
//    .rightSpaceToView(contentView, 8)
//    .topSpaceToView(contentView, 0);
//    self.backView.backgroundColor = KControlColor;
//    [self.backView sd_addSubviews:@[self.rightView,self.showView]];
    
    
    [contentView addSubview:self.rightView];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 0;
    UIFont *font = [UIFont fontWithName:ZPPFSCMedium size:16];
    self.titleLabel.font = font;
    CGSize sizeWord = [@"一" sizeWithFont:font constrainedToSize:CGSizeMake(100, 1000.0) lineBreakMode:UILineBreakModeWordWrap];
    CGFloat width = sizeWord.width;//一个汉字的宽度
    
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
    
//    self.showView.backgroundColor = [UIColor whiteColor];
//    self.showView.sd_layout
//    .leftSpaceToView(self.backView, 0)
//    .topSpaceToView(self.backView, 0)
//    .bottomSpaceToView(self.backView, 0)
//    .rightSpaceToView(self.rightView, -10);
    
//    [self.showView addSubview:self.iconView];
//    self.iconView.sd_layout
//    .topEqualToView(self.showView)
//    .leftSpaceToView(self.showView, 17)
//    .heightIs(3)
//    .rightSpaceToView(self.showView, 9);
//    self.iconView.image = [UIImage imageNamed:@"myfile_separator_icon"];
    
    
    
    
    
//    [self.showView addSubview:self.tableView];
//    self.tableView.sd_layout
//    .topSpaceToView(self.titlelable1, 33)
//    .leftEqualToView(self.showView)
//    .rightEqualToView(self.showView);
    self.commonView = [UHMyFileTitleView new];
    [contentView addSubview:self.commonView];
    self.commonView.sd_layout
    .leftSpaceToView(contentView, 8)
    .rightSpaceToView(self.rightView, -10)
    .topSpaceToView(contentView, 0); // 已经在内部实现高度自适应所以不需要再设置高度
}

#pragma mark - -tableView的数据源方法
/**
 *  返回组数(默认为1组)
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

/**
 *  返回每组的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UHMyfileDetailDataCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHMyfileDetailDataCell class])];
    cell.model = self.datas[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 25;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UHMyfileDetailDataCell class] forCellReuseIdentifier:NSStringFromClass([UHMyfileDetailDataCell class])];
    }
    return _tableView;
}

- (NSArray *)datas {
    if (!_datas) {
        _datas = [NSArray array];
    }
    return _datas;
}

- (void)setModel:(UHMyFileDetailModel *)model {
    _model = model;
    
    self.titleLabel.text = model.modelName;
//    self.datas = model.modelValue.copy;
//    self.tableView.sd_layout
//    .heightIs(25*self.datas.count);
//    self.backView.sd_layout
//    .heightIs(25*self.datas.count+13+15+33+21+2);
//    [self.tableView reloadData];
    [self.commonView setupWithItemsArray:model.modelValue];
    [self setupAutoHeightWithBottomView:self.commonView bottomMargin:0];
    
//    [self setupAutoHeightWithBottomView:self.backView bottomMargin:0];
}

@end
