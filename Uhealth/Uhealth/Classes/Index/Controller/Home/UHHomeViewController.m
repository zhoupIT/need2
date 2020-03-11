//
//  UHHomeViewController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/9/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHHomeViewController.h"

#import "UHBannerModel.h"
#import "UHHealthWindModel.h"
#import "UHHealthNewsModel.h"
#import "UHCommodity.h"
#import "UHPsyAssessmentModel.h"
#import "UHUserModel.h"
#import "UHHealthDynamicModel.h"
#import "UHCabinDetailModel.h"
#import "UHAdvisoryChannelModel.h"

#import "UHHomeCycleHeadViewCell.h"
#import "UHHomeCenterCell.h"
#import "UHHomeFunctionCell.h"
#import "UHHomeMarqueeCell.h"
#import "UHHealthWindCell.h"
#import "UHHealthWindOneImageCell.h"

#import "WZLBadgeImport.h"

#import "SessionListViewController.h"
#import "UHLoginController.h"
#import "UHNavigationController.h"
#import "UHHealthNewsWebViewController.h"
#import "UHHealthWindWebViewController.h"
#import "UHOrderDetailController.h"
#import "UHBannerHtmlWebController.h"
#import "UHLivingBroadcastFromBannerController.h"
#import "UHPsychologicalAssessmentController.h"
#import "UHChronicDiseaseManageMentController.h"
#import "UHReservationServiceController.h"
#import "DiseaseMatchViewController.h"
#import "UHConsultController.h"
#import "UHMoreLecturesController.h"
#import "UHHealthNewsMainController.h"
#import "UHArchivesController.h"
#import "UHAuthorityChannelController.h"
#import "UHMentalManageController.h"
#import "UHCabinController.h"
#import "UHAuthorityCenterController.h"
#import "UHGreenPathController.h"
@interface UHHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
//标题
@property (nonatomic,strong) UILabel *titleLabel;
//banner数据
@property (nonatomic,strong) NSMutableArray *bannerArray;
@property (nonatomic,strong) NSMutableArray *bannerModelArray;
@property (nonatomic,strong) NSMutableArray *dynamicDatas;
//优医动态资讯数据
@property (nonatomic,strong) NSMutableArray *newsDatas;
@property (nonatomic, assign) CGFloat scrollOffsetY;
@end

@implementation UHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
    [self initData];
}

- (void)initAll {
    self.view.backgroundColor = KControlColor;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(KIsiPhoneX?-88:-64, 0, 0, 0));
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"优医家";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:ZPPFSCMedium size:17];
    self.navigationItem.titleView = titleLabel;
    self.titleLabel = titleLabel;
}

- (void)initData {
    [self getAppVersion];
    [self getHeadBanner];
    [self getHealthDynamic];
    WEAK_SELF(weakSelf);
    __unsafe_unretained UITableView *tableView = self.tableView;
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
         [weakSelf getHotHealthInformation:YES];
    }];
    //监听RegistrationID
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadRegistrationID) name:kJPFNetworkDidLoginNotification object:nil];
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        UHUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
        if (![model.welcomeMessage isKindOfClass:[NSNull class]]) {
            if (model.companyName.length  &&  model.welcomeMessage.length && (![kUSER_DEFAULT objectForKey:model.ID] || [kUSER_DEFAULT objectForKey:model.ID] == NO)) {
                [self popImgWithUrl:model.welcomeMessage];
                //保存个人id为Yes 说明弹过了
                [kUSER_DEFAULT setBool:YES forKey:model.ID];
                [kUSER_DEFAULT synchronize];
            }
        }
        if (model.companyName && model.companyName.length) {
            WEAK_SELF(weakSelf);
            [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"cabin/detail" parameters:nil progress:^(NSProgress *progress) {
                
            } success:^(NSURLSessionDataTask *task, id response) {
                if ([[response objectForKey:@"code"] integerValue]  == 200) {
                    UHCabinDetailModel *cabinDetailModel = [UHCabinDetailModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
                    UHCabinController *cabinControl = [[UHCabinController alloc] init];
                    cabinControl.model = cabinDetailModel;
                    cabinControl.title = cabinDetailModel.healthCabinName;
                    [weakSelf.navigationController pushViewController:cabinControl animated:YES];
                } 
            } failed:^(NSURLSessionDataTask *task, NSError *error) {
                [MBProgressHUD showError:error.localizedDescription];
            } className:[UHHomeViewController class]];
        }
    }
}

