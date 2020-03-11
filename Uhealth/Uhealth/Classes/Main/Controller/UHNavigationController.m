//
//  UHNavigationController.m
//  Peng Zhou
//
//  Created by 鹏 周 on 2017/8/28.
//  Copyright © 2017年 Peng Zhou. All rights reserved.
//

#import "UHNavigationController.h"
#import "UHView.h"

//颜色
#define JHColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface UHNavigationController ()

@end

@implementation UHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self useMethodToFindBlackLineAndHind];
}

+ (void)initialize
{
    
    // 1.设置标题栏字体颜色和大小
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.translucent = NO;
    NSDictionary *attr = @{
                           NSFontAttributeName : SYS_FONT(17),
                           NSForegroundColorAttributeName : [UIColor whiteColor]
                           };
    [bar setTitleTextAttributes:attr];
    
    
    
    // 2.设置Item主题样式（高亮颜色尚未处理完善、可用类别创建文字按钮）
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    NSDictionary *norAttr = @{
                              NSFontAttributeName : SYS_FONT(15),
                              NSForegroundColorAttributeName : JHColor(86, 86, 86)
                              };
    [item setTitleTextAttributes:norAttr forState:UIControlStateNormal];
    
    NSDictionary *higAttr = @{
                              NSFontAttributeName : SYS_FONT(15),
                              NSForegroundColorAttributeName : [UIColor orangeColor]
                              };
    [item setTitleTextAttributes:higAttr forState:UIControlStateHighlighted];
    
//    [[UINavigationBar appearance] setTintColor:KNavBackgroundColor];
    [[UINavigationBar appearance] setBackgroundImage:[self setBGGradientColors:@[RGB(78, 178, 255),RGB(99,205,255)]] forBarMetrics:UIBarMetricsDefault];
    //  [[UINavigationBar appearance] setBarTintColor: ];
    
    
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
//    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"back"];
//    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back"];
   
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [dic setObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];

    [[UIBarButtonItem appearance] setTitleTextAttributes:dic forState:UIControlStateNormal];

}


//绘制对象背景的渐变色特效
+ (UIImage *)setBGGradientColors:(NSArray<UIColor *> *)colors {
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
+ (UIImage *)imageFromLayer:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.opaque, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        //        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back_btn_nor" highImageName:@"back_btn_hig" target:self action:@selector(back)];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
        viewController.navigationItem.leftBarButtonItem = backItem;
        
        
    }
    //一定要写在最后，要不然无效
    [super pushViewController:viewController animated:animated];
    //处理了push后隐藏底部UITabBar的情况，并解决了iPhonX上push时UITabBar上移的问题。
    CGRect rect = self.tabBarController.tabBar.frame;
    rect.origin.y = [UIScreen mainScreen].bounds.size.height - rect.size.height;
    self.tabBarController.tabBar.frame = rect;
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

#pragma mark ——— 隐藏navigationBar下的黑线 ————————
-(void)useMethodToFindBlackLineAndHind
{
    UIImageView *blackLineImageView = [self findHairlineImageViewUnder:self.navigationBar];
    blackLineImageView.hidden = YES;
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0){
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}



@end
