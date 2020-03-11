//
//  UHChangePhoneController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHChangePhoneController.h"
#import "UHButton.h"
#import "UHUserModel.h"
#import "UHChangePhoneSubController.h"
@interface UHChangePhoneController ()
@property (nonatomic,strong) UITextField *currentTextfield;
@property (nonatomic,strong) UHButton *submmitBtn;
@end

@implementation UHChangePhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.title = @"更改手机号码";
    
    [self setData];
}

- (void)setData {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        UHUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
        self.currentTextfield.text = model.phone;
    }
}

- (void)changePhone {
    UHChangePhoneSubController *changeControl = [[UHChangePhoneSubController alloc] init];
    changeControl.currentPhone = self.currentTextfield.text;
    changeControl.updatePhoneBlock = ^(NSString *phone) {
        self.currentTextfield.text = phone;
    };
    [self.navigationController pushViewController:changeControl animated:YES];
}

- (void)setupUI {
    self.view.backgroundColor = KControlColor;
    
    self.currentTextfield = [UITextField new];
    self.submmitBtn = [UHButton new];
    [self.view sd_addSubviews:@[self.currentTextfield,self.submmitBtn]];
    
    self.currentTextfield.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(49)
    .topSpaceToView(self.view, 8);
    self.currentTextfield.textColor = RGB(175, 175, 175);
    self.currentTextfield.font = [UIFont systemFontOfSize:14];
    self.currentTextfield.backgroundColor = [UIColor whiteColor];
    self.currentTextfield.leftViewMode = UITextFieldViewModeAlways;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 49)];
    label.text = @"当前手机号";
    label.textColor = KCommonBlack;
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    self.currentTextfield.leftView = label;
    self.currentTextfield.userInteractionEnabled = NO;
    
    
    self.submmitBtn.sd_layout
    .topSpaceToView(self.currentTextfield, 50)
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .heightIs(49);
    [self.submmitBtn setTitle:@"修改手机号码" forState:UIControlStateNormal];
    self.submmitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.submmitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submmitBtn.layer.masksToBounds = YES;
    self.submmitBtn.layer.cornerRadius = 8;
    [self.submmitBtn setBackgroundGradientColors:@[RGB(78, 178, 255),RGB(99,205,255)]];
    [self.submmitBtn addTarget:self action:@selector(changePhone) forControlEvents:UIControlEventTouchUpInside];
}

@end
