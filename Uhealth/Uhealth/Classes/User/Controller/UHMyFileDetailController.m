//
//  UHMyFileDetailController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/26.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyFileDetailController.h"
#import "UHMyFileInfoCell.h"
#import "UHMyFileCommonCell.h"
#import "UHMyFileDetailModel.h"
#import "UHMyFileTitleCell.h"
@interface UHMyFileDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *data;
@end

@implementation UHMyFileDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
    [self getData];
}

- (void)getData {
    [MBProgressHUD showMessage:@"加载中"];
   
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"%@/api/chronic/my/archives/%@",ZPBaseUrl,self.ID] parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        [MBProgressHUD hideHUD];
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            weakSelf.data = [UHMyFileDetailModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:error.localizedDescription];
    } className:[UHMyFileDetailController class]];
}

- (void)initAll {
    self.title  = @"检测详情";
    self.view.backgroundColor = KControlColor;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 8, 0, 8));
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
    UHMyFileDetailModel *model = self.data[indexPath.row];
    if ([model.type.name isEqualToString:@"INFORMATION"]) {
        UHMyFileInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHMyFileInfoCell class])];
        cell.model = model;
        return cell;
    } else if ([model.type.name isEqualToString:@"FORM"]) {
        UHMyFileCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHMyFileCommonCell class])];
        cell.model = model;
//        if(indexPath.row == (self.data.count-1)) {
//            cell.isLastData = YES;
//        } else {
//            cell.isLastData = NO;
//        }
        return cell;
    }
    UHMyFileTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHMyFileTitleCell class])];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UHMyFileDetailModel *model = self.data[indexPath.row];
    if ([model.type.name isEqualToString:@"INFORMATION"]) {
         return 165;
    } else if ([model.type.name isEqualToString:@"FORM_WITH_TITLE"]){
        return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[UHMyFileTitleCell class] contentViewWidth:SCREEN_WIDTH];
    }
//    if ([model.modelName isEqualToString:@"用药情况"]) {
//        CGFloat f = [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[UHMyFileCommonCell class] contentViewWidth:SCREEN_WIDTH];
//        return f<115?115:f;
//    }
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[UHMyFileCommonCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;//section头部高度
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
    return 10.f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[UHMyFileInfoCell class] forCellReuseIdentifier:NSStringFromClass([UHMyFileInfoCell class])];
        [_tableView registerClass:[UHMyFileCommonCell class] forCellReuseIdentifier:NSStringFromClass([UHMyFileCommonCell class])];
        [_tableView registerClass:[UHMyFileTitleCell class] forCellReuseIdentifier:NSStringFromClass([UHMyFileTitleCell class])];
    }
    return _tableView;
}

- (NSArray *)data {
    if (!_data) {
        _data = [NSArray array];
    }
    return _data;
}
@end
