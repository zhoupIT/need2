//
//  UHCompanyAddressController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHCompanyAddressController.h"
#import "HSSetTableViewController.h"
#import "UHCompanyAddressCell.h"
@interface UHCompanyAddressController ()

@end

@implementation UHCompanyAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = KControlColor;
    self.title = @"公司地址信息";
    //初始化tableView
    [self initSetTableViewConfigureStyle:UITableViewStyleGrouped];
    //所在地区
    HSTextCellModel *address = [[HSTextCellModel alloc] initWithTitle:@"所在地区" detailText:@"请选择" actionBlock:^(HSBaseCellModel *model) {
        
    }];
    address.titleColor = KCommonBlack;
    address.titleFont = [UIFont systemFontOfSize:15];
    
//    HSCustomCellModel *model = [[HSCustomCellModel alloc] initWithCellIdentifier:@"id" actionBlock:^(HSBaseCellModel *model) {
//
//    }];
    
//    UHCompanyAddressCell *sound = [[UHCompanyAddressCell alloc] initWithCellIdentifier:@"UHCompanyAddressCell" actionBlock:nil];
    
    NSMutableArray *section0 = [NSMutableArray arrayWithObjects:address, nil];
    [self.hs_dataArry addObject:section0];
}

@end
