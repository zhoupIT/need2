//
//  AppDelegate+AppService.m
//  EasyTrade
//
//  Created by Rohon on 2017/12/1.
//  Copyright © 2017年 Rohon. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "UHTabBarViewController.h"
#import "IQKeyboardManager.h"
#import "UHLoginController.h"
#import "Reachability.h"
#import "EBBannerView.h"
#import "UHNavigationController.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import "WXApi.h"
#import "WXApiManager.h"
#import "UHWelcomeController.h"
#import <Bugly/Bugly.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UHMyFileDetailController.h"
#import <AlipaySDK/AlipaySDK.h>
#import <UMShare/UMShare.h>
@implementation AppDelegate (AppService)
#pragma mark ————— 初始化服务 —————
-(void)initService{
    //键盘处理
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //右滑返回手势
    
    //UM
    [UMConfigure initWithAppkey:UMKey channel:@"App Store"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXPayKey appSecret:UMAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    
    [WXApi registerApp:WXPayKey];
    
    //bugly
    [Bugly startWithAppId:BuglyAppId];
    
    //设置HUD全局外观
    [self setupHUDGlobalAppearce];

}


#pragma mark ————— 初始化window —————
-(void)initWindow{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self initRootView];
    [self.window makeKeyAndVisible];
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)initRootView {
    if (![kUSER_DEFAULT boolForKey:@"FirstRun"]) {
        //如果是第一次运行就添加BOOL并赋值
        [kUSER_DEFAULT setBool:YES forKey:@"FirstRun"];
        
        //图片数据
        NSArray *images = @[@"1",@"2",@"3",@"4"];
        //初始化控制器
        UHWelcomeController *welcomeVC =[[UHWelcomeController alloc]initWelcomeView:images firstVC:[[UHTabBarViewController alloc]init]];
        //添加根控制器
        self.window.rootViewController = welcomeVC;
    }else{
        UHTabBarViewController *tabbar = [[UHTabBarViewController alloc] init];
        self.window.rootViewController = tabbar;
    }
}

#pragma mark ————— 初始化用户系统 —————
-(void)initUserManager{
    
}

#pragma mark ————— 登录状态处理 —————
- (void)loginStateChange:(NSNotification *)notification
{
   
}


#pragma mark ————— 网络状态变化 —————
- (void)netWorkStateChange:(NSNotification *)notification
{
    Reachability* curReach = [notification object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}


#pragma mark ————— 友盟 初始化 —————
-(void)initUMeng{
   
    /* 设置友盟appkey */
  
}

#pragma mark ————— bugly 初始化 —————
-(void)initBugly{
    
    /* 设置Bugly appkey */
    
}

#pragma mark ————— 网络状态监听 —————
- (void)monitorNetworkStatus
{
    // 设置网络状态变化时的通知函数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChange:)
                                                 name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bannerDidClick:) name:EBBannerViewDidClickNotification object:nil];
    
}

