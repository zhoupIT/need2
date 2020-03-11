//
//  UHMyFileController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/26.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyFileController.h"

#import "UHMyFileCell.h"
#import "UHMyFileModel.h"
@interface UHMyFileController ()
@property (nonatomic,strong) NSMutableArray *datas;
@end

@implementation UHMyFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = KControlColor;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UHMyFileCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UHMyFileCell class])];
    self.tableView.rowHeight = 131;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无数据"
                                                           detailStr:@""];
    [self setupRefresh];
   
}

- (void)setupRefresh {
    __weak typeof(self) weakSelf = self;
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"my/archives" parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
              self.datas = [UHMyFileModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                [tableView reloadData];
                [tableView.mj_footer resetNoMoreData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHMyFileController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"my/archives" parameters:@{@"offset":[NSNumber numberWithInteger:self.datas.count]} progress:^(NSProgress *progress) {

        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [tableView.mj_footer endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [UHMyFileModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (!arrays.count) {
                    [tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [weakSelf.datas addObjectsFromArray:arrays];
                    [tableView reloadData];

                }
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }

        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHMyFileController class]];
    }];
    
}

- (void)setPageIndex:(NSInteger)pageIndex {
    _pageIndex = pageIndex;
    if (pageIndex == 0) {
        [self.tableView.mj_header beginRefreshing];
    }
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UHMyFileCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHMyFileCell class]) forIndexPath:indexPath];
    UHMyFileModel *model = self.datas[indexPath.section];;
    cell.model = model;
    cell.clickBlock = ^{
        if (self.detailClickBlock) {
            self.detailClickBlock(model.ID);
        }
    };
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;//section头部高度
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
    return 0.01f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
@end
