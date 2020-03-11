//
//  UHArticleCommentListHeaderView.h
//  Uhealth
//
//  Created by Biao Geng on 2018/7/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHHealthWindModel,UHHealthNewsModel;
@interface UHArticleCommentListHeaderView : UIView
@property (nonatomic,strong) UHHealthWindModel *model;
@property (nonatomic,strong) UHHealthNewsModel *healthNewsModel;
@property (nonatomic , copy ) void (^updateHeightBlock)(UHArticleCommentListHeaderView *view);
@property (nonatomic,copy) void (^popBlock) (UIButton *btn);
@end
