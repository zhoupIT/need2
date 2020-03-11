//
//  UHMyPlanController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/27.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyPlanController.h"
#import "UHMyPlanModel.h"
#import "UHMyPlanCell.h"
#import "UHPlanDetailController.h"
@interface UHMyPlanController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;
@end

@implementation UHMyPlanController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.title = @"我的计划";
    self.view.backgroundColor = KControlColor;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(5, 0, 0, 0));
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无计划"
                                                           detailStr:@""];
    [self setupRefresh];
    [self.tableView.mj_header beginRefreshing];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(add)];
}

- (void)add {
    __block UITextField *tf = nil;
    [LEEAlert alert].config
    .LeeTitle(@"创建新计划名称")
    .LeeAddTextField(^(UITextField *textField) {
        textField.placeholder = @"计划名称";
        textField.textColor = ZPMyOrderDetailFontColor;
        tf = textField; //赋值
    })
    .LeeAction(@"好的", ^{
        [tf resignFirstResponder];
        if (!tf.text.length) {
            [MBProgressHUD showError:@"请输入计划名称!"];
            return ;
        }
        [MBProgressHUD showMessage:@"创建中..."];
        NSDictionary *msg = @{@"title":tf.text};
        [[ZPNetWork sharedZPNetWork] requestWithUrl:@"api/my/plan/personal/plan/save" andHTTPMethod:@"PUT" andDict:msg success:^(NSDictionary *response) {
            [MBProgressHUD showSuccess:@"创建计划成功"];
            [self.tableView.mj_header beginRefreshing];
        } failed:^(NSError *error) {
            
        }];
    })
    .LeeCancelAction(@"取消", nil)
    .LeeShow();
}


- (void)setupRefresh {
    
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"plan/list" parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                self.data = [UHMyPlanModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                [tableView reloadData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHMyPlanController class]];
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
    UHMyPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHMyPlanCell class])];
    UHMyPlanModel *model = self.data[indexPath.section];
    cell.model = model;
    cell.changeRemindStatus = ^(BOOL isRemind) {
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"personal/plan" parameters:@{@"planId":model.planId,@"remindStatus":isRemind?@"ENABLED":@"DISABLED"} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                [MBProgressHUD showSuccess:@"开启提醒成功!"];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            
        } className:[UHMyPlanController class]];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UHPlanDetailController *detailControl = [[UHPlanDetailController alloc] init];
    detailControl.model =self.data[indexPath.section];
    [self.navigationController pushViewController:detailControl animated:YES];
}

#pragma mark - -tableView的代理方法
/**
 *  返回行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView cellHeightForIndexPath:indexPath model:self.data[indexPath.section] keyPath:@"model" cellClass:[UHMyPlanCell class] contentViewWidth:SCREEN_WIDTH];
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

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *retroactiveRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        UHMyPlanModel *model = self.data[indexPath.section];
        //删除
        NSMutableArray *idDeleteArray = [NSMutableArray array];
        [idDeleteArray addObject:model.planId];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/my/plan/personal/plan",ZPBaseUrl]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        request.HTTPMethod = @"DELETE";
        
        request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};//此处为请求头，类型为字典
        
//        NSDictionary *dict = @{@"planIds":idDeleteArray};
        NSData *data = [NSJSONSerialization dataWithJSONObject:idDeleteArray options:NSJSONWritingPrettyPrinted error:nil];
        
        request.HTTPBody = data;
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"%@ --------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil) {
                    NSDictionary *dict = [data mj_JSONObject];
                    if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                        [MBProgressHUD showSuccess:@"删除计划成功"];
                        [self.tableView.mj_header beginRefreshing];
                    } else {
                        [MBProgressHUD showError:[dict objectForKey:@"message"]];
                    }
                } else {
                    [MBProgressHUD showError:error.localizedDescription];
                }
            });
        }] resume];
    }];
    
    return @[retroactiveRoWAction];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        NSIndexSet *sections = [NSIndexSet indexSetWithIndex:indexPath.section];
        [tableView deleteSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else{
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = KControlColor;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UHMyPlanCell class] forCellReuseIdentifier:NSStringFromClass([UHMyPlanCell class])];
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
