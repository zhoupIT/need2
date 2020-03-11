//
//  UHMyShoppingCarController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/2.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyShoppingCarController.h"
#import "UHSettleView.h"
#import "UHMyShoppingCarCell.h"
#import "UHCheckOutBillController.h"
#import "UHCarCommodity.h"
#import "UHCommodity.h"
@interface UHMyShoppingCarController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UHSettleView *settleView;
@property (nonatomic,strong) NSMutableArray *datas;
//@property (nonatomic,strong) NSDecimalNumber *totalPrice;

//默认不是编辑的状态 0
@property (nonatomic,assign) BOOL isEditing;
@property (nonatomic,strong) UIBarButtonItem *rightItem;
@end

@implementation UHMyShoppingCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupRefresh];
    [self.tableView.mj_header beginRefreshing];
    //默认全选
    [self setSettleViewData];
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"购物车居然是空的"
                                                           detailStr:@""];
}

- (void)setupUI {
    self.title = @"购物车";
    __weak typeof(self) weakSelf = self;
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = KControlColor;
    self.tableView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomSpaceToView(self.view, KIsiPhoneX?84:50);
    
    
    [self.view addSubview:self.settleView];
    self.settleView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(KIsiPhoneX?84:50)
    .bottomEqualToView(self.view);
   
    self.settleView.selectAllBlock = ^(UIButton *btn){

        NSMutableArray *selArray = [NSMutableArray array];
        for (UHCarCommodity *model in weakSelf.datas) {
            if (model.isSel) {
                [selArray addObject:model];
            }
        }
        if ((selArray.count == weakSelf.datas.count) || (selArray.count == 0)) {
            //全选的状态 或者 全不选的状态
            for (UHCarCommodity *model in weakSelf.datas) {
                model.isSel = !model.isSel;
            }
        } else {
            if (btn.isSelected) {
                for (UHCarCommodity *model in weakSelf.datas) {
                    model.isSel = YES;
                }
            } else {
                for (UHCarCommodity *model in weakSelf.datas) {
                    model.isSel = NO;
                }
            }
        }
        
        [weakSelf.tableView reloadData];
        
        [weakSelf handleData:NO];
    };
    self.settleView.settleBlock = ^(UIButton *btn){
        if ([btn.titleLabel.text isEqualToString:@"删除"]) {
            //删除购物车里面的商品
            NSMutableArray *commodityIDDeleteArray = [NSMutableArray array];
            for (UHCarCommodity *model in weakSelf.datas) {
                if (model.isSel) {
                    [commodityIDDeleteArray addObject:model.itemId];
                }
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
                    btn.userInteractionEnabled = YES;
                    if (error == nil) {
                        NSDictionary *dict = [data mj_JSONObject];
                        if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                            [MBProgressHUD showSuccess:@"删除商品成功"];
                            [weakSelf.tableView.mj_header beginRefreshing];
                        } else {
                            [MBProgressHUD showError:[dict objectForKey:@"message"]];
                        }
                    } else {
                        [MBProgressHUD showError:error.localizedDescription];
                    }
                });
                
                
                
            }] resume];
           
        } else {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (UHCarCommodity *model in weakSelf.datas) {
                if (model.isSel) {
                    [tempArray addObject:model];
                }
            }
            UHCheckOutBillController *checkoutCtrol = [[UHCheckOutBillController alloc] init];
            checkoutCtrol.orderArray = tempArray;
            checkoutCtrol.entertype = ZPEnterCart;
            checkoutCtrol.emptyCartBlock = ^{
                [weakSelf.tableView.mj_header beginRefreshing];
            };
            [weakSelf.navigationController pushViewController:checkoutCtrol animated:YES];
        }
        
    };
     [self.tableView registerClass:[UHMyShoppingCarCell class] forCellReuseIdentifier:NSStringFromClass([UHMyShoppingCarCell class])];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editCart)];
    self.rightItem = self.navigationItem.rightBarButtonItem;
    
    
    //默认 隐藏
    self.settleView.hidden = YES;
}

