//
//  UHHealthWindController.m
//  Uhealth 健康风向
//
//  Created by Biao Geng on 2018/4/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHHealthWindController.h"
#import "UHHealthWindCell.h"
#import "UHHealthWindModel.h"
#import "UHHealthWindWebViewController.h"
#import "UHHealthWindOneImageCell.h"
@interface UHHealthWindController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;
@end

@implementation UHHealthWindController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.title = @"优医健康";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(5, 0, 0, 0));
    [self setupRefresh];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无文章"
                                                           detailStr:@""];
}


- (void)setupRefresh {
    WEAK_SELF(weakSelf);
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"healthDirection/list" parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                weakSelf.data = [UHHealthWindModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                [tableView reloadData];
                [tableView.mj_footer resetNoMoreData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHHealthWindController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"healthDirection/list" parameters:@{@"offset":[NSNumber numberWithInteger:self.data.count]} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [UHHealthWindModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (!arrays.count) {
                    
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.data addObjectsFromArray:arrays];
                    [self.tableView reloadData];
                    
                }
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHHealthWindController class]];
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
    UHHealthWindModel *model = self.data[indexPath.row];
    if (model.titleImgList.count == 1) {
        UHHealthWindOneImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHHealthWindOneImageCell class])];
        cell.model = model;
        return cell;
    }
    UHHealthWindCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHHealthWindCell class])];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UHHealthWindModel *model = self.data[indexPath.row];
    UHHealthWindWebViewController *windWebViewControl = [[UHHealthWindWebViewController alloc] init];
    if ([ZPBaseUrl isEqualToString:@"http://192.168.8.20"]) {
    windWebViewControl.urlStr = [NSString stringWithFormat:@"%@/h5/app/#/healthyWindDirection/windDetailIos?id=%@",ZPBaseUrl,model.directionId];
    } else {
        windWebViewControl.urlStr = [NSString stringWithFormat:@"%@/#/healthyWindDirection/windDetailIos?id=%@",ZPBaseUrl,model.directionId];
    }
    windWebViewControl.windModel = model;
    [self.navigationController pushViewController:windWebViewControl animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     UHHealthWindModel *model = self.data[indexPath.row];
    if (model.titleImgList.count==1) {
          return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[UHHealthWindOneImageCell class] contentViewWidth:SCREEN_WIDTH];
    }
   
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[UHHealthWindCell class] contentViewWidth:SCREEN_WIDTH];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UHHealthWindCell class] forCellReuseIdentifier:NSStringFromClass([UHHealthWindCell class])];
        [_tableView registerClass:[UHHealthWindOneImageCell class] forCellReuseIdentifier:NSStringFromClass([UHHealthWindOneImageCell class])];
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
