//
//  UHWeightEnteringController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHWeightEnteringController.h"
#import "OttoKeyboardView.h"
@interface UHWeightEnteringController ()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *kgtitleLabel;
@property (nonatomic,strong) UILabel *cmtitleLabel;
@property (nonatomic,strong) UILabel *bimtitleLabel;
@property (nonatomic,strong) UILabel *timeLabel;


@property (nonatomic,strong) OttoTextField *kgtitleTextField;
@property (nonatomic,strong) OttoTextField *cmtitleTextField;
@property (nonatomic,strong) UITextField *bimtitleTextField;
@property (nonatomic,strong) UITextField *timeTextField;

@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) UIButton *cancelButton;

@property (nonatomic,strong) UIView *lineView0;
@property (nonatomic,strong) UIView *lineView1;
@property (nonatomic,strong) UIView *lineView2;
@property (nonatomic,strong) UIView *lineView3;
@end

@implementation UHWeightEnteringController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

- (void)initAll {
    self.title = @"体重录入";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view sd_addSubviews:@[self.kgtitleLabel,self.cmtitleLabel,self.bimtitleLabel,self.timeLabel,self.kgtitleTextField,self.cmtitleTextField,self.bimtitleTextField,self.timeTextField,self.lineView0,self.lineView1,self.lineView2,self.lineView3,self.saveButton,self.cancelButton]];
    
    self.kgtitleLabel.sd_layout
    .leftSpaceToView(self.view, 16)
    .topSpaceToView(self.view, 18)
    .heightIs(16)
    .rightSpaceToView(self.view, 16);
    
    self.kgtitleTextField.sd_layout
    .topSpaceToView(self.kgtitleLabel, 19)
    .leftSpaceToView(self.view, 16)
    .rightSpaceToView(self.view, 16)
    .heightIs(14);
    self.lineView0.sd_layout
    .topSpaceToView(self.kgtitleTextField, 13)
    .leftSpaceToView(self.view, 16)
    .rightSpaceToView(self.view, 16)
    .heightIs(1);
    
    self.cmtitleLabel.sd_layout
    .leftSpaceToView(self.view, 16)
    .topSpaceToView(self.kgtitleTextField, 37)
    .heightIs(16)
    .rightSpaceToView(self.view, 16);
    
    self.cmtitleTextField.sd_layout
    .topSpaceToView(self.cmtitleLabel, 19)
    .leftSpaceToView(self.view, 16)
    .rightSpaceToView(self.view, 16)
    .heightIs(14);
    self.lineView1.sd_layout
    .topSpaceToView(self.cmtitleTextField, 13)
    .leftSpaceToView(self.view, 16)
    .rightSpaceToView(self.view, 16)
    .heightIs(1);
    
