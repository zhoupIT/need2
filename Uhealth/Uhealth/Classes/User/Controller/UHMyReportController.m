//
//  UHMyReportController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyReportController.h"
#import "UHMyReportModel.h"
#import "UHMyReportCell.h"
@interface UHMyReportController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;
@end

@implementation UHMyReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
//    [self setupRefresh];
     self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无数据"
                                                           detailStr:@""];
//    [self.tableView.mj_header beginRefreshing];
    
}

- (void)initAll {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}

- (void)setPageIndex:(NSInteger)pageIndex {
    _pageIndex = pageIndex;
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupRefresh {
    __unsafe_unretained UITableView *tableView = self.tableView;
    NSString *evaluatingType = @"";
    /*
     （GLU血糖，BODY_FAT_RATE身体指数，BMI体重，BLOOD_URIC_ACID血尿酸，BF血脂，BLOOD_OXYGEN血氧，NIBP血压）
     */
    switch (self.index) {
        case 0:
            evaluatingType = @"NIBP";
            break;
        case 1:
            evaluatingType = @"BLOOD_URIC_ACID";
            break;
        case 2:
            evaluatingType = @"BLOOD_OXYGEN";
            break;
        case 3:
            evaluatingType = @"GLU";
            break;
        case 4:
            evaluatingType = @"BODY_FAT_RATE";
            break;
        case 5:
            evaluatingType = @"BMI";
            break;
        case 6:
            evaluatingType = @"BF";
            break;
        default:
            break;
    }
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"message/list" parameters:@{@"datagramType":self.pageIndex==0?@"ON_TIME":@"WEEK_MONTH_REPORT",@"evaluatingType":evaluatingType} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [self.tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                self.data = [UHMyReportModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                [self.data addObjectsFromArray:[UHMyReportModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]]];
                [self.tableView reloadData];
                [self.tableView.mj_footer resetNoMoreData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHMyReportController class]];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"message/list" parameters:@{@"offset":[NSNumber numberWithInteger:self.data.count],@"datagramType":self.pageIndex==0?@"ON_TIME":@"WEEK_MONTH_REPORT",@"evaluatingType":evaluatingType} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [UHMyReportModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
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
        } className:[UHMyReportController class]];
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
    UHMyReportCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHMyReportCell class])];
    cell.pageIndex = self.pageIndex;
    cell.model = self.data[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView cellHeightForIndexPath:indexPath model:self.data[indexPath.row] keyPath:@"model" cellClass:[UHMyReportCell class] contentViewWidth:SCREEN_WIDTH];
}

#pragma mark - VTMagicReuseProtocol
- (void)vtm_prepareForReuse {
    // reset content offset
    NSLog(@"clear old data if needed:%@", self);
    [self.data removeAllObjects];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UHMyReportCell class] forCellReuseIdentifier:NSStringFromClass([UHMyReportCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
