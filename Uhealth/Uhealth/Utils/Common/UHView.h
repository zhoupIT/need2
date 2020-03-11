//
//  UHView.h
//  Uhealth
//
//  Created by Biao Geng on 2018/3/21.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHView : UIView
//设置背景渐变色
- (void)setBackgroundGradientColors:(NSArray<UIColor *> *)colors;
- (UIImage *)setBGGradientColors:(NSArray<UIColor *> *)colors;
@end
