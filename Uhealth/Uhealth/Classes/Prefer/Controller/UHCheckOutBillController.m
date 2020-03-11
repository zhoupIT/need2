//
//  UHCheckOutBillController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHCheckOutBillController.h"
#import "UHCheckOutModel.h"

#import "UHCheckOutNoLocHeaderCell.h"
#import "UHCheckOutHeaderCell.h"
#import "UHCheckOutSubTitleCell.h"
#import "UHCheckOutSubtitleIconCell.h"
#import "UHCheckOutSubViewCell.h"
#import "UHCheckOutScoreCell.h"
#import "UHCheckOutRemarkCell.h"
#import "UHCheckOutOrderCell.h"
#import "UHCheckOutTitleCell.h"
#import "UHCheckOutFavourCell.h"

#import "UHCheckOutSubmitView.h"
#import "UHCheckOutResultController.h"

#import "UHCarCommodity.h"
#import "UHCommodity.h"

#import "UHMyAddressController.h"

#import "UHWechatPayModel.h"
#import "WXApi.h"
#import "UHWechatPayModel.h"
#import "WXApiManager.h"

#import "UHAddressModel.h"

#import "UHPayController.h"
@interface UHCheckOutBillController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,WXApiManagerDelegate>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UHCheckOutSubmitView *submitView;

@property (nonatomic,strong) NSDecimalNumber *originaltotalPrice;
@property (nonatomic,strong) NSDecimalNumber *totalPrice;
@property (nonatomic,strong) NSDecimalNumber *favourPrice;

//是否选择了地点
@property (nonatomic,assign) BOOL isLocSel;

//下单的商品的数组
@property (nonatomic,strong) NSMutableArray *payArray;
@property (nonatomic,copy) NSString *note;

@property (nonatomic,strong) UHAddressModel *addressmodel;
@end

@implementation UHCheckOutBillController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.addressmodel) {
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"%@/api/common/receiveAddress/%@",ZPBaseUrl,self.addressmodel.ID] parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                if ([[response objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                    self.addressmodel = nil;
                    self.isLocSel = NO;
                    [self.tableView reloadData];
                } else {
                    UHAddressModel *model = [UHAddressModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
                    self.addressmodel = model;
                    [self.tableView reloadData];
                }
            } else {
                self.addressmodel = nil;
                self.isLocSel = NO;
                [self.tableView reloadData];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            self.addressmodel = nil;
            self.isLocSel = NO;
            [self.tableView reloadData];
        } className:[UHCheckOutBillController class]];
    } else {
        self.addressmodel = nil;
        self.isLocSel = NO;
        [self.tableView reloadData];
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"receiveAddress/list" parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *list = [UHAddressModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (list.count) {
                    for (UHAddressModel *model in list) {
                        if ([model.addressStatus.name isEqualToString:@"DEFAULT"]) {
                            self.addressmodel = model;
                            self.isLocSel = YES;
                            [self.tableView reloadData];
                        }
                    }
                }
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
        } className:[UHMyAddressController class]];
    }
    /*
    if (self.addressmodel) {
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"%@/api/common/receiveAddress/%@",ZPBaseUrl,self.addressmodel.ID] parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                if ([[response objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                    self.addressmodel = nil;
                    self.isLocSel = NO;
                    [self.tableView reloadData];
                } else {
                UHAddressModel *model = [UHAddressModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
                self.addressmodel = model;
                [self.tableView reloadData];
                }
            } else {
                self.addressmodel = nil;
                self.isLocSel = NO;
                [self.tableView reloadData];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            self.addressmodel = nil;
            self.isLocSel = NO;
            [self.tableView reloadData];
        } className:[UHCheckOutBillController class]];
    }
     */
}

- (void)getData {
    [self.dataArray addObject: [UHCheckOutModel creatDetailsData]];
     if (self.entertype == ZPEnterCart) {
    [self calPrice];
     }else {
         [self calPriceWithNum:@"1"];
     }
    [self.tableView reloadData];
    [WXApiManager sharedManager].delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
   
}

