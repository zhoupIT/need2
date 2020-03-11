//
//  UHLipidsController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/9.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHLipidsController.h"
#import "UHBloodPressureCell.h"
#import "UHBloodPressureModel.h"
#import "UHNiBPModel.h"
#import "OttoKeyboardView.h"
@interface UHLipidsController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UILabel *tcLabel;
@property (nonatomic,strong) UILabel *tgLabel;
@property (nonatomic,strong) UILabel *hdlcLabel;
@property (nonatomic,strong) UILabel *ldlcLabel;
@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) OttoTextField *tcTextField;
@property (nonatomic,strong) OttoTextField *tgTextField;
@property (nonatomic,strong) OttoTextField *hdlcTextField;
@property (nonatomic,strong) OttoTextField *ldlcTextField;
@property (nonatomic,strong) UITextField *timeTextField;

@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) UIButton *cancelButton;

@property (nonatomic,strong) UIView *lineView0;
@property (nonatomic,strong) UIView *lineView1;
@property (nonatomic,strong) UIView *lineView2;
@property (nonatomic,strong) UIView *lineView3;
@property (nonatomic,strong) UIView *lineView4;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *buaLabel;
@property (nonatomic,strong) UILabel *stateLabel;
@property (nonatomic,strong) UILabel *headtimeLabel;
@property (nonatomic,strong) UILabel *checkLabel;
@end

@implementation UHLipidsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
    [self setupRefresh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupRefresh {
    __weak typeof(self) weakSelf = self;
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_header endRefreshing];
        //血氧查询
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"bf" parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [UHNiBPModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (!arrays.count) {
                    [tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    weakSelf.data = [NSMutableArray arrayWithArray:arrays];
                    [tableView reloadData];
                    tableView.sd_layout.heightIs(40*weakSelf.data.count);
                    [weakSelf.scrollView setupAutoContentSizeWithBottomView:tableView bottomMargin:10];
                    [tableView updateLayout];
                    [weakSelf.scrollView updateLayout];
                }
            } else {
                
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHLipidsController class]];

        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
}

