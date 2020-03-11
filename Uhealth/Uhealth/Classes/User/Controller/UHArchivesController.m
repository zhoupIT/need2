//
//  UHArchivesController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/15.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHArchivesController.h"
#import "UHMyFileMainController.h"
#import "UHReportController.h"
@interface UHArchivesController ()

@end

@implementation UHArchivesController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
}

- (void)setup {
    self.tableView.tableFooterView = [UIView new];
    self.title = @"我的档案";
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
    
    return 2;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"app";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.textColor = ZPMyOrderDetailFontColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text  = @"健康档案";
        cell.imageView.image = [UIImage imageNamed:@"myReport_file"];
    } else {
        cell.textLabel.text  = @"慢病报告";
         cell.imageView.image = [UIImage imageNamed:@"myReport_report"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 53;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UHMyFileMainController *fileMainControl = [[UHMyFileMainController alloc] init];
        [self.navigationController pushViewController:fileMainControl animated:YES];
    } else {
        UHReportController *reportControl = [[UHReportController alloc] init];
        [self.navigationController pushViewController:reportControl animated:YES];
    }
   
}

@end
