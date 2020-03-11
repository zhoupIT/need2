//
//  UHHealthNewsController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHHealthNewsController.h"
#import "UHHealthNewsMoreImagesCell.h"
#import "UHHealthNewsModel.h"
#import "UHHealthNewsOneImageCell.h"
@interface UHHealthNewsController ()
@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,copy) NSString *label;
@end

@implementation UHHealthNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}

- (void)setupTableView {
    [self.tableView registerClass:[UHHealthNewsMoreImagesCell class] forCellReuseIdentifier:NSStringFromClass([UHHealthNewsMoreImagesCell class])];
    [self.tableView registerClass:[UHHealthNewsOneImageCell class] forCellReuseIdentifier:NSStringFromClass([UHHealthNewsOneImageCell class])];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无资讯"
                                                           detailStr:@""];
    [self setupRefresh];
//    [self.tableView.mj_header beginRefreshing];
}

- (void)setPageIndex:(NSInteger)pageIndex {
    _pageIndex = pageIndex;
    self.label = @"";
    switch (pageIndex) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            self.label = @"CARE";
        }
            break;
        case 2:
        {
            self.label = @"CHILD";
        }
            break;
        case 3:
        {
            self.label = @"PREGNANT_WOMAN";
        }
            break;
        case 4:
        {
            self.label = @"ELDER";
        }
            break;
        case 5:
        {
            self.label = @"FEMALE";
        }
            break;
        
        default:
            break;
    }
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupRefresh {
    
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"healthInformation/list" parameters:@{@"label":self.label} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                self.datas = [UHHealthNewsModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                [tableView reloadData];
                [tableView.mj_footer  resetNoMoreData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHHealthNewsController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"healthInformation/list" parameters:@{@"offset":[NSNumber numberWithInteger:self.datas.count],@"label":self.label} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [UHHealthNewsModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (!arrays.count) {
                    
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.datas addObjectsFromArray:arrays];
                    [self.tableView reloadData];
                    
                }
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHHealthNewsController class]];
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

     UHHealthNewsModel *model = self.datas.count>0?self.datas[indexPath.row]:nil;
        
        if (model.titleImgList.count == 1) {
            UHHealthNewsOneImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHHealthNewsOneImageCell class])];
            cell.model = model;
            return cell;
        }
        UHHealthNewsMoreImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHHealthNewsMoreImagesCell class])];
        cell.model = model;
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UHHealthNewsModel *model = self.datas[indexPath.row];
    if (model.titleImgList.count == 1) {
         return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[UHHealthNewsOneImageCell class] contentViewWidth:SCREEN_WIDTH];
    }
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[UHHealthNewsMoreImagesCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UHHealthNewsModel *model = self.datas[indexPath.row];
    if (self.didClickBlock) {
        if ([ZPBaseUrl isEqualToString:@"http://192.168.8.20"]) {
            self.didClickBlock([NSString stringWithFormat:@"%@/h5/app/#/healthyCounseling/detailIos?id=%@",ZPBaseUrl,model.informationId],model);
        } else {
            self.didClickBlock([NSString stringWithFormat:@"%@/#/healthyCounseling/detailIos?id=%@",ZPBaseUrl,model.informationId],model);
        }
        
    }
}

#pragma mark - VTMagicReuseProtocol
- (void)vtm_prepareForReuse {
    // reset content offset
    NSLog(@"clear old data if needed:%@", self);
    [self.datas removeAllObjects];
    
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
@end