#pragma mark - -私有方法
//获取banner
- (void)getHeadBanner {
    ZPLog(@"getHeadBanner");
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"banner" parameters:@{@"position":@"HEAD",@"launchPlatform":@"IOS"} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        ZPLog(@"获取banner:%@",response);
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            [weakSelf.bannerArray removeAllObjects];
            weakSelf.bannerModelArray = [UHBannerModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            for (UHBannerModel *model in weakSelf.bannerModelArray) {
                [weakSelf.bannerArray addObject:model.banner];
            }
            [weakSelf.tableView reloadData];
        } else {
            
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        ZPLog(@"error:%@",error);
    } className:[UHHomeViewController class]];
}

//获取优医动态 标题
- (void)getHealthDynamic {
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"dynamic" parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            weakSelf.dynamicDatas = [UHHealthDynamicModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } className:[UHHomeViewController class]];
}

//获取优医动态 资讯列表
- (void)getHotHealthInformation:(BOOL)isFootRefresh {
    WEAK_SELF(weakSelf);
    __unsafe_unretained UITableView *tableView = self.tableView;
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"healthDirection/list" parameters:@{@"offset":[NSNumber numberWithInteger:self.newsDatas.count],@"position":@"HOMEPAGE"} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        // 结束刷新
        if (isFootRefresh) {
            [tableView.mj_footer endRefreshing];
        }
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            NSArray *arrays = [UHHealthWindModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            if (!arrays.count) {
                [tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.newsDatas addObjectsFromArray:arrays];
                [tableView reloadData];
            }
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        // 结束刷新
        if (isFootRefresh) {
             [tableView.mj_footer endRefreshing];
        }
       
        [MBProgressHUD showError:error.localizedDescription];
    } className:[UHHomeViewController class]];
}

//弹出欢迎图片
- (void)popImgWithUrl:(NSString *)urlStr {
    UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IS_IPHONE5?280:ZPWidth(280), 381)];
    
    //435
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 0, IS_IPHONE5?276:ZPWidth(276), 350)];
    [iconView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [temp addSubview:iconView];
    
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 350, 31, 31)];
    [closeBtn setImage:[UIImage imageNamed:@"close_pop_icon"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [temp addSubview:closeBtn];
    
    closeBtn.sd_layout
    .centerXEqualToView(iconView);
    
    [LEEAlert alert].config
    .LeeAddCustomView(^(LEECustomView *custom) {
        custom.view = temp;
        custom.positionType = LEECustomViewPositionTypeCenter;
    })
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeBackGroundColor([UIColor clearColor])
    .LeeHeaderColor([UIColor clearColor])
    .LeeOpenAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
        
        [UIView animateWithDuration:1.0f delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            animatingBlock(); //调用动画中Block
            
        } completion:^(BOOL finished) {
            
            animatedBlock(); //调用动画结束Block
        }];
        
    })
    .LeeCloseAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
        
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            animatingBlock();
            
        } completion:^(BOOL finished) {
            
            animatedBlock();
        }];
        
    })
    .LeeConfigMaxWidth(^CGFloat (LEEScreenOrientationType type) {
        if (IS_IPHONE5) {
            return 280;
        }
        return ZPWidth(280);
    })
    .LeeClickBackgroundClose(YES)
    .LeeShow();
}


