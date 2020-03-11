//
//  UHAuthorityDoctorController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/8/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHAuthorityDoctorController.h"
#import "UHAuthorityDoctorTitleCell.h"
#import "UHAuthorityDoctorSubCell.h"
#import "UHChannelDoctorModel.h"
#import "UHOrderDetailController.h"
#import "UHCommodity.h"
#import "UHDoctorCommodityModel.h"
#import "UHLivingBroadcastController.h"
#import "UHMoreLecturesController.h"
@interface UHAuthorityDoctorController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
//商品id
@property (nonatomic,copy) NSString *orderId;
@end

@implementation UHAuthorityDoctorController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

- (void)initAll {
    self.title = [NSString stringWithFormat:@"%@医生",self.doctorModel.doctorName];
    self.view.backgroundColor = KControlColor;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    /*
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"doctor/commodity" parameters:@{@"doctorId":self.doctorModel.ID} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            NSArray *datas = [UHDoctorCommodityModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            UHDoctorCommodityModel *model = datas.firstObject;
            self.orderId = model.commodityId;
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    } className:[UHAuthorityDoctorController class]];
     */
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
    
    return 1;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UHAuthorityDoctorTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHAuthorityDoctorTitleCell class])];
        UHChannelDoctorModel *model = self.doctorModel;
        cell.model = model;
        cell.imgClickBlock = ^(UIButton *btn) {
            switch (btn.tag) {
                case 10000:
                    {
                        if (model.lectureCount > 0) {
                            //有讲座的话
                            UHLivingBroadcastController *livingBroadcastConrol = [[UHLivingBroadcastController alloc] init];
                            livingBroadcastConrol.doctorId = self.doctorModel.ID;
                            [self.navigationController pushViewController:livingBroadcastConrol animated:YES];
                        } else {
                            //没有讲座
//                            UHMoreLecturesController *moreLectureConrol = [[UHMoreLecturesController alloc] init];
//                            moreLectureConrol.allLecture = YES;
//                            [self.navigationController pushViewController:moreLectureConrol animated:YES];
                            [LEEAlert alert].config
                            .LeeContent(@"该医生暂无直播哦，\n快去看看其他医生的直播吧")
                            .LeeAction(@"我知道了", ^{
                                
                            })
                            .LeeShow();
                        }
                        
                    }
                    break;
                    /*
                case 10001:
                    {
                        if (self.orderId && [NSString stringWithFormat:@"%@",self.orderId].length) {
                            ZPLog(@"跳转商品ID:%@",self.orderId);
                            UHOrderDetailController *orderDetailControl = [[UHOrderDetailController alloc] init];
                            UHCommodity *commodity = [[UHCommodity alloc] init];
                            commodity.commodityId = [self.orderId integerValue];
                            orderDetailControl.commodity = commodity;
                            orderDetailControl.enterStatusType = ZPOrderEnterStatusTypeBanner;
                            [self.navigationController pushViewController:orderDetailControl animated:YES];
                        } else {
                            [LEEAlert alert].config
                            .LeeTitle(@"提醒")
                            .LeeContent(@"暂无商品")
                            .LeeAction(@"确认", ^{
                            })
                            .LeeClickBackgroundClose(YES)
                            .LeeShow();
                        }
                        
                    }
                    break;
                    */
                    
                default:
                    {
                        [LEEAlert alert].config
                        .LeeTitle(@"提醒")
                        .LeeContent(@"暂不开放")
                        .LeeAction(@"确认", ^{
                        })
                        .LeeClickBackgroundClose(YES)
                        .LeeShow();
                    }
                    break;
            }
        };
        return cell;
    }
    UHAuthorityDoctorSubCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHAuthorityDoctorSubCell class])];
    UHChannelDoctorModel *model = self.doctorModel;
    model.index = indexPath.section;
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
         return [tableView cellHeightForIndexPath:indexPath model:self.doctorModel keyPath:@"model" cellClass:[UHAuthorityDoctorTitleCell class] contentViewWidth:SCREEN_WIDTH];
    }
    return [tableView cellHeightForIndexPath:indexPath model:self.doctorModel keyPath:@"model" cellClass:[UHAuthorityDoctorSubCell class] contentViewWidth:SCREEN_WIDTH];
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
    return 8.f;
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UHAuthorityDoctorTitleCell class] forCellReuseIdentifier:NSStringFromClass([UHAuthorityDoctorTitleCell class])];
        [_tableView registerClass:[UHAuthorityDoctorSubCell class] forCellReuseIdentifier:NSStringFromClass([UHAuthorityDoctorSubCell class])];
        _tableView.allowsSelection = NO;
    }
    return _tableView;
}

@end
