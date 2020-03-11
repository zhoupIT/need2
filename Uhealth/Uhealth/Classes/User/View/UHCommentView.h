//
//  UHCommentView.h
//  Uhealth
//
//  Created by Biao Geng on 2018/3/29.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHCommentView : UIView
@property (nonatomic,copy) void (^closeBlock) ();
@property (nonatomic,copy) void (^updateBlock)(NSInteger count,NSString *content);
@end
