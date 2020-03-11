//
//  UHDetectionController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/9.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHDetectionController.h"

@interface UHDetectionController ()
@property (nonatomic,strong) NSArray *textdata;
@property (nonatomic,strong) NSArray *imagedata;
@end

@implementation UHDetectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"检测筛选";
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
    
    return self.textdata.count;
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    cell.textLabel.text = self.textdata[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.imagedata[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.5f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSArray *)textdata {
    if (!_textdata) {
        _textdata = @[@"年度体检",@"基因筛查",@"癌症筛查"];
    }
    return _textdata;
}

- (NSArray *)imagedata {
    if (!_imagedata) {
        _imagedata = @[@"index_ndtj",@"index_jy",@"index_cancer"];
    }
    return _imagedata;
}

@end
