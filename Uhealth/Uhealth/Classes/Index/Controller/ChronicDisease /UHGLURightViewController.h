//
//  UHGLURightViewController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/5/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,DrawerType) {
    DrawerDefaultLeft = 1, // 默认动画，左侧划出
    DrawerDefaultRight,    // 默认动画，右侧滑出
    DrawerTypeMaskLeft,    // 遮盖动画，左侧划出
    DrawerTypeMaskRight    // 遮盖动画，右侧滑出
};
@interface UHGLURightViewController : UIViewController
@property (nonatomic,assign) DrawerType drawerType; // 抽屉类型

@property (nonatomic,copy) void (^clickTypeBlock) (NSString *name);
@end