//判断app是否需要更新
- (void)getAppVersion {
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"version" parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            //            float data = [[response objectForKey:@"data"] floatValue];
            NSString *data = [NSString stringWithFormat:@"%@",[[response objectForKey:@"data"] objectForKey:@"versionCode"]];
            ZPLog(@"服务器版本号:%@  app版本号:%@ ",data,PRODUCT_VERSION);
            //[PRODUCT_VERSION floatValue] < data
            NSString *pV = [NSString stringWithFormat:@"%@",PRODUCT_VERSION];
            if ([pV compare:data options:NSNumericSearch] == NSOrderedAscending) {
                [LEEAlert alert].config
                .LeeTitle(@"提醒")
                .LeeContent(@"App有新的版本可以下载,前去下载")
                .LeeCancelAction(@"取消", ^{
                    
                })
                .LeeAction(@"确认", ^{
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:AppStoreUrl]];
                    [[UIApplication sharedApplication] openURL:url];
                })
                .LeeClickBackgroundClose(YES)
                .LeeShow();
            }
        } else {
            
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } className:[UHHomeViewController class]];
}

//获取未读消息
- (void)getUnreadMessage {
    __weak typeof(self) weakSelf = self;
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"message/message" parameters:@{@"messageStatus":@"UNREAD"} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            NSInteger num = [[[response objectForKey:@"pageInfo"] objectForKey:@"totalCount"] integerValue];
            [weakSelf.navigationItem.rightBarButtonItem showBadgeWithStyle:WBadgeStyleNumber value:num animationType:WBadgeAnimTypeNone];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } className:[UHHomeViewController class]];
}

//上传jpush的registrationID
- (void)uploadJPushID {
    WEAK_SELF(weakSelf);
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        ZPLog(@"------>registrationID: %@",[JPUSHService registrationID]);
        //上传极光registrationID给服务器
        [weakSelf uploadRegistrationID];
    }];
}

- (void)uploadRegistrationID {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH] && [JPUSHService registrationID]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/message/jpush/information",ZPBaseUrl]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        request.HTTPMethod = @"PUT";
        
        request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};//此处为请求头，类型为字典
        NSDictionary *msg = @{@"registrationId":[JPUSHService registrationID]};
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:msg options:NSJSONWritingPrettyPrinted error:nil];
        
        request.HTTPBody = data;
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            ZPLog(@"%@ --------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil) {
                    NSDictionary *dict = [data mj_JSONObject];
                    if ([[dict objectForKey:@"code"] integerValue]  == 200) {
                        ZPLog(@"上传极光registrationID:%@给服务器成功",[JPUSHService registrationID]);
                        [kUSER_DEFAULT setValue:[JPUSHService registrationID] forKey:@"registrationID"];
                        [kUSER_DEFAULT synchronize];
                    } else if ([[dict objectForKey:@"code"] integerValue]  == 401){
                        //未登录页面
                        [self logout];
                    } else if ([[dict objectForKey:@"code"] integerValue]  == 402){
                        //清除登录信息
                        [self clearLoginInfo];
                        [LEEAlert alert].config
                        .LeeContent([dict objectForKey:@"message"])
                        .LeeAction(@"确认", ^{
                            UHLoginController *loginControl = [[UHLoginController alloc] init];
                            UHNavigationController *nav = [[UHNavigationController alloc] initWithRootViewController:loginControl];
                            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                        })
                        .LeeShow();
                        
                    } else {
                        [MBProgressHUD showError:[dict objectForKey:@"message"]];
                    }
                } else {
                    [MBProgressHUD showError:error.localizedDescription];
                }
            });
            
        }] resume];
    }
}

