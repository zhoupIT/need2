//
//  UHEmergencyRescueController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/9.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHEmergencyRescueController.h"
#import "UHEmergencyRescueCell.h"
#import "UHEmergencyRescueModel.h"
@interface UHEmergencyRescueController ()
@property (nonatomic,strong) NSMutableArray *data;
@end

@implementation UHEmergencyRescueController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    for (int i = 0; i<2;i++ ) {
        UHEmergencyRescueModel *model = [[UHEmergencyRescueModel alloc] init];
        model.title = i==0?@"国内紧急救援":@"国际紧急救援";
        model.price = i==0?@"¥100-¥299":@"¥300-¥699";
        model.imageName = i==0?@"pic1":@"pic1";
        model.content = i==0?@"救援服务范围：道路救援 道路救援 道路救援":@"救援服务范围：国际道路救援 道路救援 道路救援";
        [self.data addObject:model];
    }
    
}

- (void)setup {
    self.title = @"紧急救援";
    [self.tableView registerClass:[UHEmergencyRescueCell class] forCellReuseIdentifier:NSStringFromClass([UHEmergencyRescueCell class])];
    self.tableView.tableFooterView = [UIView new];
    
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
    UHEmergencyRescueCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHEmergencyRescueCell class])];
    cell.model = self.data[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 114;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}
@end
