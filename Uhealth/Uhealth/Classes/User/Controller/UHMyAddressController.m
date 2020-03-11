//
//  UHMyAddressController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyAddressController.h"
#import "UHMyAddressCell.h"
#import "UHAddAddressController.h"

#import "UHAddressModel.h"

static NSString *cellId = @"UHMyAddressCell";
@interface UHMyAddressController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;
@end

@implementation UHMyAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupRefresh];
    self.title = @"收货地址";
    [self.tableView.mj_header beginRefreshing];
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无收货地址"
                                                           detailStr:@""];
}

- (void)setupRefresh {
    
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"receiveAddress/list" parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
             [self.tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                self.data = [UHAddressModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                [self.tableView reloadData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHMyAddressController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
//    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"receiveAddress/list" parameters:@{@"offset":[NSNumber numberWithInteger:self.data.count]} progress:^(NSProgress *progress) {
//
//        } success:^(NSURLSessionDataTask *task, id response) {
//            // 结束刷新
//            [self.tableView.mj_footer endRefreshing];
//            if ([[response objectForKey:@"code"] integerValue]  == 200) {
//                NSArray *arrays = [UHAddressModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
//                if (!arrays.count) {
//                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                } else {
//                    [self.data addObjectsFromArray:arrays];
//                    [self.tableView reloadData];
//                }
//            } else {
//
//                [MBProgressHUD showError:[response objectForKey:@"message"]];
//            }
//
//        } failed:^(NSURLSessionDataTask *task, NSError *error) {
//
//            // 结束刷新
//            [self.tableView.mj_footer endRefreshing];
//            [MBProgressHUD showError:error.localizedDescription];
//        } className:[UHMyAddressController class]];
//    }];
    
}

- (void)setupUI {
    self.view.backgroundColor = KControlColor;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = KControlColor;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(9, 0, 0, 0));
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(add)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 120;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UHMyAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    UHAddressModel *model = self.data[indexPath.section];
    cell.model = model;
    cell.deleteAction = ^{
    
        NSMutableArray *deleteArray = [NSMutableArray array];
      
        [deleteArray addObject:model.ID];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/common/receiveAddress",ZPBaseUrl]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        request.HTTPMethod = @"DELETE";
        
        request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};//此处为请求头，类型为字典
        
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:deleteArray options:NSJSONWritingPrettyPrinted error:nil];
        
        request.HTTPBody = data;
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"%@ --------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil) {
                    NSDictionary *dict = [data mj_JSONObject];
                    if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                        [MBProgressHUD showSuccess:@"删除地址成功"];
                        [self.tableView.mj_header beginRefreshing];
                    } else {
                        [MBProgressHUD showError:[dict objectForKey:@"message"]];
                    }
                } else {
                    [MBProgressHUD showError:error.localizedDescription];
                }
            });
        }] resume];
    };
    
    cell.editAction = ^{
        UHAddAddressController *editFamControl = [[UHAddAddressController alloc] init];
        editFamControl.model = model;
        editFamControl.enterType = ZPEnterTypeEdit;
        editFamControl.addAddressBlock = ^{
            [self.tableView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:editFamControl animated:YES];
    };
    cell.selectAction = ^{
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"receiveAddress/default" parameters:@{@"id":model.ID} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                [MBProgressHUD showSuccess:@"设置成功"];
                for (UHAddressModel *model in self.data) {
                    model.addressStatus.name = @"NO_DEFAULT";
                }
                model.addressStatus.name = @"DEFAULT";
                 [self.tableView reloadData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
           
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
             [MBProgressHUD showError:error.localizedDescription];
        } className:[UHMyAddressController class]];
    };
    
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectLocBlock) {
        self.selectLocBlock(self.data[indexPath.section]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - private
- (void)add {
    UHAddAddressController *addFamControl = [[UHAddAddressController alloc] init];
    addFamControl.enterType = ZPEnterTypeAdd;
    addFamControl.addAddressBlock = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:addFamControl animated:YES];
}


- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}
@end
