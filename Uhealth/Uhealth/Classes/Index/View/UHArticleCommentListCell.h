//
//  UHArticleCommentListCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/7/9.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHArticleCommentModel;
@interface UHArticleCommentListCell : UITableViewCell
@property (nonatomic,strong) UHArticleCommentModel *model;
@property (nonatomic,copy) void (^likeBlock) (UIButton *btn);
@end