- (void)initAll {
    self.title = @"血脂监测";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view sd_addSubviews:@[self.scrollView,self.saveButton,self.cancelButton]];
    self.scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 50, 0));
    
    
    [self.scrollView sd_addSubviews:@[self.tcLabel,self.tgLabel,self.ldlcLabel,self.hdlcLabel,self.timeLabel,self.tcTextField,self.tgTextField,self.ldlcTextField,self.hdlcTextField,self.timeTextField,self.lineView0,self.lineView1,self.lineView2,self.lineView3,self.lineView4]];
    
    
    self.tcLabel.sd_layout
    .leftSpaceToView(self.scrollView, 16)
    .topSpaceToView(self.scrollView, 18)
    .heightIs(16)
    .rightSpaceToView(self.scrollView, 16);
    
    self.tcTextField.sd_layout
    .topSpaceToView(self.tcLabel, 19)
    .leftSpaceToView(self.scrollView, 16)
    .rightSpaceToView(self.scrollView, 16)
    .heightIs(14);
    self.lineView0.sd_layout
    .topSpaceToView(self.tcTextField, 13)
    .leftSpaceToView(self.scrollView, 16)
    .rightSpaceToView(self.scrollView, 16)
    .heightIs(1);
    
    self.tgLabel.sd_layout
    .leftSpaceToView(self.scrollView, 16)
    .topSpaceToView(self.tcTextField, 37)
    .heightIs(16)
    .rightSpaceToView(self.scrollView, 16);
    
    self.tgTextField.sd_layout
    .topSpaceToView(self.tgLabel, 19)
    .leftSpaceToView(self.scrollView, 16)
    .rightSpaceToView(self.scrollView, 16)
    .heightIs(14);
    self.lineView1.sd_layout
    .topSpaceToView(self.tgTextField, 13)
    .leftSpaceToView(self.scrollView, 16)
    .rightSpaceToView(self.scrollView, 16)
    .heightIs(1);
    
    self.hdlcLabel.sd_layout
    .leftSpaceToView(self.scrollView, 16)
    .topSpaceToView(self.tgTextField, 37)
    .heightIs(16)
    .rightSpaceToView(self.scrollView, 16);
    
    self.hdlcTextField.sd_layout
    .topSpaceToView(self.hdlcLabel, 19)
    .leftSpaceToView(self.scrollView, 16)
    .rightSpaceToView(self.scrollView, 16)
    .heightIs(14);
    self.lineView2.sd_layout
    .topSpaceToView(self.hdlcTextField, 13)
    .leftSpaceToView(self.scrollView, 16)
    .rightSpaceToView(self.scrollView, 16)
    .heightIs(1);
    
    
    self.ldlcLabel.sd_layout
    .leftSpaceToView(self.scrollView, 16)
    .topSpaceToView(self.hdlcTextField, 37)
    .heightIs(16)
    .rightSpaceToView(self.scrollView, 16);
    
    self.ldlcTextField.sd_layout
    .topSpaceToView(self.ldlcLabel, 19)
    .leftSpaceToView(self.scrollView, 16)
    .rightSpaceToView(self.scrollView, 16)
    .heightIs(14);
    self.lineView3.sd_layout
    .topSpaceToView(self.ldlcTextField, 13)
    .leftSpaceToView(self.scrollView, 16)
    .rightSpaceToView(self.scrollView, 16)
    .heightIs(1);
    
    self.timeLabel.sd_layout
    .leftSpaceToView(self.scrollView, 16)
    .topSpaceToView(self.ldlcTextField, 37)
    .heightIs(16)
    .rightSpaceToView(self.scrollView, 16);
    
    self.timeTextField.sd_layout
    .topSpaceToView(self.timeLabel, 19)
    .leftSpaceToView(self.scrollView, 16)
    .rightSpaceToView(self.scrollView, 16)
    .heightIs(14);
    self.lineView4.sd_layout
    .topSpaceToView(self.timeTextField, 13)
    .leftSpaceToView(self.scrollView, 16)
    .rightSpaceToView(self.scrollView, 16)
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
    
    [self.scrollView addSubview:self.headView];
    self.headView.sd_layout
    .topSpaceToView(self.lineView4, 45)
    .leftEqualToView(self.scrollView)
    .rightEqualToView(self.scrollView)
    .heightIs(40);
    
    [self.headView sd_addSubviews:@[self.typeLabel,self.buaLabel,self.stateLabel,self.headtimeLabel,self.checkLabel]];
    self.typeLabel.sd_layout
    .leftEqualToView(self.headView)
    .widthIs(self.isCompany?50:80)
    .topEqualToView(self.headView)
    .bottomEqualToView(self.headView);
    
    self.buaLabel.sd_layout
    .leftSpaceToView(self.typeLabel, 0)
    .widthIs(100)
    .topEqualToView(self.headView)
    .bottomEqualToView(self.headView);
    
    self.stateLabel.sd_layout
    .leftSpaceToView(self.buaLabel, 0)
    .widthIs(60)
    .topEqualToView(self.headView)
    .bottomEqualToView(self.headView);
    
    if (self.isCompany) {
        self.checkLabel.sd_layout
        .widthIs(40)
        .rightSpaceToView(self.headView, 0)
        .topEqualToView(self.headView)
        .bottomEqualToView(self.headView);
        
        self.headtimeLabel.sd_layout
        .leftSpaceToView(self.stateLabel, 0)
        .rightSpaceToView(self.checkLabel, 0)
        .topEqualToView(self.headView)
        .bottomEqualToView(self.headView);
    } else {
        self.headtimeLabel.sd_layout
        .leftSpaceToView(self.stateLabel, 0)
        .rightEqualToView(self.headView)
        .topEqualToView(self.headView)
        .bottomEqualToView(self.headView);
    }
    
    [self.scrollView addSubview:self.tableView];
    self.tableView.sd_layout
    .topSpaceToView(self.headView, 0)
    .leftEqualToView(self.scrollView)
    .rightEqualToView(self.scrollView);
}

