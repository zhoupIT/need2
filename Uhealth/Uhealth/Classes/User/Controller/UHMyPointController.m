//
//  UHMyPointController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyPointController.h"
@interface UHMyPointController ()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) UILabel *currentLabel;

@property (nonatomic,strong) UIButton *backBtn;
@end

@implementation UHMyPointController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.title = @"我的积分";
}

- (void)setupUI {
    self.view.backgroundColor = KControlColor;
    self.imageView = [UIImageView new];
    [self.view addSubview:self.imageView];
    
    self.imageView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view, 0)
    .heightIs(ZPHeight(216));
    self.imageView.image = [UIImage imageNamed:@"me_scoreBackImage"];
    self.imageView.userInteractionEnabled = YES;
    
    self.numLabel =  [UILabel new];
    self.currentLabel = [UILabel new];
    [self.imageView sd_addSubviews:@[self.numLabel,self.currentLabel]];
    self.numLabel.sd_layout
    .topSpaceToView(self.imageView, ZPHeight(72))
    .leftEqualToView(self.imageView)
    .rightEqualToView(self.imageView)
    .heightIs(72);
    self.numLabel.text = @"0";
    self.numLabel.textColor = [UIColor whiteColor];
    self.numLabel.font = [UIFont systemFontOfSize:72];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    
    self.currentLabel.sd_layout
    .topSpaceToView(self.numLabel, 27)
    .leftEqualToView(self.imageView)
    .rightEqualToView(self.imageView)
    .heightIs(15);
    self.currentLabel.textColor = [UIColor whiteColor];
    self.currentLabel.text = @"当前积分";
    self.currentLabel.font = [UIFont systemFontOfSize:15];
    self.currentLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.imageView addSubview:self.backBtn];
    if (KIsiPhoneX) {
        self.backBtn.sd_layout
        .leftSpaceToView(self.imageView, 20)
        .topSpaceToView(self.imageView, 24+30)
        .heightIs(22)
        .widthIs(22);
    } else {
        self.backBtn.sd_layout
        .leftSpaceToView(self.imageView, 20)
        .topSpaceToView(self.imageView, 30)
        .heightIs(22)
        .widthIs(22);
    }
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true];
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
@end
