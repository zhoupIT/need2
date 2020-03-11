//
//  UHReservationServiceController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHReservationServiceController.h"

#import "UHReservationView.h"

#import "UHReservationCityModel.h"
#import "UHCityServicesModel.h"
#import "UHPrice.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import "UHWechatPayModel.h"
#import "UHOrderModel.h"
#import "UHHospitalModel.h"
#import "UHMedicalCityServiceModel.h"

#import "HSSetTableViewController.h"
#import "UHReservationCityListController.h"
#import "UHHelpCenterController.h"
#import "UHPatientListController.h"
#import "UHReservationCheckOutController.h"
#import "UHGreenPathHospitalController.h"
#import "UHGreenPathReservationSerController.h"

@interface UHReservationServiceController ()<WXApiManagerDelegate>
@property (nonatomic,strong) UHReservationView *footView;
@property (nonatomic,strong) HSTextCellModel *city;
@property (nonatomic,strong) HSTextCellModel *type;
@property (nonatomic,strong) HSCustomCellModel *phone;
@property (nonatomic,strong) HSTextCellModel *hospital;
//就医城市 模型
@property (nonatomic,strong) UHReservationCityModel *cityModel;
//服务类型 模型
@property (nonatomic,strong) UHMedicalCityServiceModel *serviceModel;
//就医人 模型
@property (nonatomic,strong) UHPatientListModel *patientModel;
//医院 模型
@property (nonatomic,strong) UHHospitalModel *hospitalModel;

@property (nonatomic,copy) NSString *phoneValue;

@property (nonatomic,strong) HSFooterModel *footerModel;
@end

