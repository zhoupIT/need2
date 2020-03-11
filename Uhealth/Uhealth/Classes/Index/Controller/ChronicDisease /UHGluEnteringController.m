//
//  UHGluEnteringController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/29.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHGluEnteringController.h"
#import "OttoKeyboardView.h"
@interface UHGluEnteringController ()<UITextFieldDelegate>

@property (nonatomic,strong) UILabel *glutitleLabel;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *timeLabel;


@property (nonatomic,strong) OttoTextField *glutitleTextField;
@property (nonatomic,strong) UIView *typeView;
@property (nonatomic,strong) UITextField *timeTextField;

@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) UIButton *cancelButton;

@property (nonatomic,strong) UIView *lineView2;
@property (nonatomic,strong) UIView *lineView3;

@property (nonatomic,strong) NSMutableArray *tempBtnArr;
@end

@implementation UHGluEnteringController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

- (void)initAll {
    self.title = @"血糖录入";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view sd_addSubviews:@[self.glutitleLabel,self.timeLabel,self.glutitleTextField,self.timeTextField,self.lineView2,self.lineView3,self.saveButton,self.cancelButton,self.typeView,self.typeLabel]];
    
    self.glutitleLabel.sd_layout
    .leftSpaceToView(self.view, 16)
    .topSpaceToView(self.view, 18)
    .heightIs(16)
    .rightSpaceToView(self.view, 16);
    
    self.glutitleTextField.sd_layout
    .topSpaceToView(self.glutitleLabel, 19)
    .leftSpaceToView(self.view, 16)
    .rightSpaceToView(self.view, 16)
    .heightIs(14);
    self.lineView2.sd_layout
    .topSpaceToView(self.glutitleTextField, 13)
    .leftSpaceToView(self.view, 16)
    .rightSpaceToView(self.view, 16)
    .heightIs(1);
    
    self.typeLabel.sd_layout
    .leftSpaceToView(self.view, 16)
    .topSpaceToView(self.glutitleTextField, 37)
    .heightIs(16)
    .rightSpaceToView(self.view, 16);
    
    self.typeView.sd_layout
    .topSpaceToView(self.typeLabel, 19)
    .leftSpaceToView(self.view, 16)
    .rightSpaceToView(self.view, 16)
    .heightIs(71);
    
    self.timeLabel.sd_layout
    .leftSpaceToView(self.view, 16)
    .topSpaceToView(self.typeView, 25)
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
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"空腹",@"早餐后",@"午餐前",@"午餐后",@"晚餐前",@"晚餐后",@"睡前",@"夜间", nil];
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < 8; i++) {
        UIButton *view = [UIButton new];
        [view setTitle:titleArray[i] forState:UIControlStateNormal];
        [view setTitleColor:RGB(80,179,255) forState:UIControlStateNormal];
         [view setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        view.titleLabel.font = [UIFont systemFontOfSize:14];
        view.layer.cornerRadius = 14;
        view.layer.masksToBounds = YES;
        view.layer.borderWidth = 1;
        view.layer.borderColor = RGB(80,179,255).CGColor;
        [self.typeView addSubview:view];
        view.sd_layout
        .heightIs(28)
        .widthIs((SCREEN_WIDTH-15*5)/4);
        view.tag = 1000+i;
        [view addTarget:self action:@selector(selectTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        [temp addObject:view];
    }
    self.tempBtnArr = [NSMutableArray arrayWithArray:[temp copy]];
    // 关键步骤：设置类似collectionView的展示效果
    [self.typeView setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:4 verticalMargin:10 horizontalMargin:10 verticalEdgeInset:0 horizontalEdgeInset:0];
}

- (void)selectTypeAction:(UIButton *)btn {
    for (UIButton *tempbtn in self.tempBtnArr) {
        [tempbtn setBackgroundColor:[UIColor whiteColor]];
        tempbtn.selected = NO;
    }
    [btn setBackgroundColor:RGB(78,178,255)];
    btn.selected = YES;;
}

- (void)saveAction:(UIButton *)btn {
    if (!self.glutitleTextField.text.length || !self.glutitleTextField.text.length) {
        [MBProgressHUD showError:@"值不能为空"];
        return;
    }
    BOOL isSelType = NO;
    NSString *name;
    for (UIButton *btn in self.tempBtnArr) {
        if (btn.isSelected) {
            isSelType = YES;
            name = btn.titleLabel.text;
        }
    }
    if (!isSelType) {
        [MBProgressHUD showError:@"请选择类型!"];
        return;
    }
    NSString *timeStr = self.timeTextField.text;
    if (!timeStr.length) {
        [MBProgressHUD showError:@"请选择检测时间"];
        return;
    }
    
    [MBProgressHUD showMessage:@"录入中..."];
    [[ZPNetWork sharedZPNetWork] requestWithUrl:@"api/chronic/glu" andHTTPMethod:@"PUT" andDict:@{@"glu":self.glutitleTextField.text,@"detectDate":timeStr,@"dietaryStatus":[self dietaryStatusWithName:name]} success:^(NSDictionary *response) {
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

- (NSString *)dietaryStatusWithName:(NSString *)name {
    /*
     （FBG空腹血糖，AFTER_THE_BREAKFAST_BLOOD_GLUCOSE早餐后血糖，ANTE_PRANDIUM_BLOOD_GLUCOSE午餐前血糖，AFTER_LUNCH_BLOOD_GLUCOSE午餐后血糖，BEFORE_DINNER_BLOOD_GLUCOSE晚餐前血糖，AFTER_DINNER_BLOOD_GLUCOSE晚餐后血糖，BEFORE_SLEE_BLOOD_GLUCOSEP睡前血糖，AT_NIGHT_BLOOD_GLUCOSE夜间血糖）
     */
    if ([name isEqualToString:@"空腹"]) {
        return @"FBG";
    } else if ([name isEqualToString:@"早餐后"]) {
        return @"AFTER_THE_BREAKFAST_BLOOD_GLUCOSE";
    } else if ([name isEqualToString:@"午餐前"]) {
        return @"ANTE_PRANDIUM_BLOOD_GLUCOSE";
    } else if ([name isEqualToString:@"午餐后"]) {
        return @"AFTER_LUNCH_BLOOD_GLUCOSE";
    } else if ([name isEqualToString:@"晚餐前"]) {
        return @"BEFORE_DINNER_BLOOD_GLUCOSE";
    }else if ([name isEqualToString:@"晚餐后"]) {
        return @"AFTER_DINNER_BLOOD_GLUCOSE";
    }else if ([name isEqualToString:@"睡前"]) {
        return @"BEFORE_SLEE_BLOOD_GLUCOSEP";
    }
    return @"AT_NIGHT_BLOOD_GLUCOSE";
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!self.timeTextField.text.length) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    textField.text = [formatter stringFromDate:[NSDate date]];
    }
}

- (UILabel *)glutitleLabel {
    if (!_glutitleLabel) {
        _glutitleLabel = [UILabel new];
        _glutitleLabel.textColor = ZPMyOrderDetailFontColor;
        _glutitleLabel.font = [UIFont systemFontOfSize:15];
        _glutitleLabel.text = @"血糖值(%) :";
    }
    return _glutitleLabel;
}

- (UIView *)typeView {
    if (!_typeView) {
        _typeView = [UIView new];
    }
    return _typeView;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [UILabel new];
        _typeLabel.textColor = ZPMyOrderDetailFontColor;
        _typeLabel.font = [UIFont systemFontOfSize:15];
        _typeLabel.text = @"类型 :";
    }
    return _typeLabel;
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

- (UITextField *)glutitleTextField {
    if (!_glutitleTextField) {
        _glutitleTextField = [OttoTextField new];
        _glutitleTextField.textColor = ZPMyOrderDetailFontColor;
        _glutitleTextField.font = [UIFont systemFontOfSize:14];
        _glutitleTextField.placeholder = @"请输入血糖值";
        [_glutitleTextField setNumberKeyboardType:NumberKeyboardTypeDouble];
    }
    return _glutitleTextField;
}

- (UITextField *)timeTextField {
    if (!_timeTextField) {
        _timeTextField = [UITextField new];
        _timeTextField.textColor = ZPMyOrderDetailFontColor;
        _timeTextField.font = [UIFont systemFontOfSize:14];
        _timeTextField.datePickerInput = YES;
        _timeTextField.datePickerSetMax = YES;
        _timeTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _timeTextField.delegate = self;
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
