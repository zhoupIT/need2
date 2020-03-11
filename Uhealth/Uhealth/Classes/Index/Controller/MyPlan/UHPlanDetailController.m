//
//  UHPlanDetailController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/27.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHPlanDetailController.h"
#import "UHMyPlanModel.h"
#import "UHPlanItemModel.h"
#import "UHPlanItemCell.h"
#import "UHLittleAimController.h"
@interface UHPlanDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *footBtn;
@end

@implementation UHPlanDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    self.titleLabel.text = [NSString stringWithFormat:@"计划名称:%@",self.model.title];
}

- (void)setup {
    self.title = @"计划详情";
    
    self.view.backgroundColor =KControlColor;
    
    
    [self.view addSubview:self.backView];
    self.backView.sd_layout
    .leftEqualToView(self.view)
    .heightIs(60)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view, 6);
    
    [self.backView addSubview:self.titleLabel];
    self.titleLabel.sd_layout
    .leftSpaceToView(self.backView, 17)
    .rightEqualToView(self.backView)
    .centerYEqualToView(self.backView)
    .heightIs(15);

    
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .topSpaceToView(self.backView, 14)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    [self setupRefresh];
    [self.tableView.mj_header beginRefreshing];
    
    
}

- (void)setupRefresh {
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"%@/api/my/plan/plan/item/list?planId=%@",ZPBaseUrl,self.model.planId] parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                self.data = [UHPlanItemModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                [tableView reloadData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHPlanDetailController class]];
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
    UHPlanItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHPlanItemCell class])];
    cell.model = self.data[indexPath.row];
    return cell;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 58;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:self.footBtn];
    self.footBtn.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(20, 54, 0, 54));
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UHLittleAimController *littleAimControl = [[UHLittleAimController alloc] init];
    littleAimControl.model = self.model;
    littleAimControl.itemModel = self.data[indexPath.row];
    littleAimControl.successBlock = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:littleAimControl animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UHPlanItemModel *model = self.data[indexPath.row];
    [MBProgressHUD showMessage:@"删除中..."];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/my/plan/plan/item",ZPBaseUrl]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"DELETE";
    
    request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};//此处为请求头，类型为字典
    
    NSMutableArray *IDDeleteArray = [NSMutableArray array];
    [IDDeleteArray addObject:model.itemId];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:IDDeleteArray options:NSJSONWritingPrettyPrinted error:nil];
    
    request.HTTPBody = data;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@ --------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            if (error == nil) {
                NSDictionary *dict = [data mj_JSONObject];
                if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                    [MBProgressHUD showSuccess:@"删除小目标成功"];
                    [tableView beginUpdates];
                    // 从数据源中删除
                    [_data removeObjectAtIndex:indexPath.row];
                    // 从列表中删除
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [tableView endUpdates];
                } else {
                    [MBProgressHUD showError:[dict objectForKey:@"message"]];
                }
            } else {
                [MBProgressHUD showError:error.localizedDescription];
            }
        });
        
        
        
    }] resume];
   
}

/*
 * 添加小目标
 */
- (void)addLittleAim {
    ZPLog(@"添加小目标");
    UHLittleAimController *littleAimControl = [[UHLittleAimController alloc] init];
    littleAimControl.model = self.model;
    littleAimControl.successBlock = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:littleAimControl animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = KControlColor;
        [_tableView registerClass:[UHPlanItemCell class] forCellReuseIdentifier:NSStringFromClass([UHPlanItemCell class])];
    }
    return _tableView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"计划名称:";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = ZPMyOrderDetailFontColor;
    }
    return _titleLabel;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIButton *)footBtn {
    if (!_footBtn) {
        _footBtn = [UIButton new];
        [_footBtn setTitle:@"+添加小目标" forState:UIControlStateNormal];
        _footBtn.layer.cornerRadius = 10;
        _footBtn.layer.borderColor = ZPMyOrderDetailValueFontColor.CGColor;
        _footBtn.layer.borderWidth = 1;
        _footBtn.layer.masksToBounds = YES;
        [_footBtn setBackgroundColor:[UIColor whiteColor]];
        [_footBtn setTitleColor:ZPMyOrderDetailValueFontColor forState:UIControlStateNormal];
        [_footBtn addTarget:self action:@selector(addLittleAim) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footBtn;
}
@end