//    self.bimtitleLabel.sd_layout
//    .leftSpaceToView(self.view, 16)
//    .topSpaceToView(self.cmtitleTextField, 37)
//    .heightIs(16)
//    .rightSpaceToView(self.view, 16);
//
//    self.bimtitleTextField.sd_layout
//    .topSpaceToView(self.bimtitleLabel, 19)
//    .leftSpaceToView(self.view, 16)
//    .rightSpaceToView(self.view, 16)
//    .heightIs(14);
//    self.lineView2.sd_layout
//    .topSpaceToView(self.bimtitleTextField, 13)
//    .leftSpaceToView(self.view, 16)
//    .rightSpaceToView(self.view, 16)
//    .heightIs(1);
    
    self.timeLabel.sd_layout
    .leftSpaceToView(self.view, 16)
    .topSpaceToView(self.cmtitleTextField, 37)
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
    if (!self.kgtitleTextField.text.length || !self.cmtitleTextField.text.length) {
        [MBProgressHUD showError:@"值不能为空"];
        return;
    }
    NSString *timeStr = self.timeTextField.text;
    if (!timeStr.length) {
        [MBProgressHUD showError:@"请选择检测时间"];
        return;
    }
    
    [MBProgressHUD showMessage:@"录入中..."];
    [[ZPNetWork sharedZPNetWork] requestWithUrl:@"api/chronic/weight" andHTTPMethod:@"PUT" andDict:@{@"weight":self.kgtitleTextField.text,@"height":self.cmtitleTextField.text,@"detectDate":timeStr} success:^(NSDictionary *response) {
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
    if (textField == self.timeTextField) {
        if (!self.timeTextField.text.length) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
        textField.text = [formatter stringFromDate:[NSDate date]];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//    if (self.kgtitleTextField.text.length && self.cmtitleTextField.text.length) {
//        NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
//
//                                          decimalNumberHandlerWithRoundingMode:NSRoundUp
//
//                                          scale:2
//
//                                          raiseOnExactness:NO
//
//                                          raiseOnOverflow:NO
//
//                                          raiseOnUnderflow:NO
//
//                                          raiseOnDivideByZero:YES];
//        NSDecimalNumber *kg = [NSDecimalNumber decimalNumberWithString:self.kgtitleTextField.text];
//        NSDecimalNumber *cm = [NSDecimalNumber decimalNumberWithString:self.cmtitleTextField.text];
//        NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:@"100"];
//        NSDecimalNumber *BMI = [kg decimalNumberByDividingBy:[[cm decimalNumberByDividingBy:num] decimalNumberByMultiplyingBy:[cm decimalNumberByDividingBy:num]] withBehavior:roundUp];
//         self.bimtitleTextField.text = [NSString stringWithFormat:@"%@",BMI];
//    }
}

- (UILabel *)kgtitleLabel {
    if (!_kgtitleLabel) {
        _kgtitleLabel = [UILabel new];
        _kgtitleLabel.textColor = ZPMyOrderDetailFontColor;
        _kgtitleLabel.font = [UIFont systemFontOfSize:15];
        _kgtitleLabel.text = @"体重(kg) :";
    }
    return _kgtitleLabel;
}

- (UILabel *)cmtitleLabel {
    if (!_cmtitleLabel) {
        _cmtitleLabel = [UILabel new];
        _cmtitleLabel.textColor = ZPMyOrderDetailFontColor;
        _cmtitleLabel.font = [UIFont systemFontOfSize:15];
        _cmtitleLabel.text = @"身高(cm) :";
    }
    return _cmtitleLabel;
}

- (UILabel *)bimtitleLabel {
    if (!_bimtitleLabel) {
        _bimtitleLabel = [UILabel new];
        _bimtitleLabel.textColor = ZPMyOrderDetailFontColor;
        _bimtitleLabel.font = [UIFont systemFontOfSize:15];
        _bimtitleLabel.text = @"BMI :";
    }
    return _bimtitleLabel;
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

- (UITextField *)kgtitleTextField {
    if (!_kgtitleTextField) {
        _kgtitleTextField = [OttoTextField new];
        _kgtitleTextField.textColor = ZPMyOrderDetailFontColor;
        _kgtitleTextField.font = [UIFont systemFontOfSize:14];
        _kgtitleTextField.placeholder = @"请输入体重数值";
         [_kgtitleTextField setNumberKeyboardType:NumberKeyboardTypeDouble];
        _kgtitleTextField.delegate = self;
    }
    return _kgtitleTextField;
}

- (UITextField *)cmtitleTextField {
    if (!_cmtitleTextField) {
        _cmtitleTextField = [OttoTextField new];
        _cmtitleTextField.textColor = ZPMyOrderDetailFontColor;
        _cmtitleTextField.font = [UIFont systemFontOfSize:14];
        _cmtitleTextField.placeholder = @"请输入身高数值";
         [_cmtitleTextField setNumberKeyboardType:NumberKeyboardTypeDouble];
        _cmtitleTextField.delegate = self;
    }
    return _cmtitleTextField;
}

- (UITextField *)bimtitleTextField {
    if (!_bimtitleTextField) {
        _bimtitleTextField = [UITextField new];
        _bimtitleTextField.textColor = ZPMyOrderDetailFontColor;
        _bimtitleTextField.font = [UIFont systemFontOfSize:14];
//        _bimtitleTextField.placeholder = @"请输入BIM数值";
        _bimtitleTextField.userInteractionEnabled = NO;
        _bimtitleTextField.keyboardType = UIKeyboardTypePhonePad;
    }
    return _bimtitleTextField;
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

-(UIView *)lineView0 {
    if (!_lineView0) {
        _lineView0 = [UIView new];
        _lineView0.backgroundColor = KControlColor;
    }
    return _lineView0;
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