#pragma mark ————— 通知监听 —————
- (void)bannerDidClick:(NSNotification*)noti {
    ZPLog(@"通知:%@",noti.object);
    NSDictionary *dict = noti.object;
    if ([dict[@"messageType"] isEqualToString:@"BODY_CHECK_SYSTEM_NOTICE"]) {
//        ZPNavigationController *_nav = (ZPNavigationController*) (self.window.rootViewController);
        UHTabBarViewController *tabVC = (UHTabBarViewController *)self.window.rootViewController;
        UHNavigationController *pushClassStance = (UHNavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
        UHMyFileDetailController *_vc = [[UHMyFileDetailController alloc]init];
        _vc.ID = dict[@"extraParam"];
        [pushClassStance pushViewController:_vc animated:YES];
    }
   
}

- (void)monitorNotificationWithOptions:(NSDictionary *)launchOptions {
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
//
//    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
     [JPUSHService setupWithOption:launchOptions appKey:JpushAppKey channel:@"app store" apsForProduction:YES];
    
    // 如果 launchOptions 不为空
    if (launchOptions) {
        if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
            //收到通知跳转
            NSDictionary * dict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            if ([dict[@"messageType"] isEqualToString:@"BODY_CHECK_SYSTEM_NOTICE"]) {
                //        ZPNavigationController *_nav = (ZPNavigationController*) (self.window.rootViewController);
                UHTabBarViewController *tabVC = (UHTabBarViewController *)self.window.rootViewController;
                UHNavigationController *pushClassStance = (UHNavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
                UHMyFileDetailController *_vc = [[UHMyFileDetailController alloc]init];
                _vc.ID = dict[@"extraParam"];
                [pushClassStance pushViewController:_vc animated:YES];
            }
        }
    }
    
}



//网络状态
- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        switch (netStatus)
        {
            case NotReachable:      {
                [ZPNotfication showNotificationWithMessage:@"没有网络！" completionBlock:nil];
                NSLog(@"没有网络！");
                break;
            }
            case ReachableViaWWAN:  {
                NSLog(@"4G/3G");
                break;
            }
            case ReachableViaWiFi:  {
                NSLog(@"WiFi");
                break;
            }
        }
}

- (void)setupHUDGlobalAppearce
{
    // configure hub view
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor darkGrayColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    [SVProgressHUD setMinimumSize:CGSizeMake(88.0, 66.0)];
}

+ (AppDelegate *)sharedAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


-(UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    ZPLog(@"收到本地通知 %@",notification);
    // 可以让用户跳转到指定界面 app在前台接收到通知直接跳转界面不太好,所以要判断一下,是从后台进入前台还是本身就在前台
    if (application.applicationState == UIApplicationStateInactive) {// 进入前台时候
        ZPLog(@"跳转到指定界面");
         [EBBannerView showWithContent:notification.alertBody];
        // 如果接收到不同的通知,跳转到不同的界面:
        ZPLog(@"%@", notification.userInfo); //通知的额外信息,根据设置的通知的额外信息确定
        
    } else if (application.applicationState == UIApplicationStateActive) {
        [EBBannerView showWithContent:notification.alertBody];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    NSString *alertStr = userInfo[@"aps"][@"alert"];
    if (alertStr != nil && ![alertStr isEqualToString:@""]) {
//        [EBBannerView showWithContent:userInfo[@"aps"][@"alert"]];
        EBBannerView *banner = [EBBannerView bannerWithBlock:^(EBBannerViewMaker *make) {
            make.content = userInfo[@"aps"][@"alert"];
            make.object = userInfo;
        }];
        [banner show];
    } else if (notification.request.content.body != nil) {
        [EBBannerView showWithContent:notification.request.content.body];
        
    }
    //         completionHandler(UNNotificationPresentationOptionSound); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
   
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            ZPLog(@"支付宝支付结果result = %@",resultDic);
            if ([resultDic[@"result"] length]) {
              NSDictionary *returnDic = [self stringToDictionaryWithString:resultDic[@"result"]];
                ZPLog(@"解析结果 result = %@",returnDic);
                NSString *out_trade_no = returnDic[@"alipay_trade_app_pay_response"][@"out_trade_no"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAliPayResp object:out_trade_no];
            } else {
                ZPLog(@"解析结果是result = %@",resultDic[@"memo"]);
                [MBProgressHUD showError:resultDic[@"memo"]];
            }
            
        }];
    } else if ([url.host isEqualToString:@"pay"]) {
        //微信支付
         return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    } else if ([url.absoluteString containsString:@"wx"] && [url.host isEqualToString:@"oauth"]) {
        //微信登录
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return [[UMSocialManager defaultManager] handleOpenURL:url];;
   
}


- (NSDictionary *)stringToDictionaryWithString:(NSString *)string {
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = nil;
    
    if (!data) return nil;
    
    dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    
    return dict;
}

@end