@implementation UHReservationServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [WXApiManager sharedManager].delegate = self;
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"在线预约";
    __weak typeof(self) weakSelf =self;
    //初始化tableView
    [self initSetTableViewConfigureStyle:UITableViewStyleGrouped];
    [self setupTableViewConstrint:-10 left:0 right:0 bottom:0];
    NSMutableArray *footerModels = [NSMutableArray array];
    CGFloat w = SCREEN_WIDTH;
    CGFloat height = 0;
    if ( w <= self.processImg.width) {
        height = (w / self.processImg.width) * self.processImg.height;
    } else{
        height = self.processImg.height;
    }
    UHReservationView *footView = [[UHReservationView alloc] init];
    footView.processImage = self.processImg;
    footView.addPerBlock = ^{
        //添加就医人
        UHPatientListController *patListControl = [[UHPatientListController alloc] init];
        patListControl.selectedPatientBlock = ^(UHPatientListModel *model) {
            weakSelf.patientModel = model;
            //更新ui
            [weakSelf.footView updateUIWithModel:model];
            if (weakSelf.serviceModel) {
                [weakSelf getPrice];
            }
            weakSelf.footerModel.footerViewHeight = 488+height;
            [weakSelf.hs_tableView reloadData];
        };
        [self.navigationController pushViewController:patListControl animated:YES];
    };
    footView.commitAppointmentBlock = ^{
        //提交预约
        ZPLog(@"提交预约");
        [self submitOrder];
        
    };
    
    footView.deleteBlock = ^{
        weakSelf.patientModel = nil;
        weakSelf.footerModel.footerViewHeight = 438+height;
        [weakSelf.hs_tableView reloadData];
    };
    footView.callBlock = ^{
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-656-0320"];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    };
    self.footView = footView;
    self.footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 438+height);
    
    HSFooterModel *footerModel = [HSFooterModel new];
    footerModel.footerView = self.footView ;
    footerModel.footerViewHeight = 438+height;
    self.footerModel = footerModel;
    
    HSFooterModel *footerModel1 = [HSFooterModel new];
    footerModel1.footerView = [UIView new] ;
    footerModel1.footerViewHeight = 10.0f;
    
    [footerModels addObject:footerModel];
    [footerModels addObject:footerModel1];
    
    [self setTableViewFooterArry:footerModels];
    
    NSMutableAttributedString * cityStr = [[NSMutableAttributedString alloc] initWithString:@"就医城市*"];
    [cityStr addAttribute:NSForegroundColorAttributeName value:ZPMyOrderDetailFontColor range:NSMakeRange(0, 3)];
    [cityStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:ZPPFSCRegular size:14] range:NSMakeRange(0, 5)];
    [cityStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4,1)];
    
    HSTextCellModel *city = [[HSTextCellModel alloc] initWithAttributeTitle:cityStr detailText:@"请选择城市" actionBlock:^(HSBaseCellModel *model) {
        UHReservationCityListController *cityListControl =  [[UHReservationCityListController alloc] init];
        cityListControl.type = ZPEnterTypeCity;
        cityListControl.selectedCityBlock = ^(UHReservationCityModel *model) {
            weakSelf.cityModel = model;
            weakSelf.city.detailText = model.name;
             [weakSelf updateCellModel:weakSelf.city];
        };
        if (weakSelf.cityModel) {
            cityListControl.cityModelSel = weakSelf.cityModel;
        }
        [weakSelf.navigationController pushViewController:cityListControl animated:YES];
    }];
    city.showArrow = YES;
    city.showLine = YES;
    self.city = city;
    
    NSMutableAttributedString *typeStr = [[NSMutableAttributedString alloc] initWithString:@"预约服务类型*"];
    [typeStr addAttribute:NSForegroundColorAttributeName value:ZPMyOrderDetailFontColor range:NSMakeRange(0, 5)];
    [typeStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:ZPPFSCRegular size:14] range:NSMakeRange(0, 7)];
    [typeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,1)];
    HSTextCellModel *type = [[HSTextCellModel alloc] initWithAttributeTitle:typeStr detailText:@"请选择服务类型" actionBlock:^(HSBaseCellModel *model) {
        if (!self.city.detailText.length || [self.city.detailText isEqualToString:@"请选择城市"]) {
            [MBProgressHUD showError:@"请先选择就医城市"];
            return;
        }
        UHGreenPathReservationSerController *serviceControl = [[UHGreenPathReservationSerController alloc] init];
        serviceControl.cityID =  weakSelf.cityModel.ID;
        serviceControl.selectedServiceBlock = ^(UHMedicalCityServiceModel * _Nonnull model) {
            weakSelf.serviceModel = model;
            weakSelf.type.detailText = model.serviceTypeName;
            [weakSelf updateCellModel:weakSelf.type];
            if (weakSelf.patientModel) {
                //查询价格
                [weakSelf getPrice];
            }
        };
        if (weakSelf.serviceModel) {
            serviceControl.serviceModelSel = weakSelf.serviceModel;
        }
        [weakSelf.navigationController pushViewController:serviceControl animated:YES];
    }];
    type.showArrow = YES;
    type.showLine = YES;
    self.type = type;

    
    HSCustomCellModel *phone = [[HSCustomCellModel alloc] initWithCellIdentifier:@"UHReservationTextFieldCell" actionBlock:^(HSBaseCellModel *model) {
        ZPLog(@"点击了自定义cell");
    }];
    self.phone = phone;
    
    
    HSTextCellModel *hospital = [[HSTextCellModel alloc] initWithTitle:@"医院" detailText:@"请选择医院" actionBlock:^(HSBaseCellModel *model) {
        if (!self.city.detailText.length || [self.city.detailText isEqualToString:@"请选择城市"]) {
            [MBProgressHUD showError:@"请先选择就医城市"];
            return;
        }
        if (!self.type.detailText.length || [self.type.detailText isEqualToString:@"请选择服务类型"]) {
            [MBProgressHUD showError:@"请先选择服务类型"];
            return;
        }
        UHGreenPathHospitalController *control = [[UHGreenPathHospitalController alloc] init];
        if (weakSelf.hospitalModel) {
            control.hospitalModelSel = self.hospitalModel;
        }
        control.cityServiceId = self.serviceModel.ID;
        control.selHospitalBlock = ^(UHHospitalModel * _Nonnull model) {
            weakSelf.hospitalModel = model;
            weakSelf.hospital.detailText = model.hospitalName;
            [weakSelf updateCellModel:weakSelf.hospital];
        };
        [weakSelf.navigationController pushViewController:control animated:YES];
        
    }];
    hospital.titleColor = ZPMyOrderDetailFontColor;
    hospital.titleFont = [UIFont fontWithName:ZPPFSCRegular size:14];
    hospital.showArrow = YES;
    hospital.showLine = YES;
    self.hospital = hospital;
    
    
    NSMutableArray *section0 = [NSMutableArray arrayWithObjects:city,type,phone,hospital,nil];
    
    [self.hs_dataArry addObject:section0];
    [self.hs_tableView reloadData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"说明" style:UIBarButtonItemStyleDone target:self action:@selector(helpCenter)];
}


