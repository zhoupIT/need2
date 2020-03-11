//
//  UHSpoEnteringController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/9.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHSpoEnteringController.h"

@interface UHSpoEnteringController ()<UITextFieldDelegate>

@property (nonatomic,strong) UILabel *spotitleLabel;
@property (nonatomic,strong) UILabel *timeLabel;


@property (nonatomic,strong) UITextField *spotitleTextField;
@property (nonatomic,strong) UITextField *timeTextField;

@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) UIButton *cancelButton;

@property (nonatomic,strong) UIView *lineView2;
@property (nonatomic,strong) UIView *lineView3;
@end

@implementation UHSpoEnteringController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

- (void)initAll {
    self.title = @"血氧录入";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view sd_addSubviews:@[self.spotitleLabel,self.timeLabel,self.spotitleTextField,self.timeTextField,self.lineView2,self.lineView3,self.saveButton,self.cancelButton]];
    
    self.spotitleLabel.sd_layout
    .leftSpaceToView(self.view, 16)
    .topSpaceToView(self.view, 18)
    .heightIs(16)
    .rightSpaceToView(self.view, 16);
    
    self.spotitleTextField.sd_layout
    .topSpaceToView(self.spotitleLabel, 19)
    .leftSpaceToView(self.view, 16)
    .rightSpaceToView(self.view, 16)
    .heightIs(14);
    self.lineView2.sd_layout
    .topSpaceToView(self.spotitleTextField, 13)
    .leftSpaceToView(self.view, 16)
    .rightSpaceToView(self.view, 16)
    .heightIs(1);
    
    self.timeLabel.sd_layout
    .leftSpaceToView(self.view, 16)
    .topSpaceToView(self.spotitleTextField, 37)
    .heightIs(16)
    .rightSpaceToView(self.view, 16);
    
    self.timeTextField.sd_layout
    .topSpaceToView(self.timeLabel, 19)
    .leftSpaceToView(self.view, 16)
    .rightSpaceToView(self.view, 16)
    .heightIs(14);
    self.lineView3.sd_layout
    .topSpaceToView(self.timeTextField, 13)
    .leftSpaceToView(self.view, 16)
    .rightSpaceToView(self.view, 16)
    .heightIs(1);
    
    self.saveButton.sd_layout
    .leftEqualToView(self.view)
    .widthIs(SCREEN_WIDTH*0.5)
    .heightIs(50)
    .bottomEqualToView(self.view);
    
    self.cancelButton.sd_layout
    .rightEqualToView(self.view)
    .widthIs(SCREEN_WIDTH*0.5)
    .heightIs(50)
    .bottomEqualToView(self.view);
}

- (void)saveAction:(UIButton *)btn {
    if (!self.spotitleTextField.text.length || !self.spotitleTextField.text.length) {
        [MBProgressHUD showError:@"值不能为空"];
        return;
    }
    NSString *timeStr = self.timeTextField.text;
    if (!timeStr.length) {
        [MBProgressHUD showError:@"请选择检测时间"];
        return;
    }
    
    [MBProgressHUD showMessage:@"录入中..."];    
    [[ZPNetWork sharedZPNetWork] requestWithUrl:@"api/chronic/spo2" andHTTPMethod:@"PUT" andDict:@{@"spo2":self.spotitleTextField.text,@"detectDate":timeStr} success:^(NSDictionary *response) {
            [MBProgressHUD showSuccess:@"录入成功"];
            if (self.updateListBlock) {
                [self.navigationController popViewControllerAnimated:YES];
                self.updateListBlock();
            }
    } failed:^(NSError *error) {
        
    }];
}

- (void)cancelAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!self.timeTextField.text.length) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    textField.text = [formatter stringFromDate:[NSDate date]];
    }
}

- (UILabel *)spotitleLabel {
    if (!_spotitleLabel) {
        _spotitleLabel = [UILabel new];
        _spotitleLabel.textColor = ZPMyOrderDetailFontColor;
        _spotitleLabel.font = [UIFont systemFontOfSize:15];
        _spotitleLabel.text = @"血氧值(%) :";
    }
    return _spotitleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = ZPMyOrderDetailFontColor;
        _timeLabel.font = [UIFont systemFontOfSize:15];
        _timeLabel.text = @"检测时间 :";
    }
    return _timeLabel;
}

- (UITextField *)spotitleTextField {
    if (!_spotitleTextField) {
        _spotitleTextField = [UITextField new];
        _spotitleTextField.textColor = ZPMyOrderDetailFontColor;
        _spotitleTextField.font = [UIFont systemFontOfSize:14];
        _spotitleTextField.placeholder = @"请输入血氧值";
        _spotitleTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _spotitleTextField;
}

- (UITextField *)timeTextField {
    if (!_timeTextField) {
        _timeTextField = [UITextField new];
        _timeTextField.textColor = ZPMyOrderDetailFontColor;
        _timeTextField.font = [UIFont systemFontOfSize:14];
        _timeTextField.datePickerInput = YES;
        _timeTextField.datePickerSetMax = YES;
        _timeTextField.delegate = self;
        _timeTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _timeTextField;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton new];
        _saveButton.backgroundColor = ZPMyOrderDetailValueFontColor;
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton new];
        _cancelButton.backgroundColor = RGB(221, 221, 221);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

-(UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [UIView new];
        _lineView2.backgroundColor = KControlColor;
    }
    return _lineView2;
}

-(UIView *)lineView3 {
    if (!_lineView3) {
        _lineView3 = [UIView new];
        _lineView3.backgroundColor = KControlColor;
    }
    return _lineView3;
}

@end