- (void)saveAction:(UIButton *)btn {
    if (!self.tcTextField.text.length || !self.tgTextField.text.length || !self.hdlcTextField.text.length|| !self.ldlcTextField.text.length) {
        [MBProgressHUD showError:@"值不能为空"];
        return;
    }
    NSString *timeStr = self.timeTextField.text;
    if (!timeStr.length) {
        [MBProgressHUD showError:@"请选择检测时间"];
        return;
    }
    __weak typeof(self) weakSelf =self;
    [MBProgressHUD showMessage:@"录入中..."];
    [[ZPNetWork sharedZPNetWork] requestWithUrl:@"api/chronic/bf" andHTTPMethod:@"PUT" andDict:@{@"tc":self.tcTextField.text,@"tg":self.tgTextField.text,@"hdlc":self.hdlcTextField.text,@"ldlc":self.ldlcTextField.text,@"detectDate":timeStr} success:^(NSDictionary *response) {
        [MBProgressHUD showSuccess:@"录入成功"];
        weakSelf.tcTextField.text= @"";
        weakSelf.tgTextField.text= @"";
        weakSelf.hdlcTextField.text= @"";
        weakSelf.ldlcTextField.text= @"";
        [weakSelf.tableView.mj_header beginRefreshing];
    } failed:^(NSError *error) {
        
    }];
}

- (void)cancelAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
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
    
    return self.data.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UHBloodPressureCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHBloodPressureCell class])];
    cell.bfModel = self.data[indexPath.row];
    cell.checkBlock = ^(UHNiBPModel *model) {
        if (!ZPIsExist_String(model.testRecordId)) {
            [MBProgressHUD showError:@"无报告"];
            return;
        }
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"idata/message" parameters:@{@"testRecordID":model.testRecordId} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                [EBBannerView showWithContent:[[response objectForKey:@"data"] objectForKey:@"message"]];
            } else {
                
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            
        } className:[UHLipidsController class]];
        
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!self.timeTextField.text.length) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    textField.text = [formatter stringFromDate:[NSDate date]];
    }
}

- (UILabel *)tcLabel {
    if (!_tcLabel) {
        _tcLabel = [UILabel new];
        _tcLabel.textColor = ZPMyOrderDetailFontColor;
        _tcLabel.font = [UIFont systemFontOfSize:15];
        _tcLabel.text = @"TC-总胆固醇(mmol/L) :";
    }
    return _tcLabel;
}