- (void)setupRefresh {
    
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"cart" parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [self.tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                self.datas = [UHCarCommodity mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (!self.datas.count) {
                    //如果没有数据 隐藏
                    self.settleView.hidden = YES;
                } else {
                     self.settleView.hidden = NO;
                }
                if (self.isEditing) {
                    [self handleIseditingData];
                }else {
                     [self handleData:YES];
                }
               
                [self.tableView reloadData];
            
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHMyShoppingCarController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
}

//购物车 编辑
- (void)editCart {
    if ([self.rightItem.title isEqualToString:@"编辑"]) {
        self.isEditing = YES;
        [self.rightItem setTitle:@"完成"];
        self.settleView.priceLabel.hidden= YES;
        self.settleView.tiplabel.hidden = YES;
        self.settleView.settleButton.userInteractionEnabled = NO;
        for (UHCarCommodity *model in self.datas) {
            model.isSel = NO;
        }
        self.settleView.selectAllButton.selected = NO;
        [self.settleView.settleButton setTitle:@"删除" forState:UIControlStateNormal];
        [self.settleView.settleButton setBackgroundColor:RGB(221,221,221)];
        [self.tableView reloadData];
    } else {
        self.isEditing = NO;
        [self.rightItem setTitle:@"编辑"];
        self.settleView.priceLabel.hidden= NO;
        self.settleView.tiplabel.hidden = NO;
         self.settleView.settleButton.userInteractionEnabled = YES;
        for (UHCarCommodity *model in self.datas) {
            model.isSel = YES;
        }
        self.settleView.selectAllButton.selected = YES;
        [self.settleView.settleButton setTitle:[NSString stringWithFormat:@"结算(%ld)",self.datas.count] forState:UIControlStateNormal];
        [self.settleView.settleButton setBackgroundColor:ZPMyOrderBorderColor];
        [self handleData:NO];
        [self.tableView reloadData];
        
        if (!self.datas.count) {
            //如果没有数据 隐藏
            self.settleView.hidden = YES;
        }
    }
   
}

- (void)setSettleViewData {
    self.settleView.priceLabel.text = @"¥0";
    self.settleView.settleButton.userInteractionEnabled = NO;
}


//处理在编辑状态下的数据
- (void)handleIseditingData {
    if (self.isEditing) {
        NSInteger num = 0;
        for (UHCarCommodity *model in self.datas) {
                if (model.isSel) {
                    num++;
                }
        }
        self.settleView.selectAllButton.selected = (num == self.datas.count);
        self.settleView.settleButton.userInteractionEnabled = (num != 0);
        [self.settleView.settleButton setBackgroundColor:num >0?ZPMyOrderBorderColor:RGB(221,221,221)];
    }
}

//处理结算状态下的数据
- (void)handleData:(BOOL)isrequest {
    NSDecimalNumber *totalPrice = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSInteger num = 0;
    for (UHCarCommodity *model in self.datas) {
        if (isrequest) {
            //默认是全选的
            model.isSel = YES;
            NSDecimalNumber *presentPrice = [NSDecimalNumber decimalNumberWithString:model.commodity.presentPrice];
            totalPrice = [totalPrice decimalNumberByAdding:[presentPrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:model.commodityCount]]];
            num++;
        } else {
            if (model.isSel) {
                NSDecimalNumber *presentPrice = [NSDecimalNumber decimalNumberWithString:model.commodity.presentPrice];
                totalPrice = [totalPrice decimalNumberByAdding:[presentPrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:model.commodityCount]]];
                num++;
            }
        }
    }
    self.settleView.selectAllButton.selected = (num == self.datas.count);
    self.settleView.settleButton.userInteractionEnabled = (num != 0);
    self.settleView.priceLabel.text = [NSString stringWithFormat:@"¥%@",totalPrice];
    if (!self.editing) {
         [self.settleView.settleButton setTitle:[NSString stringWithFormat:@"结算(%ld)",num] forState:UIControlStateNormal];
    }
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
    Class currentClass = [UHMyShoppingCarCell class];
    UHMyShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    UHCarCommodity *model = self.datas[indexPath.row];
    cell.model = model;
    cell.refreshViewBlock = ^(BOOL isSel) {
        if (!isSel) {
            self.settleView.selectAllButton.selected = NO;
        }
        model.isSel = isSel;
        if (!self.isEditing) {
             [self handleData:NO];
        } else {
            [self handleIseditingData];
        }
    };
    cell.refreshPriceBlock = ^(NSInteger num){
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"cart" parameters:@{@"itemId":model.itemId,@"commodityCount":[NSNumber numberWithInteger:num]} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                model.commodityCount = [NSString stringWithFormat:@"%ld",num];
                [self handleData:NO];
            } else {
             
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
    
        } className:[UHMyShoppingCarController class]];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115.f;
}

- (UHSettleView *)settleView {
    if (!_settleView) {
        _settleView = [UHSettleView addSettleView];
        _settleView.selectAllButton.selected = YES;
    }
    return _settleView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView =  [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = KControlColor;
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
@end