//退出登录
- (void)logout {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        [[NSFileManager defaultManager] removeItemAtPath:ZPUserInfoPATH error:nil];
    }
    if ([[kUSER_DEFAULT objectForKey:@"_IDENTIY_KEY_"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"_IDENTIY_KEY_"];
        [kUSER_DEFAULT synchronize];
        NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookiesArray) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    if ([[kUSER_DEFAULT objectForKey:@"stepsUpdateTime"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"stepsUpdateTime"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"lectureToken"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"lectureToken"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"accId"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"accId"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"token"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"token"];
        [kUSER_DEFAULT synchronize];
    }
    [ZPNetWorkManager destroyInstance];
    UHLoginController *loginControl = [[UHLoginController alloc] init];
    UHNavigationController *nav = [[UHNavigationController alloc] initWithRootViewController:loginControl];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}

//清除登录信息
- (void)clearLoginInfo {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        [[NSFileManager defaultManager] removeItemAtPath:ZPUserInfoPATH error:nil];
    }
    if ([[kUSER_DEFAULT objectForKey:@"_IDENTIY_KEY_"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"_IDENTIY_KEY_"];
        [kUSER_DEFAULT synchronize];
        NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookiesArray) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    if ([[kUSER_DEFAULT objectForKey:@"stepsUpdateTime"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"stepsUpdateTime"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"lectureToken"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"lectureToken"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"accId"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"accId"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"token"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"token"];
        [kUSER_DEFAULT synchronize];
    }
    [ZPNetWorkManager destroyInstance];
}

#pragma mark - -跳转页面
//跳转->消息列表
- (void)chatInfoList {
    SessionListViewController *chatList = [[SessionListViewController alloc] init];
    [self.navigationController pushViewController:chatList animated:YES];
}

//跳转-banner点击跳转处理
- (void)handleBannerClick:(NSInteger)index {
    /*
     bannerType的类型
     UHEALTH_DIRECTION     健康风向
     UHEALTH_INFORMATION   健康资讯
     COMMONDITY            商品
     LINK                  链接
     null                  单纯图片
     */
    UHBannerModel *model = self.bannerModelArray[index];
    if ([model.bannerType.name isEqualToString:@"UHEALTH_INFORMATION"]) {
        
        UHHealthNewsWebViewController *webView = [[UHHealthNewsWebViewController alloc] init];
        webView.mainBody = [NSString stringWithFormat:@"%@/#/healthyCounseling/detailIos?id=%@",ZPBaseUrl,model.bannerAim];
        ZPLog(@"跳转资讯文章ID:%@",webView.mainBody);
        UHHealthNewsModel *healthNewsModel = [[UHHealthNewsModel alloc] init];
        healthNewsModel.informationId = model.bannerAim;;
        webView.healthNewsModel = healthNewsModel;
        webView.bannerAim = model.bannerAim;
        webView.enterStatusType = ZPHealthEnterStatusTypeBanner;
        [self.navigationController pushViewController:webView animated:YES];
    } else if ([model.bannerType.name isEqualToString:@"UHEALTH_DIRECTION"]) {
        UHHealthWindWebViewController *windWebViewControl = [[UHHealthWindWebViewController alloc] init];
        windWebViewControl.urlStr = [NSString stringWithFormat:@"%@/#/healthyWindDirection/windDetailIos?id=%@",ZPBaseUrl,model.bannerAim];
        ZPLog(@"跳转风向文章ID:%@",windWebViewControl.urlStr);
        UHHealthWindModel *windModel =  [[UHHealthWindModel alloc] init];
        windModel.directionId = model.bannerAim;;
        windWebViewControl.windModel = windModel;
        windWebViewControl.bannerAim = model.bannerAim;
        windWebViewControl.enterStatusType = ZPWindEnterStatusTypeBanner;
        [self.navigationController pushViewController:windWebViewControl animated:YES];
    } else if ([model.bannerType.name isEqualToString:@"COMMONDITY"]) {
        ZPLog(@"跳转商品ID:%@",model.bannerAim);
        UHOrderDetailController *orderDetailControl = [[UHOrderDetailController alloc] init];
        UHCommodity *commodity = [[UHCommodity alloc] init];
        commodity.commodityId = [model.bannerAim integerValue];
        orderDetailControl.commodity = commodity;
        orderDetailControl.enterStatusType = ZPOrderEnterStatusTypeBanner;
        [self.navigationController pushViewController:orderDetailControl animated:YES];
    } else if ([model.bannerType.name isEqualToString:@"LINK"]) {
        ZPLog(@"跳转链接:%@",model.bannerAim);
        UHBannerHtmlWebController *htmlWebControl = [[UHBannerHtmlWebController alloc]init];
        
        htmlWebControl.url = model.bannerAim;
        htmlWebControl.titleString = model.bannerName;
        [self.navigationController pushViewController:htmlWebControl animated:YES];
    } else if ([model.bannerType.name isEqualToString:@"LONG_IMAGE"]) {
        ZPLog(@"跳转长图:%@",[NSString stringWithFormat:@"%@/ios/html/index.html?id=%@&type=HOMEDETAIL",ZPBaseUrl,model.ID]);
        UHBannerHtmlWebController *htmlWebControl = [[UHBannerHtmlWebController alloc]init];
        
        htmlWebControl.url = [NSString stringWithFormat:@"%@/ios/html/index.html?id=%@&type=HOMEDETAIL",ZPBaseUrl,model.ID];
        htmlWebControl.titleString = model.bannerName;
        [self.navigationController pushViewController:htmlWebControl animated:YES];
    } else if ([model.bannerType.name isEqualToString:@"LECTURE_ROOM"]) {
        UHLivingBroadcastFromBannerController *livinglectureControl = [[UHLivingBroadcastFromBannerController alloc] init];
        livinglectureControl.ID = model.bannerAim;
        [self.navigationController pushViewController:livinglectureControl animated:YES];
    }
}

//跳转->心理测评
- (void)chronicDiseaseManageAction {
    [MBProgressHUD showMessage:@"加载中..."];
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"psychologicalAssessment/register" parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        [MBProgressHUD hideHUD];
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            UHPsyAssessmentModel *psyModel = [UHPsyAssessmentModel mj_objectWithKeyValues:[response objectForKey:@"data"] ];
            if (psyModel.infoFilled) {
                //信息已填
                UHMentalManageController *mentalManageControl = [[UHMentalManageController alloc] init];
                mentalManageControl.titleStr = @"身心健康评估";
                mentalManageControl.urlStr = psyModel.ticketEntry;
                mentalManageControl.infoFilled = YES;
                [weakSelf.navigationController pushViewController:mentalManageControl animated:YES];
            } else {
                UHPsychologicalAssessmentController *psyControl = [[UHPsychologicalAssessmentController alloc] init];
                psyControl.psyModel = psyModel;
                [weakSelf.navigationController pushViewController:psyControl animated:YES];
            }
        } else {
            
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:error.localizedDescription];
    } className:[UHHomeViewController class]];
}

