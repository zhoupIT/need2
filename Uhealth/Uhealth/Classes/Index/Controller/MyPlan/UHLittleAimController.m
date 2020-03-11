//
//  UHLittleAimController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHLittleAimController.h"
#import "UHMyPlanModel.h"
#import "UHPlanItemModel.h"
#import "UHRepeatListController.h"

@interface UHLittleAimController ()<UITextFieldDelegate>
@property (nonatomic,strong) UIView *leftView;
@property (nonatomic,strong) UITextField *contentTextField;

@property (nonatomic,strong) UIView *whiteBackView1;
@property (nonatomic,strong) UIView *whiteBackView2;

@property (nonatomic,strong) UILabel *tipLable;
@property (nonatomic,strong) UILabel *timeLable;


@property (nonatomic,strong) UISwitch *sw;
@property (nonatomic,strong) UIButton *timeBtn;
@property (strong, nonatomic) UITextField *timeTextField;

@property (nonatomic,strong) UIDatePicker *datePicker;
//日期上方的取消和确定视图
@property (nonatomic,strong) UIToolbar *inputAccessoryView;

@property (nonatomic,strong) UIButton *whiteBackView3;
@property (nonatomic,strong) UILabel *repeatLabel;
@property (nonatomic,strong) UILabel *repeatValueLabel;

@end

@implementation UHLittleAimController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    if(self.itemModel) {
        [self setData];
    }
}

- (void)setData {
    self.contentTextField.text = self.itemModel.content;
    if ([self.itemModel.needRemindFlag.name isEqualToString:@"ENABLED"]) {
        self.sw.on = YES;
        self.whiteBackView2.hidden = NO;
        self.whiteBackView2.sd_layout.heightIs(45)
        .topSpaceToView(self.whiteBackView1, 1);
//        [self.timeBtn setTitle:self.itemModel.remindTime forState:UIControlStateNormal];
        self.timeTextField.text = self.itemModel.remindTime;
       
    }
     self.repeatValueLabel.text = [NSString stringWithFormat:@"%@ >",self.itemModel.repeatType.text];
   
}

- (void)setup {
    self.title =self.itemModel?@"编辑小目标": @"创建小目标";
    self.view.backgroundColor = KControlColor;
    [self.view sd_addSubviews:@[self.leftView,self.contentTextField,self.whiteBackView1,self.whiteBackView2,self.whiteBackView3]];
    self.leftView.sd_layout
    .topSpaceToView(self.view, 5)
    .leftEqualToView(self.view)
    .widthIs(16)
    .heightIs(45);
    
    self.contentTextField.sd_layout
    .topSpaceToView(self.view, 5)
    .leftSpaceToView(self.leftView, 0)
    .rightEqualToView(self.view)
    .heightIs(45);
    
    self.whiteBackView1.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(45)
    .topSpaceToView(self.contentTextField, 12);
    
    self.whiteBackView2.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(45)
    .topSpaceToView(self.whiteBackView1, 1);
    
    self.whiteBackView2.hidden = YES;
    self.whiteBackView2.sd_layout.heightIs(0)
    .topSpaceToView(self.whiteBackView1, 0);

    
    self.whiteBackView3.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(45)
    .topSpaceToView(@[self.whiteBackView2,self.whiteBackView1], 1);
    
    [self.whiteBackView1 sd_addSubviews:@[self.tipLable,self.sw]];
    self.tipLable.sd_layout
    .leftSpaceToView(self.whiteBackView1, 16)
    .heightIs(14)
    .centerYEqualToView(self.whiteBackView1);
    [self.tipLable setSingleLineAutoResizeWithMaxWidth:150];
    
    self.sw.sd_layout.rightSpaceToView(self.whiteBackView1, 16)
    .centerYEqualToView(self.whiteBackView1);
    
    [self.whiteBackView2 sd_addSubviews:@[self.timeLable,self.timeTextField]];
    self.timeLable.sd_layout
    .centerYEqualToView(self.whiteBackView2)
    .leftSpaceToView(self.whiteBackView2, 16)
    .heightIs(14);
    [self.timeLable setSingleLineAutoResizeWithMaxWidth:100];
    
//    self.timeBtn.sd_layout
//    .rightSpaceToView(self.whiteBackView2, 16)
//    .centerYEqualToView(self.timeLable)
//    .heightIs(45)
//    .leftSpaceToView(self.timeLable, 15);
//    NSDate *date = [NSDate date];
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat=@"yyyy-MM-dd hh:mm";
//    [self.timeBtn setTitle:[dateFormatter stringFromDate:date] forState:UIControlStateNormal];
    
    self.timeTextField.sd_layout
    .rightSpaceToView(self.whiteBackView2, 16)
    .centerYEqualToView(self.timeLable)
    .heightIs(45)
    .leftSpaceToView(self.timeLable, 15);
    
    [self.whiteBackView3 sd_addSubviews:@[self.repeatLabel,self.repeatValueLabel]];
    self.repeatLabel.sd_layout
    .leftSpaceToView(self.whiteBackView3, 16)
    .heightIs(14)
    .centerYEqualToView(self.whiteBackView3);
    [self.repeatLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    self.repeatValueLabel.sd_layout
    .rightSpaceToView(self.whiteBackView3, 16)
    .heightIs(14)
    .centerYEqualToView(self.whiteBackView3)
    .leftSpaceToView(self.repeatLabel, 15);
    self.repeatValueLabel.text = @"永不 >";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(comfirm)];
}

