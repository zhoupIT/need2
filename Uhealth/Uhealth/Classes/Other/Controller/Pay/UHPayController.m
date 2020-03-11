//
//  UHPayController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/7/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHPayController.h"
#import "UHPayCell.h"
#import "UHPayModel.h"

#import <AlipaySDK/AlipaySDK.h>

#import "UHWechatPayModel.h"
#import "WXApi.h"
#import "UHWechatPayModel.h"
#import "WXApiManager.h"

#import "UHCheckOutResultController.h"

#import "UHMyOrderMainController.h"
@interface UHPayController ()<UITableViewDelegate,UITableViewDataSource,WXApiManagerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,strong) UIButton *comfirmBtn;

@property (nonatomic,strong) UHPayModel *selModel;
@end

@implementation UHPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alipaySuccess:)
                                                 name:kNotificationAliPayResp object:nil];
}




- (void)initAll {
    self.view.backgroundColor = KControlColor;
    [self.view addSubview:self.tableView];
    self.title = @"选择付款方式";
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 50, 0));
    [self.view addSubview:self.comfirmBtn];
    self.comfirmBtn.sd_layout
    .bottomEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(50);
    for (int i=0; i<2; i++) {
        UHPayModel *model = [[UHPayModel alloc] init];
        model.imageName = i==0?@"aipay_icon":@"wechat_icon";
        model.title = i==0?@"支付宝付款":@"微信付款";
        model.isSel =i==1?YES:NO;
        if (i==1) {
            self.selModel = model;
        }
        [self.datas addObject:model];
    }
    [self.tableView reloadData];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    [WXApiManager sharedManager].delegate = self;
    
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
    
    return self.datas.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UHPayCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHPayCell class])];
    UHPayModel *model = self.datas[indexPath.row];
    cell.model = model;
    WEAK_SELF(weakSelf);
    cell.selBlock = ^(UIButton *btn) {
        for (UHPayModel *model in weakSelf.datas) {
            model.isSel = NO;
        }
        model.isSel = YES;
        weakSelf.selModel = model;
        [weakSelf.tableView reloadData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (UHPayModel *model in self.datas) {
        model.isSel = NO;
    }
    UHPayModel *model = self.datas[indexPath.row];
    model.isSel = YES;
    self.selModel = model;
    [self.tableView reloadData];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UHPayCell class] forCellReuseIdentifier:NSStringFromClass([UHPayCell class])];
    }
    return _tableView;
}

#pragma mark - Private
//确定付款方式
- (void)comfirmPay {
    if (!self.selModel) {
        [MBProgressHUD showError:@"请选择付款方式!"];
        return;
    }
    if ([self.selModel.title containsString:@"支付宝"]) {
        //支付宝
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"/api/order/payment/alipay/%@",self.orderID] parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSString *signedString =[response objectForKey:@"message"];
                if (signedString !=nil) {
                    NSString *appScheme = @"yyjapp";
                    
                    // NOTE: 调用支付结果开始支付
                    [[AlipaySDK defaultService] payOrder:signedString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                        ZPLog(@"reslut = %@",resultDic);
                    }];
                }
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHPayController class]];
    } else {
        //微信支付
         if (![WXApi isWXAppInstalled]) {
         ZPLog(@"没有安装微信...");
         [MBProgressHUD showError:@"您没有安装微信..."];
         return;
         }
         [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"payment/wechat" parameters:@{@"orderId":self.orderID} progress:^(NSProgress *progress) {
         
         } success:^(NSURLSessionDataTask *task, id response) {
         if ([[response objectForKey:@"code"] integerValue]  == 200) {
         UHWechatPayModel *model = [UHWechatPayModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
         PayReq *req = [[PayReq alloc] init];
         req.openID = model.appId;
         req.partnerId = model.partnerId;
         req.prepayId = model.prepayId;
         req.package = model.wxPackage;
         req.nonceStr = model.nonceStr;
         UInt32 timestamp = (UInt32)[model.timestamp intValue];
         
         req.timeStamp = timestamp;
         req.sign = model.sign;
         
         if ([WXApi sendReq:req]) {
         NSLog(@"吊起成功");
         } else {
         NSLog(@"吊起失败");
         }
         //生成URLscheme
         //                    NSString *str = [NSString stringWithFormat:@"weixin://app/%@/pay/?nonceStr=%@&package=Sign%%3DWXPay&partnerId=%@&prepayId=%@&timeStamp=%@&sign=%@&signType=SHA1",req.openID,req.nonceStr,req.partnerId,req.prepayId,model.timestamp,model.sign];
         
         //通过openURL的方法唤起支付界面
         //                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
         } else {
         [MBProgressHUD showError:[response objectForKey:@"message"]];
         }
         } failed:^(NSURLSessionDataTask *task, NSError *error) {
         
         } className:[UHPayController class]];
         
    }
   
}

