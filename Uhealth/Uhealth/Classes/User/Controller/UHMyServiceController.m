//
//  UHMyServiceController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/30.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyServiceController.h"
#import "UHMyServiceCell.h"
#import "UHMyServiceDetailController.h"
#import "UHMyServiceModel.h"
@interface UHMyServiceController ()
@property (nonatomic,strong) NSMutableArray *data;
@end

@implementation UHMyServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.title = @"我的服务";
    self.tableView.backgroundColor = KControlColor;
    self.tableView.tableFooterView = [UIView new];
    [self setupRefresh];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无服务"
                                                           detailStr:@""];
}

- (void)setupRefresh {
    
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"channel/service" parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                self.data = [UHMyServiceModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                [tableView reloadData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHMyServiceController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
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
    UHMyServiceCell *cell = [UHMyServiceCell cellWithTabelView:tableView];
    cell.model = self.data[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 177;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UHMyServiceDetailController *serviceDetailCtrol = [[UHMyServiceDetailController alloc] init];
    serviceDetailCtrol.model = self.data[indexPath.row];
    [self.navigationController pushViewController:serviceDetailCtrol animated:YES];
}
@end
