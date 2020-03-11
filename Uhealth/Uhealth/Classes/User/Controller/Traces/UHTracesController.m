//
//  UHTracesController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/8/21.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHTracesController.h"
#import "UHTracesModel.h"
#import "UHTracesTopCell.h"
#import "UHTracesHeaderCell.h"
@interface UHTracesController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) NSDictionary *dict;
@end

@implementation UHTracesController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
    [self setupAllRefresh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)initAll {
    self.title = @"物流信息";
    self.view.backgroundColor = KControlColor;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"trace_nodata_icon" titleStr:@"" detailStr:@""];
}

- (void)setupAllRefresh {
    WEAK_SELF(weakSelf);
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"traces" parameters:@{@"orderId":self.orderId} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                if ([response objectForKey:@"data"] && ![[response objectForKey:@"data"] isKindOfClass:[NSNull class]] ) {
                    NSArray *tracesData = [UHTracesModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"traces"]];
                    if (tracesData.count == 1) {
                         int i = 0;
                        for (UHTracesModel *model in tracesData) {
                            model.cellstyle = 2;
                            [weakSelf.data addObject:model];
                            i++;
                        }
                    } else {
                        int i = 0;
                        for (UHTracesModel *model in tracesData) {
                            if (i == 0) {
                                model.cellstyle = 1;
                            } else if (i == tracesData.count-1) {
                                model.cellstyle = 2;
                            }
                            [weakSelf.data addObject:model];
                            i++;
                        }
                    }
                    
                    weakSelf.dict = [response objectForKey:@"data"];
                    [tableView reloadData];
                }
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHTracesController class]];
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
    UHTracesTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHTracesTopCell class])];
    cell.model = self.data[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UHTracesModel *model = self.data[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[UHTracesTopCell class] contentViewWidth:SCREEN_WIDTH];
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90.f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *shipperNameLabel = [UILabel new];
    UILabel *logisticCodeLabel = [UILabel new];
     UIImageView *bottomIconView = [UIImageView new];
    [view sd_addSubviews:@[shipperNameLabel,logisticCodeLabel,bottomIconView]];
    shipperNameLabel.textColor = ZPMyOrderDetailFontColor;
    shipperNameLabel.font = [UIFont fontWithName:ZPPFSCRegular size:14];
    shipperNameLabel.sd_layout
    .topSpaceToView(view, 22)
    .leftSpaceToView(view, 16)
    .rightSpaceToView(view, 16)
    .heightIs(14);
    shipperNameLabel.text = @"配送方式:";
    
    logisticCodeLabel.textColor = ZPMyOrderDetailFontColor;
    logisticCodeLabel.font = [UIFont fontWithName:ZPPFSCRegular size:14];
    logisticCodeLabel.sd_layout
    .topSpaceToView(shipperNameLabel, 17)
    .leftSpaceToView(view, 16)
    .rightSpaceToView(view, 16)
    .heightIs(14);
    logisticCodeLabel.text = @"运单号:";
    
   
    bottomIconView.image = [UIImage imageNamed:@"prefer_locborder"];
    bottomIconView.sd_layout
    .topSpaceToView(logisticCodeLabel, 22)
    .heightIs(2)
    .leftSpaceToView(view, 0)
    .rightSpaceToView(view, 0);
    
    if (self.dict[@"shipperName"] && ![self.dict[@"shipperName"] isKindOfClass:[NSNull class]]) {
        shipperNameLabel.text = [NSString stringWithFormat:@"配送方式:%@",self.dict[@"shipperName"]];
    }
    if (self.dict[@"logisticCode"] && ![self.dict[@"logisticCode"] isKindOfClass:[NSNull class]]) {
        logisticCodeLabel.text = [NSString stringWithFormat:@"运单号:%@",self.dict[@"logisticCode"]];
    }
    
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

- (NSDictionary *)dict {
    if (!_dict) {
        _dict = [NSDictionary dictionary];
    }
    return _dict;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[UHTracesTopCell class] forCellReuseIdentifier:NSStringFromClass([UHTracesTopCell class])];
        [_tableView registerClass:[UHTracesHeaderCell class] forCellReuseIdentifier:NSStringFromClass([UHTracesHeaderCell class])];
        _tableView.tableFooterView = [UIView new];
        _tableView.allowsSelection = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
@end