- (UILabel *)tgLabel {
    if (!_tgLabel) {
        _tgLabel = [UILabel new];
        _tgLabel.textColor = ZPMyOrderDetailFontColor;
        _tgLabel.font = [UIFont systemFontOfSize:15];
        _tgLabel.text = @"TG-甘油三酯(mmol/L) :";
    }
    return _tgLabel;
}
- (UILabel *)hdlcLabel {
    if (!_hdlcLabel) {
        _hdlcLabel = [UILabel new];
        _hdlcLabel.textColor = ZPMyOrderDetailFontColor;
        _hdlcLabel.font = [UIFont systemFontOfSize:15];
        _hdlcLabel.text = @"HDLC-高密度脂蛋白胆固醇(mmol/L) :";
    }
    return _hdlcLabel;
}
- (UILabel *)ldlcLabel {
    if (!_ldlcLabel) {
        _ldlcLabel = [UILabel new];
        _ldlcLabel.textColor = ZPMyOrderDetailFontColor;
        _ldlcLabel.font = [UIFont systemFontOfSize:15];
        _ldlcLabel.text = @"LDLC-低密度脂蛋白胆固醇(mmol/L) :";
    }
    return _ldlcLabel;
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

- (UITextField *)tcTextField {
    if (!_tcTextField) {
        _tcTextField = [OttoTextField new];
        _tcTextField.textColor = ZPMyOrderDetailFontColor;
        _tcTextField.font = [UIFont systemFontOfSize:14];
        _tcTextField.placeholder = @"请输入TC值";
         [_tcTextField setNumberKeyboardType:NumberKeyboardTypeDouble];
    }
    return _tcTextField;
}

- (UITextField *)tgTextField {
    if (!_tgTextField) {
        _tgTextField = [OttoTextField new];
        _tgTextField.textColor = ZPMyOrderDetailFontColor;
        _tgTextField.font = [UIFont systemFontOfSize:14];
        _tgTextField.placeholder = @"请输入TG值";
         [_tgTextField setNumberKeyboardType:NumberKeyboardTypeDouble];
    }
    return _tgTextField;
}

- (UITextField *)hdlcTextField {
    if (!_hdlcTextField) {
        _hdlcTextField = [OttoTextField new];
        _hdlcTextField.textColor = ZPMyOrderDetailFontColor;
        _hdlcTextField.font = [UIFont systemFontOfSize:14];
        _hdlcTextField.placeholder = @"请输入HDLC值";
        [_hdlcTextField setNumberKeyboardType:NumberKeyboardTypeDouble];
    }
    return _hdlcTextField;
}

- (UITextField *)ldlcTextField {
    if (!_ldlcTextField) {
        _ldlcTextField = [OttoTextField new];
        _ldlcTextField.textColor = ZPMyOrderDetailFontColor;
        _ldlcTextField.font = [UIFont systemFontOfSize:14];
        _ldlcTextField.placeholder = @"请输入LDLC值";
        [_ldlcTextField setNumberKeyboardType:NumberKeyboardTypeDouble];
    }
    return _ldlcTextField;
}

- (UITextField *)timeTextField {
    if (!_timeTextField) {
        _timeTextField = [UITextField new];
        _timeTextField.textColor = ZPMyOrderDetailFontColor;
        _timeTextField.font = [UIFont systemFontOfSize:14];
        _timeTextField.datePickerInput = YES;
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

-(UIView *)lineView4 {
    if (!_lineView4) {
        _lineView4 = [UIView new];
        _lineView4.backgroundColor = KControlColor;
    }
    return _lineView4;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [UIView new];
        _headView.backgroundColor = RGB(99, 187, 255);
    }
    return _headView;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UHBloodPressureCell class] forCellReuseIdentifier:NSStringFromClass([UHBloodPressureCell class])];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [UILabel new];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.font = [UIFont systemFontOfSize:13];
        _typeLabel.text = @"指标";
    }
    return _typeLabel;
}

- (UILabel *)buaLabel {
    if (!_buaLabel) {
        _buaLabel = [UILabel new];
        _buaLabel.textAlignment = NSTextAlignmentCenter;
        _buaLabel.textColor = [UIColor whiteColor];
        _buaLabel.font = [UIFont systemFontOfSize:13];
        _buaLabel.text = @"mmol/L";
    }
    return _buaLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [UILabel new];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.font = [UIFont systemFontOfSize:13];
        _stateLabel.text = @"状态";
    }
    return _stateLabel;
}

- (UILabel *)headtimeLabel {
    if (!_headtimeLabel) {
        _headtimeLabel = [UILabel new];
        _headtimeLabel.textAlignment = NSTextAlignmentCenter;
        _headtimeLabel.textColor = [UIColor whiteColor];
        _headtimeLabel.font = [UIFont systemFontOfSize:13];
        _headtimeLabel.text = @"时间";
    }
    return _headtimeLabel;
}
- (UILabel *)checkLabel {
    if (!_checkLabel) {
        _checkLabel = [UILabel new];
        _checkLabel.font = [UIFont systemFontOfSize:13];
        _checkLabel.text = @"报告";
        _checkLabel.textColor = [UIColor whiteColor];
        _checkLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _checkLabel;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
    }
    return _scrollView;
}
@end
