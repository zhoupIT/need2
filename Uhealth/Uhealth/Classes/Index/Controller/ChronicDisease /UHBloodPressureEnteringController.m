//
//  UHBloodPressureEnteringController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/9.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHBloodPressureEnteringController.h"
#import "OttoKeyboardView.h"
@interface UHBloodPressureEnteringController ()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *sbptitleLabel;
@property (nonatomic,strong) UILabel *dbptitleLabel;
@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UITextField *sbptitleTextField;
@property (nonatomic,strong) UITextField *dbptitleTextField;
@property (nonatomic,strong) UITextField *timeTextField;

@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) UIButton *cancelButton;

@property (nonatomic,strong) UIView *lineView1;
@property (nonatomic,strong) UIView *lineView2;
@property (nonatomic,strong) UIView *lineView3;
//创建对象
@property (nonatomic, strong) UIDatePicker *datePicker;
//日期上方的取消和确定视图
@property (nonatomic,strong) UIToolbar *inputAccessoryView;
@end

@implementation UHBloodPressureEnteringController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

- (void)initAll {
    self.title = @"血压录入";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view sd_addSubviews:@[self.sbptitleLabel,self.dbptitleLabel,self.timeLabel,self.sbptitleTextField,self.dbptitleTextField,self.timeTextField,self.lineView1,self.lineView2,self.lineView3,self.saveButton,self.cancelButton]];
    
    self.sbptitleLabel.sd_layout
    .leftSpaceToView(self.view, 16)
    .topSpaceToView(self.view, 18)
    .heightIs(16)
    .rightSpaceToView(self.view, 16);
    
    self.sbptitleTextField.sd_layout
    .topSpaceToView(self.sbptitleLabel, 19)
    .leftSpaceToView(self.view, 16)
    .rightSpaceToView(self.view, 16)
    .heightIs(14);
    self.lineView1.sd_layout
    .topSpaceToView(self.sbptitleTextField, 13)
    .leftSpaceToView(self.view, 16)
    .rightSpaceToView(self.view, 16)
    .heightIs(1);
    
    
    self.dbptitleLabel.sd_layout
    .leftSpaceToView(self.view, 16)
    .topSpaceToView(self.sbptitleTextField, 37)
    .heightIs(16)
    .rightSpaceToView(self.view, 16);
    
    self.dbptitleTextField.sd_layout
    .topSpaceToView(self.dbptitleLabel, 19)
    .leftSpaceToView(self.view, 16)
    .rightSpaceToView(self.view, 16)
    .heightIs(14);
    self.lineView2.sd_layout
    .topSpaceToView(self.dbptitleTextField, 13)
    .leftSpaceToView(self.view, 16)
    .rightSpaceToView(self.view, 16)
    .heightIs(1);
    
    self.timeLabel.sd_layout
    .leftSpaceToView(self.view, 16)
    .topSpaceToView(self.dbptitleTextField, 37)
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
    if (!self.sbptitleTextField.text.length || !self.dbptitleTextField.text.length) {
        [MBProgressHUD showError:@"值不能为空"];
        return;
    }
    if ([self.sbptitleTextField.text integerValue] <= [self.dbptitleTextField.text integerValue]) {
        [MBProgressHUD showError:@"收缩压的值要大于舒张压!"];
        return;
    }
    NSString *timeStr = self.timeTextField.text;
    if (!timeStr.length) {
        [MBProgressHUD showError:@"请选择检测时间"];
        return;
    }
    
    [MBProgressHUD showMessage:@"录入中..."];
    [[ZPNetWork sharedZPNetWork] requestWithUrl:@"api/chronic/nibp" andHTTPMethod:@"PUT" andDict:@{@"sbp":self.sbptitleTextField.text,@"dbp":self.dbptitleTextField.text,@"detectDate":timeStr} success:^(NSDictionary *response) {
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

- (UILabel *)sbptitleLabel {
    if (!_sbptitleLabel) {
        _sbptitleLabel = [UILabel new];
        _sbptitleLabel.textColor = ZPMyOrderDetailFontColor;
        _sbptitleLabel.font = [UIFont systemFontOfSize:15];
        _sbptitleLabel.text = @"收缩压(mmhg) :";
    }
    return _sbptitleLabel;
}

- (UILabel *)dbptitleLabel {
    if (!_dbptitleLabel) {
        _dbptitleLabel = [UILabel new];
        _dbptitleLabel.textColor = ZPMyOrderDetailFontColor;
        _dbptitleLabel.font = [UIFont systemFontOfSize:15];
        _dbptitleLabel.text = @"舒张压(mmhg) :";
    }
    return _dbptitleLabel;
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

- (UITextField *)sbptitleTextField {
    if (!_sbptitleTextField) {
        _sbptitleTextField = [UITextField new];
        _sbptitleTextField.textColor = ZPMyOrderDetailFontColor;
        _sbptitleTextField.font = [UIFont systemFontOfSize:14];
        _sbptitleTextField.placeholder = @"请输入收缩压数值";
        _sbptitleTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _sbptitleTextField;
}

- (UITextField *)dbptitleTextField {
    if (!_dbptitleTextField) {
        _dbptitleTextField = [UITextField new];
        _dbptitleTextField.textColor = ZPMyOrderDetailFontColor;
        _dbptitleTextField.font = [UIFont systemFontOfSize:14];
        _dbptitleTextField.placeholder = @"请输入舒张压数值";
        _dbptitleTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _dbptitleTextField;
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

-(UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [UIView new];
        _lineView1.backgroundColor = KControlColor;
    }
    return _lineView1;
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