- (void)setupUI {
    self.view.backgroundColor = KControlColor;
    self.title = @"填写订单";
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, KIsiPhoneX?84:50);
    
    self.submitView = [UHCheckOutSubmitView addSubmitView];
    [self.view addSubview:self.submitView];
    self.submitView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(KIsiPhoneX?84:50)
    .bottomEqualToView(self.view);
    __weak typeof(self) weakSelf = self;
    
    self.submitView.submitBlock = ^(UIButton *btn){
        if (weakSelf.addressmodel == nil) {
            [MBProgressHUD showError:@"请先选择收货地址"];
            return ;
        }
        //下单
        [MBProgressHUD showMessage:@"下单中..."];
//        NSArray *orderArray  = @[@{@"commodityId":@1,@"number": @2},@{@"commodityId":@2,@"number": @2}];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/order/order",ZPBaseUrl]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        request.HTTPMethod = @"PUT";
        
        request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};//此处为请求头，类型为字典
        if (weakSelf.note == nil) {
            weakSelf.note = @"";
        }
        NSDictionary *msg = @{@"receiveAddressId":weakSelf.addressmodel.ID,@"note":weakSelf.note,@"needInvoice":@"NO",@"orderItems":weakSelf.payArray};
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:msg options:NSJSONWritingPrettyPrinted error:nil];
        
        request.HTTPBody = data;
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            ZPLog(@"%@ --------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                if (error == nil) {
                    NSDictionary *dict = [data mj_JSONObject];
                    if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                        //下单成功 --> 清空购物车 -> 微信支付
                        if (self.entertype == ZPEnterCart) {
                            //删除购物车里面的商品
                            NSMutableArray *commodityIDDeleteArray = [NSMutableArray array];
                            for (UHCarCommodity *model in weakSelf.orderArray) {
                                [commodityIDDeleteArray addObject:model.itemId];
                            }
                            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/store/shopping/cart",ZPBaseUrl]];
                            
                            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                            
                            request.HTTPMethod = @"DELETE";
                            
                            request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};//此处为请求头，类型为字典
                            
                            
                            NSData *data = [NSJSONSerialization dataWithJSONObject:commodityIDDeleteArray options:NSJSONWritingPrettyPrinted error:nil];
                            
                            request.HTTPBody = data;
                            
                            [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                NSLog(@"%@ --------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
                                dispatch_async(dispatch_get_main_queue(), ^{
                                   
                                    if (error == nil) {
                                        NSDictionary *dict = [data mj_JSONObject];
                                        if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                                            if (weakSelf.emptyCartBlock) {
                                                weakSelf.emptyCartBlock();
                                            }                                        
                                        } else {
                                            [MBProgressHUD showError:[dict objectForKey:@"message"]];
                                        }
                                    } else {
                                        [MBProgressHUD showError:error.localizedDescription];
                                    }
                                });
                                
                                
                                
                            }] resume];
                        }
                        
                        
                        //微信支付
                        /*
                        if (![WXApi isWXAppInstalled]) {
                            ZPLog(@"没有安装微信...");
                            [MBProgressHUD showError:@"您没有安装微信..."];
                            return;
                        }
                        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"payment/wechat" parameters:@{@"orderId":[dict objectForKey:@"data"]} progress:^(NSProgress *progress) {
                            
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
                            
                        } className:[UHCheckOutBillController class]];
                        */
                        
                        UHPayController *payControl = [[UHPayController alloc] init];
                        payControl.orderID =[dict objectForKey:@"data"];
                        if (self.entertype == ZPEnterCart) {
                            payControl.payEnterType = ZPPayEnterTypeCart;
                        } else if (self.entertype == ZPEnterOrderDetail) {
                            payControl.payEnterType = ZPPayEnterTypeOrderDetail;
                        }
                        [weakSelf.navigationController pushViewController:payControl animated:YES];
                        
                    } else {
                        [MBProgressHUD showError:[dict objectForKey:@"message"]];
                    }
                } else {
                    [MBProgressHUD showError:error.localizedDescription];
                }
            });
            
            
            
        }] resume];
       
    };
}