- (void)helpCenter {
    UHHelpCenterController *helpControl = [[UHHelpCenterController alloc] init];
    [self.navigationController pushViewController:helpControl animated:YES];
}

- (void)getPrice {
    //获取价格
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"%@/api/green/channel/order/price?cityServiceId=%@&medicalPersonId=%@",ZPBaseUrl,self.serviceModel.ID,self.patientModel.ID] parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            UHPrice *price = [UHPrice mj_objectWithKeyValues:[response objectForKey:@"data"]];
            self.footView.model = price;
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    } className:[UHReservationServiceController class]];
}

- (void)submitOrder {
    if (!self.city.detailText.length || [self.city.detailText isEqualToString:@"请选择城市"]) {
        [MBProgressHUD showError:@"请先选择就医城市"];
        return;
    }
    if (!self.type.detailText.length || [self.type.detailText isEqualToString:@"请选择服务类型"]) {
        [MBProgressHUD showError:@"请选择服务类型"];
        return;
    }
    if (!self.phoneValue || !self.phoneValue.length) {
        [MBProgressHUD showError:@"请填入联系方式"];
        return;
    }
    if (![Utils checkPhoneNumber:self.phoneValue]) {
        [MBProgressHUD showError:@"请输入正确格式的手机号码"];
        return;
    }
    if (!self.patientModel) {
        [MBProgressHUD showError:@"请添加就医人"];
        return;
    }
    UHReservationCheckOutController *checkOutControl = [[UHReservationCheckOutController alloc] init];
    checkOutControl.patientModel = self.patientModel;
    checkOutControl.cityModel = self.cityModel;
    checkOutControl.serviceModel = self.serviceModel;
    checkOutControl.hospitalModel = self.hospitalModel;
    checkOutControl.noti = self.footView.descTextView.text;
    checkOutControl.phoneValue = self.phoneValue;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    checkOutControl.time = [format stringFromDate:[NSDate date]];
    checkOutControl.type =self.type.detailText;
    checkOutControl.originProductAmountTotal = self.footView.model.totalPay;
    checkOutControl.reducedPrice = self.footView.model.discountMoney;
    checkOutControl.logisticsFee = @"0";
    checkOutControl.orderAmountTotal = self.footView.model.finalPay;
    [self.navigationController pushViewController:checkOutControl animated:YES];
}

#pragma mark - 支付代理
- (void)managerDidRecvPaymentResponse:(PayResp *)response {
    switch (response.errCode) {
        case WXSuccess:
            [self checkWechatPayResult];
            break;
        case WXErrCodeUserCancel:
            [MBProgressHUD showError:@"支付失败:用户取消!请到'我的订单'完成支付"];
            break;
        default:{
            [MBProgressHUD showError:@"支付失败:其他原因!请到'我的订单'完成支付"];
        }
            
            break;
    }
}

- (void)checkWechatPayResult {
    //向server查询支付结果，刷新页面
    [MBProgressHUD showError:@"支付成功,请到'我的服务'查看"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldTextChange:(NSNotification *)noti {
    UITextField *textField = noti.object;
    if (textField.tag == 10011) {
         self.phoneValue =textField.text;
    }
}

@end
