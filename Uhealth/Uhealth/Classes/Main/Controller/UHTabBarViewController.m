//
//  RHTabBarViewController.m
//  Peng Zhou
//
//  Created by 鹏 周 on 2017/8/28.
//  Copyright © 2017年 Peng Zhou. All rights reserved.
//

#import "UHTabBarViewController.h"
#import "UHNavigationController.h"
#import "UHViewController.h"
#import "UHPreferMallController.h"
#import "UHUserController.h"
#import "UHTabBar.h"
#import "UHLoginController.h"
#import "UHHomeViewController.h"
@interface UHTabBarViewController ()<UITabBarControllerDelegate>
@property (nonatomic,strong) UHTabBar *uhtabbar;
@end

@implementation UHTabBarViewController

+ (void)initialize {
    NSDictionary *norAttr = @{
                              NSForegroundColorAttributeName : KTbarColor
                              };
    NSDictionary *selAttr = @{
                              NSForegroundColorAttributeName : KCommonBlue
                              };
    [[UITabBarItem appearance] setTitleTextAttributes:norAttr forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:selAttr forState:UIControlStateSelected];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    //设置不透明
    [[UITabBar appearance] setTranslucent:NO];
    
    //去除tabbar上的黑线
    [UITabBar appearance].backgroundImage = [UIImage new];
    [UITabBar appearance].shadowImage = [UIImage new];
}



- (void)viewDidLoad {
    [super viewDidLoad];
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:kNotificationNeedSignIn object:nil];
    
//    _uhtabbar = [[UHTabBar alloc] init];
//    [_uhtabbar.centerBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    //选中时的颜色
//    _uhtabbar.tintColor = [UIColor colorWithRed:27.0/255.0 green:118.0/255.0 blue:208/255.0 alpha:1];
//    //透明设置为NO，显示白色，view的高度到tabbar顶部截止，YES的话到底部
//    _uhtabbar.translucent = NO;
//    //利用KVC 将自己的tabbar赋给系统tabBar
//    [self setValue:_uhtabbar forKeyPath:@"tabBar"];
    
    self.delegate = self;
    UHHomeViewController *view1 = [[UHHomeViewController alloc] init];
    UHPreferMallController *view2 = [[UHPreferMallController alloc] init];
    UHUserController *view3 = [[UHUserController alloc] init];

    [self addChildVC:view1 title:@"首页" image:@"index" selImage:@"index_sel"];
    [self addChildVC:view2 title:@"优选" image:@"prefer" selImage:@"prefer"];
    [self addChildVC:view3 title:@"我的" image:@"me" selImage:@"me_sel"];

    
    self.selectedIndex = 0;
    
//    UITabBar *tabbar = [UITabBar appearance];
//    [UITabBar appearance].translucent = NO;
//    [tabbar setBackgroundImage:[UIImage new]];
//    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
//    [tabbar setBackgroundImage:[Utils createImageWithColor:[uic] size:CGSizeZero cornerRadius:0]];
//    [tabbar setShadowImage:[Utils createImageWithColor:KControlColor size:CGSizeZero cornerRadius:0]];
    
    self.tabBar.layer.shadowColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.16f].CGColor;;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, 0);
    self.tabBar.layer.shadowOpacity = 1;
    self.tabBar.layer.shadowRadius = 3;
}

- (void)addChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selImage:(NSString *)selImage
{
    vc.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.edgesForExtendedLayout = UIRectEdgeNone;
    UHNavigationController *nvc = [[UHNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nvc];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    if (tabBarController.viewControllers[1] == viewController) {
//        return NO;
//    } else {
        return YES;
//    }
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    if ([item.title isEqualToString:@"绩效"]) {
//        RHLoginViewController *loginVC = [[RHLoginViewController alloc]init];
//        loginVC.showTrade = YES;
//        [self.selectedViewController pushViewController:loginVC animated:NO];
//    }
}

- (void)buttonAction:(UIButton *)button{
    if (!self.tabBar.hidden) {
        self.selectedIndex = 1;//关联中间按钮
    }
}

- (void)login {
    UHLoginController *loginControl = [[UHLoginController alloc] init];
    [self presentViewController:loginControl animated:YES completion:nil];
}
@end
