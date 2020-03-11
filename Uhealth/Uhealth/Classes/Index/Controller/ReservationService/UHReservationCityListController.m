//
//  UHReservationCityListController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHReservationCityListController.h"
#import "UHReservationCityModel.h"
#import "UHReservationCityListCell.h"
#import "UHCityServicesModel.h"
@interface UHReservationCityListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;
@end

@implementation UHReservationCityListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
}

- (void)setup {
    self.view.backgroundColor = KControlColor;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UHReservationCityListCell class] forCellReuseIdentifier:NSStringFromClass([UHReservationCityListCell class])];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(5, 0, 0, 0));
    [self setupRefresh];
    [self.tableView.mj_header beginRefreshing];
    
    if (self.type == ZPEnterTypeService) {
       self.title = @"预约服务";
        self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                                titleStr:@"暂无服务"
                                                               detailStr:@""];
    } else {
        self.title = @"预约城市";
        self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                                titleStr:@"暂无城市"
                                                               detailStr:@""];
    }
}

- (void)setupRefresh {
    
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.type == ZPEnterTypeCity) {
            [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"medicalCity/list" parameters:nil progress:^(NSProgress *progress) {
                
            } success:^(NSURLSessionDataTask *task, id response) {
                [tableView.mj_header endRefreshing];
                if ([[response objectForKey:@"code"] integerValue]  == 200) {
                    self.data = [UHReservationCityModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                    //如果存在已有city的模型
                    if (self.cityModelSel) {
                        for (UHReservationCityModel *model in self.data) {
                            if ([model.ID isEqualToString:self.cityModelSel.ID]) {
                                model.isSel = YES;
                            }
                        }
                    }
                    [tableView reloadData];
                } else {
                    [MBProgressHUD showError:[response objectForKey:@"message"]];
                }
            } failed:^(NSURLSessionDataTask *task, NSError *error) {
                [tableView.mj_header endRefreshing];
                [MBProgressHUD showError:error.localizedDescription];
            } className:[UHReservationCityListController class]];
        } else {
            [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"%@/api/green/channel/medicalCity/%@",ZPBaseUrl,self.ID] parameters:nil progress:^(NSProgress *progress) {
                
            } success:^(NSURLSessionDataTask *task, id response) {
                [tableView.mj_header endRefreshing];
                if ([[response objectForKey:@"code"] integerValue]  == 200) {
                    self.data = [UHCityServicesModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"cityServices"]];
                    //如果存在已有city的模型
                    if (self.serviceModelSel) {
                        for (UHCityServicesModel *model in self.data) {
                            if ([model.ID isEqualToString:self.serviceModelSel.ID]) {
                                model.isSel = YES;
                            }
                        }
                    }
                    [tableView reloadData];
                } else {
                    [MBProgressHUD showError:[response objectForKey:@"message"]];
                }
            } failed:^(NSURLSessionDataTask *task, NSError *error) {
                [tableView.mj_header endRefreshing];
                [MBProgressHUD showError:error.localizedDescription];
            } className:[UHReservationCityListController class]];
        }
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
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
    WEAK_SELF(weakSelf);
    UHReservationCityListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHReservationCityListCell class])];
    if (self.type == ZPEnterTypeCity) {
        UHReservationCityModel *model = self.data[indexPath.section];
        cell.model = model;
        cell.didClickBlock = ^(UIButton *btn) {
            for (UHReservationCityModel *model in weakSelf.data) {
                model.isSel = NO;
            }
            UHReservationCityModel *model =  weakSelf.data[indexPath.section];
            model.isSel = YES;
            weakSelf.cityModelSel = model;
            [tableView reloadData];
            
            if (weakSelf.selectedCityBlock) {
                weakSelf.selectedCityBlock(model);
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        };
    } else {
        UHCityServicesModel *model = self.data[indexPath.section];
        cell.servicesModel = model;
        cell.didClickBlock = ^(UIButton *btn) {
            for (UHCityServicesModel *model in weakSelf.data) {
                model.isSel = NO;
            }
            UHCityServicesModel *model =  weakSelf.data[indexPath.section];
            model.isSel = YES;
            weakSelf.serviceModelSel = model;
            [tableView reloadData];
            if (weakSelf.selectedServiceBlock) {
                weakSelf.selectedServiceBlock(model);
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        };
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.type == ZPEnterTypeCity) {
        for (UHReservationCityModel *model in self.data) {
            model.isSel = NO;
        }
        UHReservationCityModel *model =   self.data[indexPath.section];
        model.isSel = YES;
        [tableView reloadData];
        if (self.selectedCityBlock) {
            self.selectedCityBlock(model);
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        for (UHCityServicesModel *model in self.data) {
            model.isSel = NO;
        }
        UHCityServicesModel *model =   self.data[indexPath.section];
        model.isSel = YES;
        [tableView reloadData];
        if (self.selectedServiceBlock) {
            self.selectedServiceBlock(model);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

//section头部间距
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