//跳转->生理测评
- (void)phyAction {
    UHChronicDiseaseManageMentController *chronicDisControl = [[UHChronicDiseaseManageMentController alloc] init];
    [self.navigationController pushViewController:chronicDisControl animated:YES];
}

//跳转->功能点击处理
- (void)functionDidClickAction:(NSInteger)tag {
    switch (tag) {
        case 10001:
        {
            //绿色通道
//            UHReservationServiceController *reservationControl = [[UHReservationServiceController alloc] init];
//            [self.navigationController pushViewController:reservationControl animated:YES];
            UHGreenPathController *greenPathControl = [[UHGreenPathController alloc] init];
            [self.navigationController pushViewController:greenPathControl animated:YES];
        }
            break;
        case 10002:
        {
            //症状自查
            [MBProgressHUD showMessage:@"加载中..."];
            [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"selftest" parameters:nil progress:^(NSProgress *progress) {

            } success:^(NSURLSessionDataTask *task, id response) {
                [MBProgressHUD hideHUD];
                if ([[response objectForKey:@"code"] integerValue]  == 200) {
                    NSBundle *bundle = [NSBundle bundleForClass:[DiseaseMatchViewController class]];
                    DiseaseMatchViewController *vc = [[DiseaseMatchViewController alloc] initWithNibName:@"DiseaseMatchViewController" bundle:bundle];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    [MBProgressHUD showError:[response objectForKey:@"message"]];
                }
            } failed:^(NSURLSessionDataTask *task, NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:error.localizedDescription];
            } className:[UHHomeViewController class]];
        }
            break;
        case 10003:
        {
            //身心咨询
            UHConsultController *consultControl = [[UHConsultController alloc] init];
            [self.navigationController pushViewController:consultControl animated:YES];
        }
            break;
        case 10004:
        {
            //在线讲堂
            UHMoreLecturesController *alllectureControl = [[UHMoreLecturesController alloc] init];
            alllectureControl.allLecture = YES;
            [self.navigationController pushViewController:alllectureControl animated:YES];
        }
            break;
        case 10005:
        {
            //我的档案
            UHArchivesController *archivesControl = [[UHArchivesController alloc] init];
            [self.navigationController pushViewController:archivesControl animated:YES];
        }
            break;
        case 10006:
        {
            //健康资讯
            UHHealthNewsMainController *healthNewsMainControl = [[UHHealthNewsMainController alloc] init];
            [self.navigationController pushViewController:healthNewsMainControl animated:YES];
        }
            break;
        case 10007:
        {
            //个人保障
            [self showDevelopTip];
        }
            break;
        case 10008:
        {
            //救援服务
            [self showDevelopTip];
        }
            break;
        case 10009:
        {
            //家人服务
            [self showDevelopTip];
        }
            break;
        case 10010:
        {
            //企业福利
            [self showDevelopTip];
        }
            break;
            
        default:
            break;
    }
}

