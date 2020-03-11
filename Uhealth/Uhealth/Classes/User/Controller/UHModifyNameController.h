//
//  UHModifyNameController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/3/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHModifyNameController : UIViewController
@property (nonatomic,copy) void (^updateName) (NSString *name);
@end
