//
//  UHRepeatListController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHRepeatListController.h"
#import "UHRepeatListCell.h"
#import "UHRepeatListModel.h"
@interface UHRepeatListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *strArray;
@end

@implementation UHRepeatListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = KControlColor;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    for (UHRepeatListModel *tempmodel in self.strArray) {
        tempmodel.isSel = NO;
        if ([self.str containsString:tempmodel.title]) {
            tempmodel.isSel = YES;
        }
    }
    [self.tableView reloadData];
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
    
    return self.strArray.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UHRepeatListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHRepeatListCell class])];
    UHRepeatListModel *model  = self.strArray[indexPath.row];
    cell.model = model;
    cell.selBlock = ^{
        for (UHRepeatListModel *tempmodel in self.strArray) {
            tempmodel.isSel = NO;
        }
        model.isSel = YES;
        [self.tableView reloadData];
        if (self.selectedBlock) {
            self.selectedBlock(model.title);
            [self.navigationController popViewControllerAnimated:YES];
        }
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UHRepeatListModel *model  = self.strArray[indexPath.row];
    for (UHRepeatListModel *tempmodel in self.strArray) {
        tempmodel.isSel = NO;
    }
    model.isSel = YES;
    [self.tableView reloadData];
    if (self.selectedBlock) {
        
        self.selectedBlock(model.title);
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource  =self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UHRepeatListCell class] forCellReuseIdentifier:NSStringFromClass([UHRepeatListCell class])];
    }
    return _tableView;
}

- (NSMutableArray *)strArray {
    if (!_strArray) {
        _strArray = [NSMutableArray array];
        for ( int i = 0; i<3; i++) {
            UHRepeatListModel *model = [[UHRepeatListModel alloc] init];
            model.title = @"永不";
            if (i==1) {
                model.title = @"每天";
            }else if (i==2) {
                model.title = @"每周";
            }
            [_strArray addObject:model];
        }
        
    }
    return _strArray;
}
@end
