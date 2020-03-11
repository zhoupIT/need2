//
//  UHGreenPathReservationSerController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/10/15.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHGreenPathReservationSerController.h"

#import "UHGreenPathReservationSerTitleCell.h"
#import "UHGreenPathReservationSerCell.h"

#import "UHMedicalCityServiceModel.h"
@interface UHGreenPathReservationSerController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;
////选择的服务
//@property (nonatomic,strong) UHMedicalCityServiceModel *selServiceModel;
//确定按钮
@property (nonatomic,strong) UIButton *comfirmBtn;
@end

@implementation UHGreenPathReservationSerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
    [self initData];
    [self.tableView.mj_header beginRefreshing];
}

- (void)initAll {
    self.title = @"预约服务";
    self.view.backgroundColor = KControlColor;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, ZPHeight(50), 0));
    [self.view addSubview:self.comfirmBtn];
    self.comfirmBtn.sd_layout
    .bottomSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(ZPHeight(50));
}

- (void)initData {
    __unsafe_unretained UITableView *tableView = self.tableView;
    WEAK_SELF(weakSelf);
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"%@/api/green/channel/medicalCity/%@",ZPBaseUrl,self.cityID] parameters:nil progress:^(NSProgress *progress) {
                
            } success:^(NSURLSessionDataTask *task, id response) {
                [tableView.mj_header endRefreshing];
                if ([[response objectForKey:@"code"] integerValue]  == 200) {
                    weakSelf.data = [UHMedicalCityServiceModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"cityServices"]];
                    //如果存在已有city的模型
                    if (self.serviceModelSel) {
                        for (UHMedicalCityServiceModel *model in weakSelf.data) {
                            if ([model.ID isEqualToString:weakSelf.serviceModelSel.ID]) {
                                model.isSel = YES;
                                weakSelf.serviceModelSel = model;
                            }
                        }
                    }
                    [tableView reloadData];
                } else {
                    [MBProgressHUD showError:[response objectForKey:@"message"]];
                }
            } failed:^(NSURLSessionDataTask *task, NSError *error) {
                [tableView.mj_header endRefreshing];
                [MBProgressHUD showError:error.localizedDescription];
            } className:[UHGreenPathReservationSerController class]];
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
    
    return 1+self.data.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UHGreenPathReservationSerTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHGreenPathReservationSerTitleCell class])];
        return cell;
    }
    WEAK_SELF(weakSelf);
    UHGreenPathReservationSerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHGreenPathReservationSerCell class])];
    UHMedicalCityServiceModel *model = self.data[indexPath.row-1];
    cell.model = model;
    cell.selServiceBlock = ^(BOOL isSel) {
        weakSelf.comfirmBtn.selected = NO;
        weakSelf.comfirmBtn.userInteractionEnabled = NO;
        for (UHMedicalCityServiceModel *tempmodel in weakSelf.data) {
            tempmodel.isSel = NO;
            if (isSel) {
                if ([tempmodel.ID isEqualToString:model.ID]) {
                    tempmodel.isSel = YES;
                    weakSelf.serviceModelSel = model;
                    weakSelf.comfirmBtn.selected = YES;
                    weakSelf.comfirmBtn.userInteractionEnabled = YES;
                }
            }
        }
        [weakSelf.tableView reloadData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
         return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:tableView];
    }
    UHMedicalCityServiceModel *model = self.data[indexPath.row-1];
     return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[UHGreenPathReservationSerCell class] contentViewWidth:SCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row != 0) {
        UHMedicalCityServiceModel *model = self.data[indexPath.row-1];
        if (model.serviceTypeInformationImg != nil && ![model.serviceTypeInformationImg isKindOfClass:[NSNull class]]) {
            model.isExpand = !model.isExpand;
            [tableView reloadData];
        }
    }
}

//确定事件
- (void)comfirmServiceAction {
    if (self.selectedServiceBlock) {
        self.selectedServiceBlock(self.serviceModelSel);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UHGreenPathReservationSerTitleCell class] forCellReuseIdentifier:NSStringFromClass([UHGreenPathReservationSerTitleCell class])];
        [_tableView registerClass:[UHGreenPathReservationSerCell class] forCellReuseIdentifier:NSStringFromClass([UHGreenPathReservationSerCell class])];
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (UIButton *)comfirmBtn {
    if (!_comfirmBtn) {
        _comfirmBtn = [UIButton new];
        [_comfirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_comfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _comfirmBtn.titleLabel.font = [UIFont fontWithName:ZPPFSCMedium size:ZPFontSize(18)];
        _comfirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_comfirmBtn setBackgroundImage:[UIImage imageWithColor:RGB(204,204,204)] forState:UIControlStateNormal];
        [_comfirmBtn setBackgroundImage:[UIImage imageWithColor:ZPMyOrderDetailValueFontColor] forState:UIControlStateSelected];
        _comfirmBtn.userInteractionEnabled = NO;
        _comfirmBtn.selected = NO;
        [_comfirmBtn addTarget:self action:@selector(comfirmServiceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comfirmBtn;
}
@end
