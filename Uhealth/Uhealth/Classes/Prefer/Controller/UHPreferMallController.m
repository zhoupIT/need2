//
//  UHPreferMallController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/2.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHPreferMallController.h"
#import "UHPreferMallCell.h"
#import "UHMyShoppingCarController.h"

#import "UHOrderDetailController.h"

#import "UHCommodity.h"

#import "WZLBadgeImport.h"

#import "UHLoginController.h"

#import "UHNavigationController.h"
@interface UHPreferMallController ()
@property (nonatomic,strong) NSMutableArray *datas;
@end

@implementation UHPreferMallController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupRefresh];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无商品"
                                                           detailStr:@""];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        [self getCartDot];
    }
}

#pragma mark - 私有
- (void)myshoppingCar {
    ZPLog(@"我的购物车");
    UHMyShoppingCarController *myshoppingCarControl = [[UHMyShoppingCarController alloc] init];
    [self.navigationController pushViewController:myshoppingCarControl animated:YES];
}

- (void)getCartDot {
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"redDot" parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            NSString *shoppingCartStatus = [[response objectForKey:@"data"] objectForKey:@"shoppingCartStatus"];
            if ([shoppingCartStatus isEqualToString:@"yes"]) {
                [self.navigationItem.rightBarButtonItem showBadge];
                self.navigationItem.rightBarButtonItem.badgeCenterOffset = CGPointMake(-8, 8);
            } else {
                [self.navigationItem.rightBarButtonItem clearBadge];
            }
            
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    } className:[UHPreferMallController class]];
}

- (void)setupUI {
    UILabel *label = [UILabel new];
    label.text = @"微生态健康解决方案";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = label;
//    self.title = @"优选";
    
    self.tableView.backgroundColor = KControlColor;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UHPreferMallCell class] forCellReuseIdentifier:NSStringFromClass([UHPreferMallCell class])];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"prefer_shoppingcar"] style:UIBarButtonItemStyleDone target:self action:@selector(myshoppingCar)];
}

- (void)setupRefresh {
    
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getdata];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"store/commodity" parameters:@{@"offset":[NSNumber numberWithInteger:self.datas.count]} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [UHCommodity mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
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
        } className:[UHPreferMallController class]];
    }];
     
}

- (void)getdata {
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"store/commodity" parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            self.datas = [UHCommodity mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            [self.tableView reloadData];
            [self.tableView.mj_footer  resetNoMoreData];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:error.localizedDescription];
    } className:[UHPreferMallController class]];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Class currentClass = [UHPreferMallCell class];
    UHPreferMallCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    UHCommodity *model = self.datas[indexPath.section];
    cell.model = model;
    cell.cartBlock = ^(UIButton *btn){
        //添加到购物车
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/store/shopping/cart",ZPBaseUrl]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        request.HTTPMethod = @"PUT";
        
        request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};//此处为请求头，类型为字典
        NSDictionary *msg = @{@"commodityId":[NSNumber numberWithInteger:model.commodityId],@"commodityCount":@1};
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:msg options:NSJSONWritingPrettyPrinted error:nil];
        
        request.HTTPBody = data;
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
             NSLog(@"%@ --------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
            dispatch_async(dispatch_get_main_queue(), ^{
                btn.userInteractionEnabled = YES;
                if (error == nil) {                    
                    NSDictionary *dict = [data mj_JSONObject];
                    if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                        [MBProgressHUD showSuccess:@"成功添加到购物车"];
                        [self.navigationItem.rightBarButtonItem showBadge];
                        self.navigationItem.rightBarButtonItem.badgeCenterOffset = CGPointMake(-8, 8);
                    } else if ([[dict objectForKey:@"code"] integerValue]  == 401){
                            //未登录页面
                            [self logout];
                    } else if ([[dict objectForKey:@"code"] integerValue]  == 402){
                        //在别的地方登陆
//                        [MBProgressHUD showError:[dict objectForKey:@"message"]];
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            //在别的地方登陆
//                            [self logout];
//                        });
                        [self clearLoginInfo];
                        [LEEAlert alert].config
                        .LeeContent([dict objectForKey:@"message"])
                        .LeeAction(@"确认", ^{
                            UHLoginController *loginControl = [[UHLoginController alloc] init];
                            UHNavigationController *nav = [[UHNavigationController alloc] initWithRootViewController:loginControl];
                            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                        })
                        .LeeShow();
                    } else {
                        [MBProgressHUD showError:[dict objectForKey:@"message"]];
                    }
                } else {
                    [MBProgressHUD showError:error.localizedDescription];
                }
            });
            
           
            
        }] resume];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UHOrderDetailController *orderDetail = [[UHOrderDetailController alloc] init];
    orderDetail.commodity = self.datas[indexPath.section];
    [self.navigationController pushViewController:orderDetail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
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

//退出登录
- (void)logout {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        [[NSFileManager defaultManager] removeItemAtPath:ZPUserInfoPATH error:nil];
    }
    if ([[kUSER_DEFAULT objectForKey:@"_IDENTIY_KEY_"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"_IDENTIY_KEY_"];
        [kUSER_DEFAULT synchronize];
        NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookiesArray) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    if ([[kUSER_DEFAULT objectForKey:@"stepsUpdateTime"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"stepsUpdateTime"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"lectureToken"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"lectureToken"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"accId"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"accId"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"token"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"token"];
        [kUSER_DEFAULT synchronize];
    }
    [ZPNetWorkManager destroyInstance];
    UHLoginController *loginControl = [[UHLoginController alloc] init];
    UHNavigationController *nav = [[UHNavigationController alloc] initWithRootViewController:loginControl];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}

//清除登录信息
- (void)clearLoginInfo {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        [[NSFileManager defaultManager] removeItemAtPath:ZPUserInfoPATH error:nil];
    }
    if ([[kUSER_DEFAULT objectForKey:@"_IDENTIY_KEY_"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"_IDENTIY_KEY_"];
        [kUSER_DEFAULT synchronize];
        NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookiesArray) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    if ([[kUSER_DEFAULT objectForKey:@"stepsUpdateTime"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"stepsUpdateTime"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"lectureToken"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"lectureToken"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"accId"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"accId"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"token"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"token"];
        [kUSER_DEFAULT synchronize];
    }
    [ZPNetWorkManager destroyInstance];
    
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
@end
