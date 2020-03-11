//
//  UHGreenPathHospitalController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/10/16.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHGreenPathHospitalController.h"

#import "UHGreenPathHospitalCell.h"

#import "UHHospitalModel.h"
@interface UHGreenPathHospitalController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;
//选中的医院
@property (nonatomic,strong) UHHospitalModel *selectedHospitalModel;
@end

@implementation UHGreenPathHospitalController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self setupRefresh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)initUI {
    self.view.backgroundColor = KControlColor;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    self.title = @"选择医院";
}

- (void)setupRefresh {
    __unsafe_unretained UITableView *tableView = self.tableView;
    WEAK_SELF(weakSelf);
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"cityService/hospital" parameters:@{@"cityServiceId":self.cityServiceId} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                weakSelf.datas = [UHHospitalModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (weakSelf.hospitalModelSel) {
                    for (UHHospitalModel *model in weakSelf.datas) {
                        if ([model.ID isEqualToString:weakSelf.hospitalModelSel.ID]) {
                            model.isSel = YES;
                        }
                    }
                }
                [tableView reloadData];
                [tableView.mj_footer  resetNoMoreData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHGreenPathHospitalController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"cityService/hospital" parameters:@{@"offset":[NSNumber numberWithInteger:self.datas.count],@"cityServiceId":self.cityServiceId} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [tableView.mj_footer endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [UHHospitalModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (!arrays.count) {
                    
                    [tableView.mj_footer endRefreshingWithNoMoreData];
                    
                } else {
                    if (weakSelf.hospitalModelSel) {
                        for (UHHospitalModel *model in arrays) {
                            if ([model.ID isEqualToString:weakSelf.hospitalModelSel.ID]) {
                                model.isSel = YES;
                            }
                        }
                    }
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
        } className:[UHGreenPathHospitalController class]];
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
    
    return self.datas.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UHGreenPathHospitalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHGreenPathHospitalCell class])];
    WEAK_SELF(weakSelf);
    UHHospitalModel *model = self.datas[indexPath.row];
    cell.model = model;
    cell.selHospitalBlock = ^(BOOL sel) {
        for (UHHospitalModel *model in weakSelf.datas) {
            model.isSel = NO;
        }
        model.isSel = YES;
        [weakSelf.tableView reloadData];
        if (weakSelf.selHospitalBlock) {
            weakSelf.selHospitalBlock(model);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView cellHeightForIndexPath:indexPath model:self.datas[indexPath.row] keyPath:@"model" cellClass:[UHGreenPathHospitalCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UHGreenPathHospitalCell class] forCellReuseIdentifier:NSStringFromClass([UHGreenPathHospitalCell class])];
    }
    return _tableView;
}

@end
