//
//  UHMyServiceDetailController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/30.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyServiceDetailController.h"
#import "HSSetTableViewController.h"
#import "UHServiceDetailView.h"
#import "UHMyServiceModel.h"

@interface UHMyServiceDetailController ()
@property (nonatomic,strong) UHServiceDetailView *footView;
@end

@implementation UHMyServiceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = KControlColor;
    self.title = @"服务详情";
    
    //初始化tableView
    [self initSetTableViewConfigureStyle:UITableViewStyleGrouped];
    
    
    NSMutableArray *footerModels = [NSMutableArray array];
    
    self.footView = [UHServiceDetailView addServiceDetailView];
    self.footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 97);
    self.footView.backgroundColor = KControlColor;
    self.footView.model = self.model;
    
    HSFooterModel *footerModel = [HSFooterModel new];
    footerModel.footerView = self.footView ;
    footerModel.footerViewHeight = 97.0f;
    
    HSFooterModel *footerModel0 = [HSFooterModel new];
    footerModel0.footerView = [UIView new];
    footerModel0.footerViewHeight = 0.0f;
    [footerModels addObject:footerModel0];
    [footerModels addObject:footerModel];

    [self setTableViewFooterArry:footerModels];
    
    HSTextCellModel *service = [[HSTextCellModel alloc] initWithTitle:@"绿通服务" detailText:self.model.greenChannelServiceStatus.text actionBlock:^(HSBaseCellModel *model) {
       
    }];
    service.titleColor = KCommonBlack;
    service.titleFont = [UIFont systemFontOfSize:15];
    service.showArrow = NO;
    service.detailColor = ZPMyOrderDetailValueFontColor;
    
    
    
    HSTextCellModel *orderNum = [[HSTextCellModel alloc] initWithTitle:@"订单号：" detailText:self.model.serialNumber actionBlock:^(HSBaseCellModel *model) {
        
    }];
    orderNum.titleColor = KCommonBlack;
    orderNum.titleFont = [UIFont systemFontOfSize:15];
    orderNum.showArrow = NO;
    orderNum.showLine = NO;
    
    HSTextCellModel *orderTime = [[HSTextCellModel alloc] initWithTitle:@"下单时间：" detailText:self.model.payTime actionBlock:^(HSBaseCellModel *model) {
       
    }];
    orderTime.titleColor = KCommonBlack;
    orderTime.titleFont = [UIFont systemFontOfSize:15];
    orderTime.showArrow = NO;
    
    HSTextCellModel *city = [[HSTextCellModel alloc] initWithTitle:@"就医城市：" detailText:self.model.medicalCity actionBlock:^(HSBaseCellModel *model) {
        
    }];
    city.titleColor = KCommonBlack;
    city.titleFont = [UIFont systemFontOfSize:15];
    city.showArrow = NO;
    city.showLine = NO;
    
    HSTextCellModel *type = [[HSTextCellModel alloc] initWithTitle:@"预约服务类型：" detailText:self.model.medicalService actionBlock:^(HSBaseCellModel *model) {
        
    }];
    type.titleColor = KCommonBlack;
    type.titleFont = [UIFont systemFontOfSize:15];
    type.showArrow = NO;
    type.showLine = NO;
    
    HSTextCellModel *phone = [[HSTextCellModel alloc] initWithTitle:@"联系手机：" detailText:self.model.linkPhone actionBlock:^(HSBaseCellModel *model) {
        
    }];
    phone.titleColor = KCommonBlack;
    phone.titleFont = [UIFont systemFontOfSize:15];
    phone.showArrow = NO;
    
    HSTextCellModel *name= [[HSTextCellModel alloc] initWithTitle:self.model.patientName detailText:self.model.patientTelephone actionBlock:^(HSBaseCellModel *model) {
        
    }];
    name.titleColor = KCommonBlack;
    name.titleFont = [UIFont systemFontOfSize:15];
    name.showArrow = NO;
    name.showLine = NO;
    
    HSTextCellModel *card= [[HSTextCellModel alloc] initWithTitle:self.model.idCardType detailText:self.model.idCardNo actionBlock:^(HSBaseCellModel *model) {
        
    }];
    card.titleColor = KCommonBlack;
    card.titleFont = [UIFont systemFontOfSize:15];
    card.showArrow = NO;

    
    
    NSMutableArray *section0 = [NSMutableArray arrayWithObjects:service, orderNum,orderTime,city,type,phone,name,card,nil];
    
    HSTextCellModel *discription= [[HSTextCellModel alloc] initWithTitle:@"预约描述" detailText:self.model.note actionBlock:^(HSBaseCellModel *model) {
        
    }];
    discription.titleColor = KCommonBlack;
    discription.titleFont = [UIFont systemFontOfSize:15];
    discription.showArrow = NO;
    
    
    NSMutableArray *section1 = [NSMutableArray arrayWithObjects:discription,nil];
    [self.hs_dataArry addObject:section0];
    [self.hs_dataArry addObject:section1];
}

@end