//跳转->中心模块
- (void)centerDidClickAction:(NSInteger)tag {
    switch (tag) {
        case 10001:
        {
            //微生态中心
            UHAuthorityCenterController *authorityCenterControl = [[UHAuthorityCenterController alloc] init];
            UHAdvisoryChannelModel *model = [[UHAdvisoryChannelModel alloc] init];;
            model.ID = @"1";
            UHCommonEnumType *type = [[UHCommonEnumType alloc] init];
            type.text = @"微生态中心";
            model.channelType = type;
            authorityCenterControl.channelModel = model;
            [self.navigationController pushViewController:authorityCenterControl animated:YES];
        }
            break;
        case 10002:
        {
            //颈椎调理中心
            [self showDevelopTip];
        }
            break;
        case 10003:
        {
            //中医养生中心
            [self showDevelopTip];
        }
            break;
            
        default:
            break;
    }
}

//跳转->优医动态
- (void)handleDynamicArticle:(NSInteger)index {
    UHHealthDynamicModel *model = self.dynamicDatas[index];
    if ([model.articleSort.name isEqualToString:@"HEALTH_DIRECTION"]) {
        //风向
        UHHealthWindWebViewController *windWebViewControl = [[UHHealthWindWebViewController alloc] init];
        windWebViewControl.urlStr = [NSString stringWithFormat:@"%@/#/healthyWindDirection/windDetailIos?id=%@",ZPBaseUrl,model.articleId];
        ZPLog(@"跳转风向文章ID:%@",windWebViewControl.urlStr);
        UHHealthWindModel *windModel =  [[UHHealthWindModel alloc] init];
        windModel.directionId = model.articleId;;
        windWebViewControl.windModel = windModel;
        windWebViewControl.bannerAim = model.articleId;
        windWebViewControl.enterStatusType = ZPWindEnterStatusTypeBanner;
        [self.navigationController pushViewController:windWebViewControl animated:YES];
    } else if ([model.articleSort.name isEqualToString:@"HEALTH_INFORMATION"]) {
        //资讯
        UHHealthNewsWebViewController *webView = [[UHHealthNewsWebViewController alloc] init];
        webView.mainBody = [NSString stringWithFormat:@"%@/#/healthyCounseling/detailIos?id=%@",ZPBaseUrl,model.articleId];
        ZPLog(@"跳转资讯文章ID:%@",webView.mainBody);
        UHHealthNewsModel *healthNewsModel = [[UHHealthNewsModel alloc] init];
        healthNewsModel.informationId = model.articleId;;
        webView.healthNewsModel = healthNewsModel;
        webView.bannerAim = model.articleId;
        webView.enterStatusType = ZPHealthEnterStatusTypeBanner;
        [self.navigationController pushViewController:webView animated:YES];
    }
}

