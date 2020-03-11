//
//  UINavigationController+UHNavigationController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UINavigationController+UHNavigationController.h"

@implementation UINavigationController (UHNavigationController)
- (void)setNeedsNavigationBackground:(CGFloat)alpha {
    // 导航栏背景透明度设置
    UIView *barBackgroundView = [[self.navigationBar subviews] objectAtIndex:0];// _UIBarBackground
    UIImageView *backgroundImageView = [[barBackgroundView subviews] objectAtIndex:0];// UIImageView
    if (self.navigationBar.isTranslucent) {
        if (backgroundImageView != nil && backgroundImageView.image != nil) {
            barBackgroundView.alpha = alpha;
        } else {
            UIView *backgroundEffectView = [[barBackgroundView subviews] objectAtIndex:1];// UIVisualEffectView
            if (backgroundEffectView != nil) {
                backgroundEffectView.alpha = alpha;
            }
        }
    } else {
        barBackgroundView.alpha = alpha;
    }
    for (UIView *view in [self.navigationBar subviews]) {
        NSLog(@"---->%@",view);
    }
}
@end
