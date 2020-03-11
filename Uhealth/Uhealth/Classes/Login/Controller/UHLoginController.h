//
//  UHLoginController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/3/27.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHLoginController : UIViewController
@property (nonatomic,copy) NSString *authID;
@property (nonatomic,copy) NSString *accessToken;
@property (nonatomic,assign) BOOL boolregist;
- (void)registeAccount;
@end
