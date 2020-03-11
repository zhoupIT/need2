//
//  UHGluEnteringController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/5/29.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHGluEnteringController : UIViewController
@property (nonatomic,copy) void (^updateListBlock) (void);
@end