- (void)alipaySuccess:(NSNotification *)noti {
    ZPLog(@"收到了%@",noti.object);
    NSString *out_trade_no = noti.object;
    [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"alipay/result/return_url" parameters:@{@"out_trade_no":out_trade_no} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } className:[UHPayController class]];
    [MBProgressHUD showError:@"支付成功"];
    UHCheckOutResultController *checkOutResultControl = [[UHCheckOutResultController alloc] init];
    if (self.payEnterType == ZPPayEnterTypeCart) {
        checkOutResultControl.enterResultType = ZPEnterResultCart;
    } else if (self.payEnterType == ZPPayEnterTypeOrderDetail) {
        checkOutResultControl.enterResultType = ZPEnterResultOrderDetail;
    }  else if (self.payEnterType == ZPPayEnterTypeGreenPath) {
        checkOutResultControl.enterResultType = ZPEnterResultGreenPath;
    }else {
        checkOutResultControl.enterResultType = ZPEnterResultMyOrder;
    }
    [self.navigationController pushViewController:checkOutResultControl animated:YES];
}

- (void)back {
    [LEEAlert alert].config
    .LeeTitle(@"确认要放弃付款?")
    .LeeContent(@"订单会保留一段时间,请尽快支付")
    .LeeCancelAction(@"确认离开", ^{
        // 取消点击事件Block
        if (self.payEnterType == ZPPayEnterTypeCart) {
            UHMyOrderMainController *myOrderControl = [[UHMyOrderMainController alloc] init];
            myOrderControl.index = 0;
            [self.navigationController pushViewController:myOrderControl animated:YES];
        }else if (self.payEnterType == ZPPayEnterTypeOrderDetail) {
            UHMyOrderMainController *myOrderControl = [[UHMyOrderMainController alloc] init];
            myOrderControl.index = 0;
            [self.navigationController pushViewController:myOrderControl animated:YES];
        } else if (self.payEnterType == ZPPayEnterTypeGreenPath) {
            UHMyOrderMainController *myOrderControl = [[UHMyOrderMainController alloc] init];
            myOrderControl.index = 0;
            [self.navigationController pushViewController:myOrderControl animated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    })
    .LeeAction(@"继续支付", ^{
        // 确认点击事件Block
    })
    .LeeShow(); // 设置完成后 别忘记调用Show来显示
    
    
}

#pragma mark - 微信支付回调
- (void)managerDidRecvPaymentResponse:(PayResp *)response {
    switch (response.errCode) {
        case WXSuccess:
            [self checkWechatPayResult];
            break;
        case WXErrCodeUserCancel:
            [MBProgressHUD showError:@"支付失败:用户取消"];
            break;
        default:{
            [MBProgressHUD showError:@"支付失败:其他原因"];
        }
            
            break;
    }
}

- (void)checkWechatPayResult {
    //向server查询支付结果，刷新页面
    
//    if (self.payEnterType == ZPPayEnterTypeGreenPath) {
//        //绿通成功后
//        [MBProgressHUD showSuccess:@"支付成功,请到'我的服务'查看"];
//    } else {
        [MBProgressHUD showError:@"支付成功"];
        UHCheckOutResultController *checkOutResultControl = [[UHCheckOutResultController alloc] init];
        if (self.payEnterType == ZPPayEnterTypeCart) {
            checkOutResultControl.enterResultType = ZPEnterResultCart;
        } else if (self.payEnterType == ZPPayEnterTypeOrderDetail) {
            checkOutResultControl.enterResultType = ZPEnterResultOrderDetail;
        }  else if (self.payEnterType == ZPPayEnterTypeGreenPath) {
            checkOutResultControl.enterResultType = ZPEnterResultGreenPath;
        } else {
            checkOutResultControl.enterResultType = ZPEnterResultMyOrder;
        }
        [self.navigationController pushViewController:checkOutResultControl animated:YES];
//    }
   
}

#pragma mark - 懒加载
- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (UIButton *)comfirmBtn {
    if (!_comfirmBtn) {
        _comfirmBtn = [UIButton new];
        [_comfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_comfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _comfirmBtn.titleLabel.font = [UIFont fontWithName:ZPPFSCMedium size:18];
        [_comfirmBtn setBackgroundColor:ZPMyOrderDetailValueFontColor];
        [_comfirmBtn addTarget:self action:@selector(comfirmPay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comfirmBtn;
}
@end
