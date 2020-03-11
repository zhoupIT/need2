//
//  UHMyOrderMainController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/29.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyOrderMainController.h"
#import "VTMagic.h"
#import "UHMyOrderController.h"
#import "UHMyOrderDetailController.h"
#import "UHOrderModel.h"
#import "UHPayController.h"
#import "UHMyShoppingCarController.h"
#import "UHOrderDetailController.h"
#import "UHReservationServiceController.h"
#import "UHTracesController.h"
@interface UHMyOrderMainController ()<VTMagicViewDataSource, VTMagicViewDelegate>
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong)  NSArray *menuList;
@end

@implementation UHMyOrderMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    _menuList = @[@"全部订单", @"待付款",@"待发货",@"待收货",@"待评价"];
    [_magicController.magicView reloadData];
    [_magicController switchToPage:self.index animated:YES];
}

- (void)setupUI {
    self.title = @"我的订单";
    self.view.backgroundColor = KControlColor;
    [self.view addSubview:self.magicController.view];
    self.magicController.view.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
}

#pragma mark - private
- (void)back {
    BOOL isNeed = NO;
    BOOL isNeedDetail = NO;
    BOOL isNeedGreenPath = NO;
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[UHMyShoppingCarController class]]) {
            isNeed = YES;
            [self.navigationController popToViewController:controller animated:YES];
        }
     }
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[UHOrderDetailController class]]) {
            isNeedDetail = YES;
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[UHReservationServiceController class]]) {
            isNeedGreenPath = YES;
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
    if (!isNeed && !isNeedDetail && !isNeedGreenPath) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return _menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [menuItem setTitleColor:KCommonBlue forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    ZPLog(@"viewControllerAtPage %ld",pageIndex);
    static NSString *gridId = @"relate.identifier";
    WEAK_SELF(weakSelf);
    UHMyOrderController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[UHMyOrderController alloc] init];
    }
//    viewController.orderStatusType = pageIndex;
    viewController.detailClickEventBlock = ^(UHOrderModel *model){
        UHMyOrderDetailController *myorderDetailCtrol = [[UHMyOrderDetailController alloc] init];
        myorderDetailCtrol.orderModel = model;
        myorderDetailCtrol.updateTableBlock = ^{
             [_magicController.magicView reloadData];
        };
        [weakSelf.navigationController pushViewController:myorderDetailCtrol animated:YES];
    };
    viewController.payBlock = ^(UHOrderModel *model) {
        UHPayController *payControl = [[UHPayController alloc] init];
        payControl.orderID =model.orderId;
        /*
        if (model.orderType.code == 1010) {
            //绿通服务
             payControl.payEnterType = ZPPayEnterTypeGreenPath;
        } else {
             payControl.payEnterType = ZPPayEnterTypeNormal;
        }
       */
         payControl.payEnterType = ZPPayEnterTypeNormal;
        [weakSelf.navigationController pushViewController:payControl animated:YES];
    };
    viewController.traceBlock = ^(UHOrderModel *model) {
      //物流
        UHTracesController *tracesControl = [[UHTracesController alloc] init];
        tracesControl.orderId = model.orderId;
        [weakSelf.navigationController pushViewController:tracesControl animated:YES];
    };
    viewController.refreshTableBlock = ^{
         [_magicController.magicView reloadData];
    };
    return viewController;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    ZPLog(@"viewDidAppear %ld",pageIndex);
    UHMyOrderController *viewControllerTemp = viewController;
    viewControllerTemp.orderStatusType = pageIndex;
}

- (void)refresh {
    if (_magicController && _magicController.magicView) {
        [_magicController.magicView reloadData];
    }
}

#pragma mark - accessor methods
- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = KCommonBlue;
        _magicController.magicView.switchStyle = VTSwitchStyleStiff;
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.navigationHeight = 46.f;
        _magicController.magicView.sliderExtension = 10.f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}


@end
