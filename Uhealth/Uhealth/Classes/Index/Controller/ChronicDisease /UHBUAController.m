//
//  UHBUAController.m
//  Uhealth 血尿酸
//
//  Created by Biao Geng on 2018/5/9.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHBUAController.h"
#import "UHBuaCell.h"
#import "UHBloodPressureModel.h"
#import "UHNiBPModel.h"
@interface UHBUAController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UILabel *uatitleLabel;
@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UITextField *uatitleTextField;
@property (nonatomic,strong) UITextField *timeTextField;

@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) UIButton *cancelButton;

@property (nonatomic,strong) UIView *lineView2;
@property (nonatomic,strong) UIView *lineView3;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UILabel *buaLabel;
@property (nonatomic,strong) UILabel *stateLabel;
@property (nonatomic,strong) UILabel *headtimeLabel;
@property (nonatomic,strong) UILabel *checkLabel;
@end

@implementation UHBUAController

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
        //血尿酸查询
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"ua" parameters:nil progress:^(NSProgress *progress) {
            
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
        } className:[UHBUAController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
}

- (void)initAll {
    self.title = @"血尿酸监测";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    self.scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 50, 0));
    [self.scrollView sd_addSubviews:@[self.uatitleLabel,self.timeLabel,self.uatitleTextField,self.timeTextField,self.lineView2,self.lineView3]];
    [self.view sd_addSubviews:@[self.saveButton,self.cancelButton]];
    
    
    self.uatitleLabel.sd_layout
    .leftSpaceToView(self.scrollView, 16)
    .topSpaceToView(self.scrollView, 18)
    .heightIs(16)
    .rightSpaceToView(self.scrollView, 16);
    
    self.uatitleTextField.sd_layout
    .topSpaceToView(self.uatitleLabel, 19)
    .leftSpaceToView(self.scrollView, 16)
    .rightSpaceToView(self.scrollView, 16)
    .heightIs(14);
    self.lineView2.sd_layout
    .topSpaceToView(self.uatitleTextField, 13)
    .leftSpaceToView(self.scrollView, 16)
    .rightSpaceToView(self.scrollView, 16)
    .heightIs(1);
    
    self.timeLabel.sd_layout
    .leftSpaceToView(self.scrollView, 16)
    .topSpaceToView(self.uatitleTextField, 37)
    .heightIs(16)
    .rightSpaceToView(self.scrollView, 16);
    
    self.timeTextField.sd_layout
    .topSpaceToView(self.timeLabel, 19)
    .leftSpaceToView(self.scrollView, 16)
    .rightSpaceToView(self.scrollView, 16)
    .heightIs(14);
    self.lineView3.sd_layout
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
    .topSpaceToView(self.lineView3, 45)
    .leftEqualToView(self.scrollView)
    .rightEqualToView(self.scrollView)
    .heightIs(40);
    
    [self.headView sd_addSubviews:@[self.buaLabel,self.stateLabel,self.headtimeLabel,self.checkLabel]];
    self.buaLabel.sd_layout
    .leftEqualToView(self.headView)
    .widthIs(100)
    .topEqualToView(self.headView)
    .bottomEqualToView(self.headView);
    
    self.stateLabel.sd_layout
    .leftSpaceToView(self.buaLabel, 0)
    .widthIs(100)
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

/**
 *  保存
 */
- (void)saveAction:(UIButton *)btn {
    if (!self.uatitleTextField.text.length || !self.uatitleTextField.text.length) {
        [MBProgressHUD showError:@"值不能为空"];
        return;
    }
    NSString *timeStr = self.timeTextField.text;
    if (!timeStr.length) {
        [MBProgressHUD showError:@"请选择检测时间"];
        return;
    }
    
    [MBProgressHUD showMessage:@"录入中..."];
    WEAK_SELF(weakSelf);
    [[ZPNetWork sharedZPNetWork] requestWithUrl:@"api/chronic/ua" andHTTPMethod:@"PUT" andDict:@{@"ua":self.uatitleTextField.text,@"detectDate":timeStr} success:^(NSDictionary *response) {
            weakSelf.uatitleTextField.text = @"";
            [MBProgressHUD showSuccess:@"录入成功"];
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
    UHBuaCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHBuaCell class])];
    cell.uaModel = self.data[indexPath.row];
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
            
        } className:[UHBUAController class]];
        
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


- (UILabel *)uatitleLabel {
    if (!_uatitleLabel) {
        _uatitleLabel = [UILabel new];
        _uatitleLabel.textColor = ZPMyOrderDetailFontColor;
        _uatitleLabel.font = [UIFont systemFontOfSize:15];
        _uatitleLabel.text = @"血尿酸(μmol/L) :";
    }
    return _uatitleLabel;
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

- (UITextField *)uatitleTextField {
    if (!_uatitleTextField) {
        _uatitleTextField = [UITextField new];
        _uatitleTextField.textColor = ZPMyOrderDetailFontColor;
        _uatitleTextField.font = [UIFont systemFontOfSize:14];
        _uatitleTextField.placeholder = @"请输入血尿酸值";
        _uatitleTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _uatitleTextField;
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
        [_tableView registerClass:[UHBuaCell class] forCellReuseIdentifier:NSStringFromClass([UHBuaCell class])];
        _tableView.tableFooterView = [UIView new];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (UILabel *)buaLabel {
    if (!_buaLabel) {
        _buaLabel = [UILabel new];
        _buaLabel.textAlignment = NSTextAlignmentCenter;
        _buaLabel.textColor = [UIColor whiteColor];
        _buaLabel.font = [UIFont systemFontOfSize:13];
        _buaLabel.text = @"血尿酸(μmol/L)";
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
