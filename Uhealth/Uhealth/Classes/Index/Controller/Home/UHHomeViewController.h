//
//  UHHomeViewController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/9/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHHomeViewController : UIViewController
@property (nonatomic, copy) void(^scrollBlock)(CGFloat offsetY);
@end
