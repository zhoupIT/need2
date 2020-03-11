//
//  UHUserController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHUserController.h"
#import "UHUserHeaderView.h"
#import "UHUserViewFlowLayout.h"
#import "UHUserViewIconCell.h"
#import "UHUserViewTopCell.h"
#import "UHUserViewBottomCell.h"

#import "UHSettingController.h"
#import "UHPersonalInfoController.h"
#import "UHMyFileMainController.h"
#import "UHArchivesController.h"
#import "UHMyPlanController.h"
#import "UHMyPointController.h"
#import "UHMyFamilyController.h"
#import "UHAboutUsController.h"

#import "UHMyOrderMainController.h"
#import "UHMyServiceController.h"
#import "UHHealthTestWebViewController.h"
#import "UHBindingCompanyController.h"
#import "UHMyStepsController.h"

#import "UHUserModel.h"
#import "WZLBadgeImport.h"
#import "UHRedDot.h"
#import "UHCabinDetailModel.h"

#import "UHLoginController.h"
#import "UHNavigationController.h"
#import "UHCabinController.h"
#import "UHTabBarViewController.h"
static NSString *topCellId = @"topCellId";
static NSString *iconCellId = @"iconCellId";
static NSString *bottomCellId = @"bottomCellId";
@interface UHUserController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UHUserHeaderView *headerView;
@property (nonatomic, weak) UICollectionView *mineView;
@property (nonatomic, strong) NSArray<NSDictionary *> *orderItems;
@property (nonatomic, strong) NSArray<NSDictionary *> *bottomItems;

@property (nonatomic,strong) NSMutableArray *redDotDatas;

@property (nonatomic,copy) NSString *companyname;
@end

@implementation UHUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
   
}

- (void)getData {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
       UHUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
        self.companyname = model.companyName;
        self.headerView.model = model;
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"redDot" parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                [self.redDotDatas removeAllObjects];
                UHRedDot *redDot = [UHRedDot mj_objectWithKeyValues:[response objectForKey:@"data"]];
                [self.redDotDatas addObject:redDot.nonPayMentNum];
                [self.redDotDatas addObject:redDot.nonSendNum];
                [self.redDotDatas addObject:redDot.nonReceiveNum];
                [self.redDotDatas addObject:redDot.nonEvaluatedNum];
                [UIView performWithoutAnimation:^{
                    [self.mineView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                }];
            } else {
                
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHUserController class]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true];
     [self getData];
}

- (void)setupUI {
    UHUserHeaderView *headerView = [UHUserHeaderView headerView];
    [self.view addSubview:headerView];
    
   headerView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .heightIs(175)
    .rightEqualToView(self.view);
    self.headerView = headerView;
    __weak typeof(self) weakSelf = self;
    headerView.aboutBlock = ^(){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UHSettingController *settingCtrol = [[UHSettingController alloc] init];
        [strongSelf.navigationController pushViewController:settingCtrol animated:YES];
    };
    headerView.perosonalInfoBlock = ^(){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UHPersonalInfoController *perInfoControl = [[UHPersonalInfoController alloc] init];
        [strongSelf.navigationController pushViewController:perInfoControl animated:YES];
    };
    headerView.loginBlock = ^{
        UHLoginController *loginControl = [[UHLoginController alloc] init];
        UHNavigationController *nav = [[UHNavigationController alloc] initWithRootViewController:loginControl];
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    };

    UHUserViewFlowLayout *flowLayout = [[UHUserViewFlowLayout alloc] init];
    UICollectionView *mineView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 175, SCREEN_WIDTH, self.view.height - 175) collectionViewLayout:flowLayout];
    mineView.delegate = self;
    mineView.dataSource = self;
    mineView.backgroundColor =RGB(245, 245, 245);
    [self.view addSubview:mineView];
    mineView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    self.mineView = mineView;

    [mineView registerClass:[UHUserViewTopCell class] forCellWithReuseIdentifier:topCellId];
    [mineView registerClass:[UHUserViewIconCell class] forCellWithReuseIdentifier:iconCellId];
    [mineView registerClass:[UHUserViewBottomCell class] forCellWithReuseIdentifier:bottomCellId];
}

- (NSArray<NSDictionary *> *)orderItems {
    return @[@{@"iconImageName" : @"me_dzf", @"iconTitle" : @"待付款"},
             @{@"iconImageName" : @"me_dfh", @"iconTitle" : @"待发货"},
             @{@"iconImageName" : @"me_dsh", @"iconTitle" : @"待收货"},
             @{@"iconImageName" : @"me_dpj", @"iconTitle" : @"待评价"}];
}

- (NSArray<NSDictionary *> *)bottomItems {
    return @[@{@"iconImageName" : @"me_myCompany_icon", @"iconTitle" : @"我的企业"},
             @{@"iconImageName" : @"me_mySteps_icon", @"iconTitle" : @"健步走"},
             @{@"iconImageName" : @"me_healthTest_icon", @"iconTitle" : @"健康自测"},
             @{@"iconImageName" : @"me_myService_icon", @"iconTitle" : @"我的服务"},
             @{@"iconImageName" : @"me_myScore_icon", @"iconTitle" : @"我的积分"},
//             @{@"iconImageName" : @"me_myfamily", @"iconTitle" : @"我的家人"},
             @{@"iconImageName" : @"me_about_icon", @"iconTitle" : @"关于我们"}];
}