/*
- (void)setupDateKeyPan {
    [self.view endEditing:YES];
    if (!self.datePicker) {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        
        //设置地区: zh-中国
        datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        
        //设置日期模式(Displays month, day, and year depending on the locale setting)
//        datePicker.datePickerMode = UIDatePickerModeDate;
        // 设置当前显示时间
        [datePicker setDate:[NSDate date] animated:YES];
        // 设置显示最小时间（此处为当前时间）
        [datePicker setMinimumDate:[NSDate date]];
        
        //设置时间格式
        
        //监听DataPicker的滚动
        [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:datePicker];
        datePicker.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view)
        .heightIs(236);
        self.datePicker = datePicker;
        
        self.inputAccessoryView= [[UIToolbar alloc]init];
        
        self.inputAccessoryView.barStyle= UIBarStyleDefault;
        
        self.inputAccessoryView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
        
        [self.inputAccessoryView sizeToFit];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:ZPMyOrderDetailFontColor forKey:NSForegroundColorAttributeName];
        
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
        [cancelBtn setTitleTextAttributes:dic forState:UIControlStateNormal];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
         [doneBtn setTitleTextAttributes:dic forState:UIControlStateNormal];
        UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        NSArray *array = [NSArray arrayWithObjects:cancelBtn,flexibleSpaceLeft, doneBtn,nil];
        
        [self.inputAccessoryView setItems:array];
        
        [self.view addSubview:self.inputAccessoryView];
        self.inputAccessoryView.sd_layout
        .bottomSpaceToView(self.view, 236)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .heightIs(44);
    }
}

- (void)done {
    [UIView animateWithDuration:.3 animations:^{
        self.datePicker.frame=CGRectMake(0,SCREEN_HEIGHT,SCREEN_WIDTH,236);
        self.inputAccessoryView.frame=CGRectMake(0,SCREEN_HEIGHT,SCREEN_WIDTH,44);
    } completion:^(BOOL finished) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //设置时间格式
        formatter.dateFormat = @"yyyy-MM-dd hh:mm";
        NSString *dateStr = [formatter  stringFromDate:self.datePicker.date];
        [self.timeBtn setTitle:dateStr forState:UIControlStateNormal];
//        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
//        //设置时间格式
//        formatter1.dateFormat = @"yyyy-MM-dd";
//
//        NSString *dateStr1 = [formatter1 stringFromDate:self.datePicker.date];
        self.datePicker = nil;
        self.inputAccessoryView = nil;
    }];
}

- (void)cancel {
    [UIView animateWithDuration:.3 animations:^{
        self.datePicker.frame=CGRectMake(0,SCREEN_HEIGHT,SCREEN_WIDTH,236);
        self.inputAccessoryView.frame=CGRectMake(0,SCREEN_HEIGHT,SCREEN_WIDTH,44);
    } completion:^(BOOL finished) {
        self.datePicker = nil;
        self.inputAccessoryView = nil;
    }];
}
*/

- (void)dateChange:(UIDatePicker *)datePicker {
}

- (void)remind:(UISwitch *)sw {
    if (self.datePicker) {
    
        self.datePicker.sd_layout.heightIs(0);
        self.inputAccessoryView.sd_layout.heightIs(0);
        [self.datePicker removeFromSuperview];
        [self.inputAccessoryView removeFromSuperview];
        self.datePicker = nil;
        self.inputAccessoryView = nil;
        if (!sw.isOn) {
            self.whiteBackView2.hidden = YES;
            self.whiteBackView2.sd_layout.heightIs(0)
            .topSpaceToView(self.whiteBackView1, 0);
        } else {
            self.whiteBackView2.hidden = NO;
            self.whiteBackView2.sd_layout.heightIs(45)
            .topSpaceToView(self.whiteBackView1, 1);
        }
    } else {
        if (!sw.isOn) {
            self.whiteBackView2.hidden = YES;
            self.whiteBackView2.sd_layout.heightIs(0)
            .topSpaceToView(self.whiteBackView1, 0);
        } else {
            self.whiteBackView2.hidden = NO;
            self.whiteBackView2.sd_layout.heightIs(45)
            .topSpaceToView(self.whiteBackView1, 1);
        }
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.datePicker) {
        self.datePicker.sd_layout.heightIs(0);
        self.inputAccessoryView.sd_layout.heightIs(0);
        [self.datePicker removeFromSuperview];
        [self.inputAccessoryView removeFromSuperview];
        self.datePicker = nil;
        self.inputAccessoryView = nil;
    }
}