#pragma mark - -tableView的数据源方法
/**
 *  返回组数(默认为1组)
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

/**
 *  返回每组的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        if (self.entertype == ZPEnterCart) {
            return 2+self.orderArray.count;
        }
        return 3+self.orderArray.count;
    }
//    if (section == 2) {
//        return 2;
//    }
    return 4;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (!self.isLocSel) {
            UHCheckOutNoLocHeaderCell *cell = [UHCheckOutNoLocHeaderCell cellWithTableView:tableView];
            cell.addLocBlock = ^{
                __weak typeof(self) weakSelf = self;
                UHMyAddressController *myaddressControl = [[UHMyAddressController alloc] init];
                myaddressControl.selectLocBlock = ^(UHAddressModel *model) {
                    weakSelf.addressmodel = model;
                    weakSelf.isLocSel = YES;
                    [weakSelf.tableView reloadData];
                };
               
                [self.navigationController pushViewController:myaddressControl animated:YES];
            };
            return cell;
        } 
        UHCheckOutHeaderCell *cell = [UHCheckOutHeaderCell cellWithTableView:tableView];
        cell.model = self.addressmodel;
        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UHCheckOutTitleCell *cell = [UHCheckOutTitleCell cellWithTableView:tableView];
            return cell;
        }
        if (self.entertype == ZPEnterCart) {
            if (indexPath.row == self.orderArray.count+1) {
                UHCheckOutSubtitleIconCell *cell = [UHCheckOutSubtitleIconCell cellWithTableView:tableView];
                return cell;
            }
        } else {
            if (indexPath.row == self.orderArray.count+1) {
                UHCheckOutSubViewCell *cell = [UHCheckOutSubViewCell cellWithTableView:tableView];
                cell.updatePriceBlock = ^(NSInteger num) {
                    [self calPriceWithNum:[NSString stringWithFormat:@"%ld",num]];
                    [self.tableView beginUpdates];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.orderArray.count+1] withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView endUpdates];
                };
                return cell;
            }
            if (indexPath.row == self.orderArray.count+2) {
                UHCheckOutSubtitleIconCell *cell = [UHCheckOutSubtitleIconCell cellWithTableView:tableView];
                return cell;
            }
        }
       
        UHCheckOutOrderCell *cell = [UHCheckOutOrderCell cellWithTableView:tableView];
        if (self.entertype == ZPEnterCart) {
             cell.model = self.orderArray[indexPath.row-1];
        } else {
             cell.commodityModel = self.orderArray[indexPath.row-1];
        }
       
        return cell;
    }
//    else if(indexPath.section == 2) {
//        if (indexPath.row == 0) {
//            UHCheckOutFavourCell *cell = [UHCheckOutFavourCell cellWithTableView:tableView];
//            return cell;
//        }
//        if (indexPath.row == 1) {
//            UHCheckOutScoreCell *cell = [UHCheckOutScoreCell cellWithTableView:tableView];
//            return cell;
//        }
//    }
    else if(indexPath.section == 2) {
        if (indexPath.row == 0) {
            UHCheckOutRemarkCell *cell = [UHCheckOutRemarkCell cellWithTableView:tableView];
            return cell;
        }
       
        UHCheckOutSubTitleCell *cell = [UHCheckOutSubTitleCell cellWithTableView:tableView];
          if (indexPath.row == 1) {
              cell.subtitleStr = [NSString stringWithFormat:@"¥%@",self.originaltotalPrice];
              cell.titleStr = @"商品合计:";
         } else  if (indexPath.row == 2) {
             cell.subtitleStr = [NSString stringWithFormat:@"-¥%@",self.favourPrice];
             cell.titleStr = @"优惠金额：";
         } else if (indexPath.row == 3) {
             cell.subtitleStr = @"¥0";
             cell.titleStr = @"运费：";
         }
        return cell;
        
    }
    UHCheckOutSubTitleCell *cell = [UHCheckOutSubTitleCell cellWithTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 90;
    }
    if (indexPath.section == 1) {
        if (indexPath.row >0 && indexPath.row <=self.orderArray.count) {
            return 110;
        }
        return 40;
    }
    return 40;
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
//    if (section == 1) {
//        return 43;
//    }
    return 10;
}
//section底部视图
/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *view = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 43)];
        view.backgroundColor = KControlColor;
        UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 43)];
        [view addSubview:bView];
        
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15, 43)];
        lab.backgroundColor =KControlColor;
        lab.textColor = ZPMyOrderDetailFontColor;
        lab.text = @"优惠";
        lab.font = [UIFont systemFontOfSize:13];
        [view addSubview:lab];
        return view;
    }
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        __weak typeof(self) weakSelf = self;
        UHMyAddressController *myaddressControl = [[UHMyAddressController alloc] init];
        myaddressControl.selectLocBlock = ^(UHAddressModel *model) {
            weakSelf.addressmodel = model;
            weakSelf.isLocSel = YES;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:myaddressControl animated:YES];
    }
    
}


- (void)textFieldTextChange:(NSNotification *)noti {
    UITextField *currentTextField = (UITextField *)noti.object;
    self.note = currentTextField.text;
}

//重新计算价格
- (void)calPrice {
   
        //原本的价格
        self.originaltotalPrice = [NSDecimalNumber decimalNumberWithString:@"0"];
        //应付价格
        self.totalPrice = [NSDecimalNumber decimalNumberWithString:@"0"];
    
        for (UHCarCommodity *model in self.orderArray) {
            
            NSDecimalNumber *presentPrice = [NSDecimalNumber decimalNumberWithString:model.commodity.presentPrice];
            self.totalPrice = [self.totalPrice decimalNumberByAdding:[presentPrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:model.commodityCount]]];
            
            NSDecimalNumber *originalPrice = [NSDecimalNumber decimalNumberWithString:model.commodity.originalPrice];
            self.originaltotalPrice = [self.originaltotalPrice decimalNumberByAdding:[originalPrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:model.commodityCount]]];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:[NSNumber numberWithInteger:model.commodity.commodityId] forKey:@"commodityId"];
            [dict setValue:model.commodityCount forKey:@"number"];
            [self.payArray addObject:dict];
        }
        //优惠的价格
        self.favourPrice = [self.originaltotalPrice decimalNumberBySubtracting:self.totalPrice];
        self.submitView.presentPriceLabel.text = [NSString stringWithFormat:@"¥%@",self.totalPrice];
}

- (void)calPriceWithNum:(NSString *)num{
    //原本的价格
    self.originaltotalPrice = [NSDecimalNumber decimalNumberWithString:@"0"];
    //应付价格
    self.totalPrice = [NSDecimalNumber decimalNumberWithString:@"0"];
    [self.payArray removeAllObjects];
    for (UHCommodity *model in self.orderArray) {
        
        NSDecimalNumber *presentPrice = [NSDecimalNumber decimalNumberWithString:model.presentPrice];
        self.totalPrice = [self.totalPrice decimalNumberByAdding:[presentPrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:num]]];
        
        NSDecimalNumber *originalPrice = [NSDecimalNumber decimalNumberWithString:model.originalPrice];
        self.originaltotalPrice = [self.originaltotalPrice decimalNumberByAdding:[originalPrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:num]]];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:[NSNumber numberWithInteger:model.commodityId] forKey:@"commodityId"];
        [dict setValue:num forKey:@"number"];
        [self.payArray addObject:dict];
    }
    //优惠的价格
    self.favourPrice = [self.originaltotalPrice decimalNumberBySubtracting:self.totalPrice];
    self.submitView.presentPriceLabel.text = [NSString stringWithFormat:@"¥%@",self.totalPrice];
   
}


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
    [MBProgressHUD showError:@"支付成功"];
    UHCheckOutResultController *checkOutResultControl = [[UHCheckOutResultController alloc] init];
    checkOutResultControl.enterResultType = self.entertype;
    [self.navigationController pushViewController:checkOutResultControl animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)payArray {
    if (!_payArray) {
        _payArray = [NSMutableArray array];
    }
    return _payArray;
}

@end