#pragma mark - collectionView数据源和代理

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return CGSizeMake(SCREEN_WIDTH, 44);
        }
        return CGSizeMake(SCREEN_WIDTH / 4, 70);
    } else if (indexPath.section == 1) {
        return CGSizeMake(SCREEN_WIDTH, 53);
    }
    return CGSizeMake(SCREEN_WIDTH / 4, 90);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 1) {
        return 6;
    }
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UHUserViewTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:topCellId forIndexPath:indexPath];
            cell.isAccessoryHidden = false;
            cell.title = @"我的订单";
            cell.subTitle = @"查看更多订单";
            return cell;
        }
        UHUserViewIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iconCellId forIndexPath:indexPath];
        cell.iconImageName = self.orderItems[indexPath.row - 1][@"iconImageName"];
        cell.iconTitle = self.orderItems[indexPath.row - 1][@"iconTitle"];
        if (self.redDotDatas.count) {
            cell.num = self.redDotDatas[indexPath.row-1];
        } else {
            cell.num = @"0";
        }
        return cell;
    }
    UHUserViewBottomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bottomCellId forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.rightTitle = self.companyname;
        cell.iconImageName = self.bottomItems[indexPath.row][@"iconImageName"];
        cell.iconTitle = self.bottomItems[indexPath.row][@"iconTitle"];
    } else {
        cell.iconImageName = self.bottomItems[indexPath.row][@"iconImageName"];
        cell.iconTitle = self.bottomItems[indexPath.row][@"iconTitle"];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UHMyOrderMainController *myOrderControl = [[UHMyOrderMainController alloc] init];
        myOrderControl.index = indexPath.row;
        [self.navigationController pushViewController:myOrderControl animated:YES];
        return;
    }
    switch (indexPath.row) {
        case 0:
        {
            if (![[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
                UHLoginController *loginControl = [[UHLoginController alloc] init];
                UHNavigationController *nav = [[UHNavigationController alloc] initWithRootViewController:loginControl];
                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            } else {
                WEAK_SELF(weakSelf);
                UHUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
                if (!model.companyName || !model.companyName.length) {
                    UHBindingCompanyController *companyControl = [[UHBindingCompanyController alloc] init];
                    companyControl.updateComBlock = ^{
                        if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
                            UHUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
                            weakSelf.companyname = model.companyName;
//                            [UIView performWithoutAnimation:^{
//                                [self.mineView reloadSections:[NSIndexSet indexSetWithIndex:1]];
//                            }];
                            UHTabBarViewController *tabbar = [[UHTabBarViewController alloc] init];
                            weakSelf.view.window.rootViewController = tabbar;
                        }
                    };
                    [self.navigationController pushViewController:companyControl animated:YES];
                } else {
                    WEAK_SELF(weakSelf);
                    [MBProgressHUD showMessage:@"加载中..."];
                    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"cabin/detail" parameters:nil progress:^(NSProgress *progress) {
                        
                    } success:^(NSURLSessionDataTask *task, id response) {
                        [MBProgressHUD hideHUD];
                        if ([[response objectForKey:@"code"] integerValue]  == 200) {
                            UHCabinDetailModel *cabinDetailModel = [UHCabinDetailModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
                            UHCabinController *cabinControl = [[UHCabinController alloc] init];
                            cabinControl.model = cabinDetailModel;
                            cabinControl.title = cabinDetailModel.healthCabinName;
                            [weakSelf.navigationController pushViewController:cabinControl animated:YES];
                        } else if ([[response objectForKey:@"code"] integerValue]  == 2211) {
                            [LEEAlert alert].config
                            .LeeTitle(@"提醒")
                            .LeeContent([response objectForKey:@"message"])
                            .LeeAction(@"知道了", ^{
                            })
                            .LeeClickBackgroundClose(YES)
                            .LeeShow();
                        } else {
                            [MBProgressHUD showError:[response objectForKey:@"message"]];
                        }
                    } failed:^(NSURLSessionDataTask *task, NSError *error) {
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:error.localizedDescription];
                    } className:[UHUserController class]];
                    
                }
            }
        }
            break;
        case 1:
        {
            UHMyStepsController *myStepsControl = [[UHMyStepsController alloc] init];
            [self.navigationController pushViewController:myStepsControl animated:YES];
        }
            break;
        case 2:
        {
            //健康自测
            if (![[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
                UHLoginController *loginControl = [[UHLoginController alloc] init];
                UHNavigationController *nav = [[UHNavigationController alloc] initWithRootViewController:loginControl];
                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            } else {
                UHHealthTestWebViewController *testControl = [[UHHealthTestWebViewController alloc] init];
                [self.navigationController pushViewController:testControl animated:YES];
                
            }
        }
            break;
        case 3:
        {
            UHMyServiceController *myService = [[UHMyServiceController alloc] init];
            [self.navigationController pushViewController:myService animated:YES];
        }
              break;
        case 4:
        {
            UHMyPointController *myPointControl = [[UHMyPointController alloc] init];
            [self.navigationController pushViewController:myPointControl animated:YES];
        }
            
            break;
        case 5:
            {
                UHAboutUsController *aboutUsControl = [[UHAboutUsController alloc] init];
                [self.navigationController pushViewController:aboutUsControl animated:YES];
            }
            break;
            
        default:
        
            break;
    }
   
}

- (NSMutableArray *)redDotDatas {
    if (!_redDotDatas) {
        _redDotDatas = [NSMutableArray array];
    }
    return _redDotDatas;
}
@end