- (void)repeatList {
    UHRepeatListController *list = [[UHRepeatListController alloc] init];
    list.str = self.repeatValueLabel.text;
    list.selectedBlock = ^(NSString *str) {
        self.repeatValueLabel.text = [NSString stringWithFormat:@"%@ >",str];
    };
    [self.navigationController pushViewController:list animated:YES];
}

- (void)comfirm {
    if (!self.contentTextField.text.length) {
        [MBProgressHUD showError:@"请输入内容"];
        return;
    }
    if (self.itemModel) {
        //更新
        [MBProgressHUD showMessage:@"更新中..."];
        NSString *needRemindFlag = @"";
        if (self.sw.isOn) {
            needRemindFlag = @"ENABLED";
        } else {
            needRemindFlag = @"DISABLED";
        }
        NSString *repeatType = @"";
        if ([self.repeatValueLabel.text containsString:@"永不"]) {
            repeatType = @"NO_REPEAT";
        } else if ([self.repeatValueLabel.text containsString:@"每天"]) {
            repeatType = @"EVERY_DAY";
        } else if ([self.repeatValueLabel.text containsString:@"每周"]){
            repeatType = @"EVERY_WEEK";
        }
        NSDictionary *msg = @{@"planId":self.model.planId,@"content":self.contentTextField.text,@"repeatType":repeatType,@"needRemindFlag":needRemindFlag,@"remindTime":self.sw.isOn?self.timeTextField.text:@"",@"itemId":self.itemModel.itemId};
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"item" parameters:msg progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [MBProgressHUD hideHUD];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                [MBProgressHUD showSuccess:@"更新成功!"];
                if (self.successBlock) {
                    self.successBlock();
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHLittleAimController class]];
    } else {
        [MBProgressHUD showMessage:@"创建中..."];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/my/plan/plan/item",ZPBaseUrl]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        request.HTTPMethod = @"PUT";
        
        request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};//此处为请求头，类型为字典
        
        NSString *needRemindFlag = @"";
        if (self.sw.isOn) {
            needRemindFlag = @"ENABLED";
        } else {
            needRemindFlag = @"DISABLED";
        }
        NSString *repeatType = @"";
        if ([self.repeatValueLabel.text containsString:@"永不"]) {
            repeatType = @"NO_REPEAT";
        } else if ([self.repeatValueLabel.text containsString:@"每天"]) {
            repeatType = @"EVERY_DAY";
        } else if ([self.repeatValueLabel.text containsString:@"每周"]){
            repeatType = @"EVERY_WEEK";
        }
        NSDictionary *msg = @{@"planId":self.model.planId,@"content":self.contentTextField.text,@"repeatType":repeatType,@"needRemindFlag":needRemindFlag,@"remindTime":self.sw.isOn?self.timeTextField.text:@""};
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:msg options:NSJSONWritingPrettyPrinted error:nil];
        
        request.HTTPBody = data;
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"%@ --------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                if (error == nil) {
                    NSDictionary *dict = [data mj_JSONObject];
                    if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                        [MBProgressHUD showSuccess:@"创建小目标成功"];
                        if (self.sw.isOn) {
                            [self createNotiWithID:[NSString stringWithFormat:@"%@",[dict objectForKey:@"data"]]];
                        }
                        if (self.successBlock) {
                            self.successBlock();
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    } else {
                        [MBProgressHUD showError:[dict objectForKey:@"message"]];
                    }
                } else {
                    [MBProgressHUD showError:error.localizedDescription];
                }
            });
            
            
            
        }] resume];
        
    }
    
}


