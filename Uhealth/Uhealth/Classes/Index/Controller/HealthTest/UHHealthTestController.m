//
//  UHHealthTestController.m
//  Uhealth 健康自测
//
//  Created by Biao Geng on 2018/4/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHHealthTestController.h"
#import "UHHealthTestCell.h"
#import "UHHealthTestModel.h"
#import "UHHealthTestWebViewController.h"
#import "UHLoginController.h"
#import "UHNavigationController.h"
#import "UHUserModel.h"
#import "UHMentalManageController.h"
#import "UHPsychologicalAssessmentController.h"
@interface UHHealthTestController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation UHHealthTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
}

- (void)setupUI {
    [MBProgressHUD showMessage:@"加载中"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    self.webView.sd_layout
    .topEqualToView(self.view)
    .heightIs(1)
    .widthIs(1)
    .leftEqualToView(self.view);
    [self.view addSubview:self.tableView];
     [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/#/healthySelfTest/dailyTestIndexIos",ZPBaseUrl]]]];
    self.webView.delegate = self;
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(15, 15, 0, 15));
}

- (void)setupData {
    self.title = @"健康自测";
//    for (int i = 1; i<=2; i++) {
//        UHHealthTestModel *model = [[UHHealthTestModel alloc] init];
//        model.imageName = [NSString stringWithFormat:@"index_test%d",i];
//        [self.data addObject:model];
//    }
    UHHealthTestModel *model = [[UHHealthTestModel alloc] init];
    model.imageName = [NSString stringWithFormat:@"index_test%d",1];
    [self.data addObject:model];
    
//    UHHealthTestModel *model1 = [[UHHealthTestModel alloc] init];
//    model1.imageName = [NSString stringWithFormat:@"index_test%d",3];
//    [self.data addObject:model1];
    
    [self.tableView reloadData];
}

#pragma mark - -tableView的数据源方法
/**
 *  返回组数(默认为1组)
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.data.count;
}

/**
 *  返回每组的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UHHealthTestCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHHealthTestCell class])];
    cell.model = self.data[indexPath.section];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ZPHeight(110);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        UHHealthTestWebViewController *testWebViewControl = [[UHHealthTestWebViewController alloc] init];
        [self.navigationController pushViewController:testWebViewControl animated:YES];
    } else {
//        UHMentalManageController *mentalManageControl = [[UHMentalManageController alloc] init];
//        mentalManageControl.urlStr = @"http://rxenon.nuanxin-health.com/service/scale/scale_front/entry/?article=&token=eyJhbGciOiJIUzI1NiIsImluaSI6MTUyNTMyOTMyOS42OTU3NDYsImV4cCI6MTU1Njg2NTMyOS42OTU3NDYsInRpbWluZyI6dHJ1ZX0.eyJhcHAiOiI1YTFiN2FhODU1ZDM1ZTI3MDQ1OTMxNjQiLCJjaGFubmVsIjoiNWFlYWFjY2NlYTVkZmMwNjI1ZWU3NDNmIiwicGxhdGZvcm0iOiI1YWVhYWM4NGVhNWRmYzA2MjVlZTc0M2UifQ.rSVRsEDYCObizwdBZ8nSnr8O7_TQwVrTOvS6_SthgQI";
//        [self.navigationController pushViewController:mentalManageControl animated:YES]; 
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
   
    UHUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
    // 设置localStorage
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"localStorage.setItem('userInfo', '%@')",[model mj_JSONString]]];
     [MBProgressHUD hideHUD];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UHHealthTestCell class] forCellReuseIdentifier:NSStringFromClass([UHHealthTestCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}

-(NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}
@end