//展示 开发中 提示
- (void)showDevelopTip {
    [LEEAlert alert].config
    .LeeTitle(@"提醒")
    .LeeContent(@"该模块正在开发中，敬请期待")
    .LeeAction(@"确认", ^{
    })
    .LeeClickBackgroundClose(YES)
    .LeeShow();
}

//关闭弹窗
- (void)closePop {
    [LEEAlert closeWithCompletionBlock:nil];
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
        return 2;
    } else if (section == 2) {
        return self.newsDatas.count+1;
    }
    return 1;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF(weakSelf);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UHHomeCycleHeadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHHomeCycleHeadViewCell class])];
            cell.data = self.bannerArray;
            cell.bannerImgClickBlock = ^(NSInteger index) {
                //首页banner点击处理
                [weakSelf handleBannerClick:index];
            };
            cell.psyClickBlock = ^{
                //心理测评
                [weakSelf chronicDiseaseManageAction];
            };
            cell.phyClickBlock = ^{
                //生理测评
                [weakSelf phyAction];
            };
            return cell;
        }
        UHHomeFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHHomeFunctionCell class])];
        cell.didClickBlock = ^(NSInteger tag) {
           //功能 点击处理
            [weakSelf functionDidClickAction:tag];
        };
        return cell;
    } else if (indexPath.section == 1) {
        UHHomeCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHHomeCenterCell class])];
        cell.didClickBlock = ^(NSInteger tag) {
            //中心 跳转处理
            [weakSelf centerDidClickAction:tag];
        };
        return cell;
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UHHomeMarqueeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHHomeMarqueeCell class])];
            cell.data = self.dynamicDatas;
            cell.didClickBlock = ^(NSInteger index) {
                //优医 跳转文章
                [weakSelf handleDynamicArticle:index];
            };
            return cell;
        }
    }
    UHHealthWindModel *model = self.newsDatas[indexPath.row-1];
    if (model.titleImgList.count == 1) {
        UHHealthWindOneImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHHealthWindOneImageCell class])];
        cell.model = model;
        return cell;
    }
    UHHealthWindCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHHealthWindCell class])];
    cell.model = model;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return ZPHeight(258+15);
        }
        return ZPHeight(161);
    } else if (indexPath.section == 1) {
    return ZPHeight(129);
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
             return ZPHeight(40);
        }
    }
    UHHealthWindModel *model = self.newsDatas[indexPath.row-1];
    if (model.titleImgList.count==1) {
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[UHHealthWindOneImageCell class] contentViewWidth:SCREEN_WIDTH];
    }
    
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[UHHealthWindCell class] contentViewWidth:SCREEN_WIDTH];
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
    return 10.f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 && indexPath.row >0) {
        UHHealthWindModel *model = self.newsDatas[indexPath.row-1];
        UHHealthWindWebViewController *windWebViewControl = [[UHHealthWindWebViewController alloc] init];
        windWebViewControl.urlStr = [NSString stringWithFormat:@"%@/#/healthyWindDirection/windDetailIos?id=%@",ZPBaseUrl,model.directionId];
        windWebViewControl.windModel = model;
        [self.navigationController pushViewController:windWebViewControl animated:YES];
    }
}

#pragma mark - 导航栏设置
- (void)changeNavigationBarStyleWhenScroll:(CGFloat)offsetY {
    CGFloat alpha = offsetY / 100.0;
    if (alpha < 0.3) {
        self.titleLabel.text = @"";
    } else {
        self.titleLabel.text = @"优医家";
    }
    self.navigationController.navigationBar.translucent = alpha <1 ?YES:NO;
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[self setBGGradientColors:@[RGBA(78, 178, 255,alpha >= 0 ? alpha : 0),RGBA(99,205,255,alpha >= 0 ? alpha : 0)]] forBarMetrics:UIBarMetricsDefault];
    if (alpha >= 1) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem zp_barButtonItemWithTarget:self action:@selector(chatInfoList) icon:@"index_noti_icon" highlighticon:@"index_noti_icon" backgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(30, 30)]];
    } else if (alpha >= 0) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem zp_barButtonItemWithTarget:self action:@selector(chatInfoList) icon:@"index_noti_icon" highlighticon:@"index_noti_icon" backgroundImage:self.itemBackgroundImage];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (UIImage *)itemBackgroundImage {
    return [[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.3] size:CGSizeMake(30, 30)] zp_cornerImageWithSize:CGSizeMake(30, 30) fillColor:[UIColor clearColor]];
}