- (void)createNotiWithID:(NSString *)ID {
    //判断是否已经授权用户发送通知
//    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
//        UILocalNotification *notification = [[UILocalNotification alloc] init];
//        UIUserNotificationSettings *local = [UIUserNotificationSettings settingsForTypes:1 << 2 categories:nil];
//         [[UIApplication sharedApplication] registerUserNotificationSettings:local];
//        if (notification) {
//            notification.applicationIconBadgeNumber += 1;
//            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
//            notification.timeZone = nil;
//            notification.alertBody = self.contentTextField.text;
//            notification.hasAction = YES;
//            notification.repeatInterval = 5;
//            //用来删除 本地通知
//            notification.userInfo = @{@"idenify":@""};
//            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//        }
//    } else{
//        //用户注册通知，注册后才能收到通知，这会给用户一个弹框，提示用户选择是否允许发送通知
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound   categories:nil]];
//    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm";
    
    NSDate *date = [dateFormatter dateFromString:self.timeTextField.text];
    if ([self.repeatValueLabel.text containsString:@"永不"]) {
        [NSObject registerLocalNotification:date content:self.contentTextField.text key:ID interval:0];
    } else if ([self.repeatValueLabel.text containsString:@"每天"]) {
        [NSObject registerLocalNotification:date content:self.contentTextField.text key:ID interval:NSCalendarUnitDay];
    } else {
        [NSObject registerLocalNotification:date content:self.contentTextField.text key:ID interval:NSCalendarUnitWeekday];
    }
}

- (UITextField *)contentTextField {
    if (!_contentTextField) {
        _contentTextField = [UITextField new];
        _contentTextField.placeholder = @"请输入内容";
        _contentTextField.textColor = ZPMyOrderDetailFontColor;
        _contentTextField.font = [UIFont systemFontOfSize:15];
        _contentTextField.backgroundColor = [UIColor whiteColor];
        _contentTextField.delegate  =self;
    }
    return _contentTextField;
}

- (UIView *)whiteBackView1 {
    if (!_whiteBackView1) {
        _whiteBackView1 = [UIView new];
        _whiteBackView1.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBackView1;
}

- (UIView *)whiteBackView2 {
    if (!_whiteBackView2) {
        _whiteBackView2 = [UIView new];
        _whiteBackView2.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBackView2;
}

- (UIButton *)whiteBackView3 {
    if (!_whiteBackView3) {
        _whiteBackView3 = [UIButton new];
        [_whiteBackView3 setBackgroundColor:[UIColor whiteColor]];
        [_whiteBackView3 addTarget:self action:@selector(repeatList) forControlEvents:UIControlEventTouchUpInside];
    }
    return _whiteBackView3;
}


- (UILabel *)timeLable {
    if (!_timeLable) {
        _timeLable = [UILabel new];
        _timeLable.textColor = ZPMyOrderDetailValueFontColor;
        _timeLable.font = [UIFont systemFontOfSize:14];
        _timeLable.text = @"提醒时间";
    }
    return _timeLable;
}

- (UILabel *)tipLable {
    if (!_tipLable) {
        _tipLable = [UILabel new];
        _tipLable.textColor = ZPMyOrderDetailFontColor;
        _tipLable.font = [UIFont systemFontOfSize:14];
        _tipLable.text = @"在指定时间提醒我";
    }
    return _tipLable;
}

- (UILabel *)repeatLabel {
    if (!_repeatLabel) {
        _repeatLabel = [UILabel new];
        _repeatLabel.textColor = ZPMyOrderDetailValueFontColor;
        _repeatLabel.font = [UIFont systemFontOfSize:14];
        _repeatLabel.text = @"重复提醒";
    }
    return _repeatLabel;
}

- (UILabel *)repeatValueLabel {
    if (!_repeatValueLabel) {
        _repeatValueLabel = [UILabel new];
        _repeatValueLabel.textColor = ZPMyOrderDetailFontColor;
        _repeatValueLabel.font = [UIFont systemFontOfSize:14];
        _repeatValueLabel.text = @"";
        _repeatValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _repeatValueLabel;
}

/*
- (UIButton *)timeBtn {
    if (!_timeBtn) {
        _timeBtn = [UIButton new];
        [_timeBtn addTarget:self action:@selector(setupDateKeyPan) forControlEvents:UIControlEventTouchUpInside];
        _timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_timeBtn setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
        [_timeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
    return _timeBtn;
}
*/

- (UITextField *)timeTextField {
    if (!_timeTextField) {
        _timeTextField = [UITextField new];
        _timeTextField.font = [UIFont systemFontOfSize:14];
        _timeTextField.textColor = ZPMyOrderDetailFontColor;
        _timeTextField.datePickerInput = YES;
        _timeTextField.datePickerSetMin = YES;
        _timeTextField.textAlignment = NSTextAlignmentRight;
    }
    return _timeTextField;
}

- (UISwitch *)sw {
    if (!_sw) {
        _sw = [UISwitch new];
        [_sw addTarget:self action:@selector(remind:) forControlEvents:UIControlEventValueChanged];
    }
    return _sw;
}

- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [UIView new];
        _leftView.backgroundColor = [UIColor whiteColor];
    }
    return _leftView;
}


@end
