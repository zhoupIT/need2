//
//  UHPatientListController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/24.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHPatientListController.h"
#import "UHPatientListCell.h"

#import "UHAddPatientController.h"

#import "UHAddPatientController.h"
#import "UHMyPatientListCell.h"
@interface UHPatientListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) NSMutableArray *staffDatas;
@property (nonatomic,strong) NSMutableArray *familyDatas;

@property (nonatomic,strong) UIButton *comBtn;

@property (nonatomic,strong) UHPatientListModel *selModel;
@end

@implementation UHPatientListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.title = @"绿通就医人信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(add)];
    self.view.backgroundColor = KControlColor;
    [self.view addSubview:self.tableView];
    if (self.type != 1) {
        [self.view addSubview:self.comBtn];
        self.tableView.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(0, 0, 50, 0));
        
        self.comBtn.sd_layout
        .bottomEqualToView(self.view)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .heightIs(50);
    } else {
        self.tableView.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    }
    
    
    
    [self setupRefresh];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"还未有就医人,快去添加就医人吧"
                                                           detailStr:@""];
}

- (void)setupRefresh {
    
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"medicalPerson/list" parameters:nil progress:^(NSProgress *progress) {
                
            } success:^(NSURLSessionDataTask *task, id response) {
                [tableView.mj_header endRefreshing];
                if ([[response objectForKey:@"code"] integerValue]  == 200) {
                    [self.staffDatas removeAllObjects];
                    [self.familyDatas removeAllObjects];
                    self.data = [UHPatientListModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                    for (UHPatientListModel *model in self.data) {
                        if (model.relation.code == 1010) {
                            [self.staffDatas addObject:model];
                        } else if (model.relation.code == 1020) {
                            [self.familyDatas addObject:model];
                        }
                    }
                    [tableView reloadData];
                } else {
                    [MBProgressHUD showError:[response objectForKey:@"message"]];
                }
            } failed:^(NSURLSessionDataTask *task, NSError *error) {
                [tableView.mj_header endRefreshing];
                [MBProgressHUD showError:error.localizedDescription];
            } className:[UHPatientListController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
}

#pragma mark - -tableView的数据源方法
/**
 *  返回组数(默认为1组)
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 2;
}

/**
 *  返回每组的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        if (section == 0) {
            return self.staffDatas.count;
        }
        return self.familyDatas.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == 1) {
        UHMyPatientListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHMyPatientListCell class])];
        UHPatientListModel *model = indexPath.section == 0?self.staffDatas[indexPath.row]:self.familyDatas[indexPath.row];
        cell.model = model;
        cell.selctActionBlock = ^(UIButton *btn) {
            btn.selected = !btn.selected;
            
            for (UHPatientListModel *model in self.data) {
                model.isSel = NO;
            }
            if (btn.isSelected) {
                model.isSel = YES;
                self.selModel = model;
            } else {
                self.selModel = nil;
            }
            [self.tableView reloadData];
        };
        
        cell.editBlock = ^(UIButton *btn) {
            //编辑
            UHAddPatientController *editControl = [[UHAddPatientController alloc] init];
            editControl.model = model;
            editControl.updateSuceesBlock = ^{
                [self.tableView.mj_header beginRefreshing];
            };
            [self.navigationController pushViewController:editControl animated:YES];
        };
        return cell;
    }
    UHPatientListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHPatientListCell class])];
    UHPatientListModel *model = indexPath.section == 0?self.staffDatas[indexPath.row]:self.familyDatas[indexPath.row];
    cell.model = model;
    cell.selctActionBlock = ^(UIButton *btn) {
        btn.selected = !btn.selected;
        
        for (UHPatientListModel *model in self.data) {
            model.isSel = NO;
        }
        if (btn.isSelected) {
            model.isSel = YES;
            self.selModel = model;
        } else {
            self.selModel = nil;
        }
        [self.tableView reloadData];
    };
    
    cell.editBlock = ^(UIButton *btn) {
      //编辑
        UHAddPatientController *editControl = [[UHAddPatientController alloc] init];
        editControl.model = model;
        editControl.updateSuceesBlock = ^{
            [self.tableView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:editControl animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 1) {
        return [tableView cellHeightForIndexPath:indexPath model:indexPath.section == 0?self.staffDatas[indexPath.row]:self.familyDatas[indexPath.row] keyPath:@"model" cellClass:[UHMyPatientListCell class] contentViewWidth:SCREEN_WIDTH];
    }
   return [tableView cellHeightForIndexPath:indexPath model:indexPath.section == 0?self.staffDatas[indexPath.row]:self.familyDatas[indexPath.row] keyPath:@"model" cellClass:[UHPatientListCell class] contentViewWidth:SCREEN_WIDTH];
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.staffDatas.count == 0 && self.familyDatas.count == 0) {
        return 0.0f;
    } else if (self.staffDatas.count > 0 && self.familyDatas.count == 0) {
        if (section == 0) {
            return 49.f;
        }
        return 0.0f;
    }else if (self.staffDatas.count == 0 && self.familyDatas.count > 0) {
        if (section == 0) {
            return 0.0f;
        }
        return 49.f;
    }
    return 49.f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
     view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] init];
    [view addSubview:label];
    label.sd_layout
    .leftSpaceToView(view, 16)
    .rightEqualToView(view)
    .heightIs(49)
    .centerYEqualToView(view);
    label.backgroundColor = [UIColor clearColor];
    label.text = section == 0?@"个人":@"家人";
    label.textColor = ZPMyOrderDetailFontColor;
    label.font = [UIFont systemFontOfSize:14];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//
//    for (UHPatientListModel *model in self.data) {
//        model.isSel = NO;
//    }
//    UHPatientListModel *model = indexPath.section == 0?self.staffDatas[indexPath.row]:self.familyDatas[indexPath.row];
//    model.isSel = YES;
//    [self.tableView reloadData];
//    self.selModel = model;
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

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *retroactiveRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        UHPatientListModel *model = indexPath.section == 0?self.staffDatas[indexPath.row]:self.familyDatas[indexPath.row];
        //删除
        NSMutableArray *idDeleteArray = [NSMutableArray array];
        [idDeleteArray addObject:model.ID];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/green/channel/medicalPerson",ZPBaseUrl]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        request.HTTPMethod = @"DELETE";
        
        request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};//此处为请求头，类型为字典
        
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:idDeleteArray options:NSJSONWritingPrettyPrinted error:nil];
        
        request.HTTPBody = data;
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"%@ --------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil) {
                    NSDictionary *dict = [data mj_JSONObject];
                    if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                        [MBProgressHUD showSuccess:@"删除就医人成功"];
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
        NSIndexSet *sections = [NSIndexSet indexSetWithIndex:indexPath.row];
        [tableView deleteSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else{
    }
}

- (void)add {
    __weak typeof(self) weakSelf = self;
    UHAddPatientController *addPatientController = [[UHAddPatientController alloc] init];
    addPatientController.addSuceesBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:addPatientController animated:YES];
}

- (void)comAction {
    if (!self.selModel) {
        [MBProgressHUD showError:@"请先选择一个就医人"];
        return;
    }
    if (self.selectedPatientBlock) {
        self.selectedPatientBlock(self.selModel);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (NSMutableArray *)staffDatas {
    if (!_staffDatas) {
        _staffDatas = [NSMutableArray array];
    }
    return _staffDatas;
}

- (NSMutableArray *)familyDatas {
    if (!_familyDatas) {
        _familyDatas = [NSMutableArray array];
    }
    return _familyDatas;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = KControlColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UHPatientListCell class] forCellReuseIdentifier:NSStringFromClass([UHPatientListCell class])];
        [_tableView registerClass:[UHMyPatientListCell class] forCellReuseIdentifier:NSStringFromClass([UHMyPatientListCell class])];
    }
    return _tableView;
}


- (UIButton *)comBtn {
    if (!_comBtn) {
        _comBtn = [UIButton new];
        [_comBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_comBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _comBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_comBtn setBackgroundColor:ZPMyOrderDetailValueFontColor];
        [_comBtn addTarget:self action:@selector(comAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comBtn;
}
@end