//绘制对象背景的渐变色特效
- (UIImage *)setBGGradientColors:(NSArray<UIColor *> *)colors {
    if (colors.count > 1) {
        //有多种颜色，需要渐变层对象来上色
        //创建渐变层对象
        CGRect rect=CGRectMake(0,0, 1, 1);
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        //设置渐变层的frame等同于按钮的frame（这里高度有个小误差，补上就可以了）
        gradientLayer.frame = rect;
        //将存储的渐变色数组（UIColor类）转变为CAGradientLayer对象的colors数组，并设置该数组为CAGradientLayer对象的colors属性
        NSMutableArray *gradientColors = [NSMutableArray array];
        for (UIColor *colorItem in colors) {
            [gradientColors addObject:(id)colorItem.CGColor];
        }
        gradientLayer.colors = [NSArray arrayWithArray:gradientColors];
        //下一步需要将CAGradientLayer对象绘制到一个UIImage对象上，以便使用这个UIImage对象来填充按钮的背景色
        UIImage *gradientImage = [self imageFromLayer:gradientLayer];
        //使用UIColor的如下方法，将字体颜色设为gradientImage模式，这样就可以将渐变色填充到背景色上了，同理可以设置按钮各状态的不同显示效果
        return gradientImage;
    }
    return nil;
}

//将一个CALayer对象绘制到一个UIImage对象上，并返回这个UIImage对象
- (UIImage *)imageFromLayer:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.opaque, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    self.scrollOffsetY = offsetY;
    [self changeNavigationBarStyleWhenScroll:offsetY];
}

#pragma mark - -界面的消失与出现
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeNavigationBarStyleWhenScroll:self.scrollOffsetY];
    [self getHotHealthInformation:NO];
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        [self getUnreadMessage];
        if (![kUSER_DEFAULT objectForKey:@"registrationID"]) {
            [self uploadJPushID];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[self setBGGradientColors:@[RGBA(78, 178, 255,1),RGBA(99,205,255,1)]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self changeNavigationBarStyleWhenScroll:self.scrollOffsetY];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = KControlColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UHHomeCenterCell class] forCellReuseIdentifier:NSStringFromClass([UHHomeCenterCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UHHomeFunctionCell class] forCellReuseIdentifier:NSStringFromClass([UHHomeFunctionCell class])];
        [_tableView registerClass:[UHHomeMarqueeCell class] forCellReuseIdentifier:NSStringFromClass([UHHomeMarqueeCell class])];
        [_tableView registerClass:[UHHealthWindCell class] forCellReuseIdentifier:NSStringFromClass([UHHealthWindCell class])];
        [_tableView registerClass:[UHHealthWindOneImageCell class] forCellReuseIdentifier:NSStringFromClass([UHHealthWindOneImageCell class])];
        [_tableView registerClass:[UHHomeCycleHeadViewCell class] forCellReuseIdentifier:NSStringFromClass([UHHomeCycleHeadViewCell class])];
    }
    return _tableView;
}

- (NSMutableArray *)bannerArray {
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (NSMutableArray *)bannerModelArray {
    if (!_bannerModelArray) {
        _bannerModelArray = [NSMutableArray array];
    }
    return _bannerModelArray;
}

- (NSMutableArray *)newsDatas {
    if (!_newsDatas) {
        _newsDatas = [NSMutableArray array];
    }
    return _newsDatas;
}

- (NSMutableArray *)dynamicDatas {
    if (!_dynamicDatas) {
        _dynamicDatas = [NSMutableArray array];
    }
    return _dynamicDatas;
}
@end
