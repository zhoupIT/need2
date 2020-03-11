//
//  UHNotificationController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHNotificationController.h"
#import "UHNotificationCell.h"
#import "UHNotiModel.h"
#import "UHMyFileDetailController.h"
@interface UHNotificationController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;
@end

@implementation UHNotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
    [self setupRefresh];
   
}

- (void)initAll {
    self.title = @"系统通知";
    self.view.backgroundColor = KControlColor;
    [self.view addSubview:self.tableView];
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无通知"
                                                           detailStr:@""];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupRefresh {
    __unsafe_unretained UITableView *tableView = self.tableView;
    WEAK_SELF(weakSelf);
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"message/message" parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [weakSelf.tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                weakSelf.data = [UHNotiModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_footer  resetNoMoreData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [weakSelf.tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHNotificationController class]];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"message/message" parameters:@{@"offset":[NSNumber numberWithInteger:self.data.count]} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [weakSelf.tableView.mj_footer endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [UHNotiModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (!arrays.count) {
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                   
                } else {
                    [weakSelf.data addObjectsFromArray:arrays];
                    [weakSelf.tableView reloadData];
                }
            } else {
                
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            
            // 结束刷新
            [weakSelf.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHNotificationController class]];
    }];
    
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
    UHNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHNotificationCell class])];
    cell.model = self.data[indexPath.row];
    cell.detailContentBlock = ^(UHNotiModel *model) {
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"message/message" parameters:@{@"messageId":model.messageId} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHNotificationController class]];
        UHMyFileDetailController *fileDetailControl = [[UHMyFileDetailController alloc] init];
        fileDetailControl.ID = model.extraParam;
        [self.navigationController pushViewController:fileDetailControl animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UHNotiModel *model =self.data[indexPath.row];
   return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[UHNotificationCell class] contentViewWidth:SCREEN_WIDTH];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource  =self;
        [_tableView registerClass:[UHNotificationCell class] forCellReuseIdentifier:NSStringFromClass([UHNotificationCell class])];
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}
@end
