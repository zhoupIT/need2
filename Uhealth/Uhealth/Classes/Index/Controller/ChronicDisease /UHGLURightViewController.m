//
//  UHGLURightViewController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHGLURightViewController.h"

@interface UHGLURightViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArray;
@end

@implementation UHGLURightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

- (void)initAll {
    self.view.backgroundColor =  RGB(99, 187, 255);
    [self.view addSubview:self.tableView];
    
    self.tableView.frame = CGRectMake(0, IS_IPhoneX?44:20, SCREEN_WIDTH * 0.75, SCREEN_HEIGHT);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGRect rect = self.view.frame;
    switch (_drawerType) {
        case DrawerDefaultLeft:
            [self.view.superview sendSubviewToBack:self.view];
            break;
        case DrawerTypeMaskLeft:
            rect.size.width = SCREEN_WIDTH * 0.75;
            break;
        default:
            break;
    }
    
    self.view.frame = rect;
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
    
    return self.titleArray.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"app";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = RGB(99, 187, 255);
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.clickTypeBlock) {
        self.clickTypeBlock(self.titleArray[indexPath.row]);
         [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = @[@"空腹",@"早餐后",@"午餐前",@"午餐后",@"晚餐前",@"晚餐后",@"睡前",@"夜间"];
    }
    return _titleArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB(99, 187, 255);
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
@end
