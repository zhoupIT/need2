//
//  UHArticleCommentModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/7/9.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHArticleCommentModel : NSObject
@property (nonatomic,copy) NSString *commentId;
@property (nonatomic,copy) NSString *articleId;
@property (nonatomic,copy) NSString *articleType;
@property (nonatomic,copy) NSString *customerId;
@property (nonatomic,copy) NSString *commentContent;
@property (nonatomic,copy) NSString *commentTime;
@property (nonatomic,copy) NSString *customerPortrait;
@property (nonatomic,copy) NSString *customerName;
@property (nonatomic,copy) NSString *likeCounts;
@property (nonatomic,strong) UHCommonEnumType *articleCommentLikeState;
//新增的评论需要将背景设置为灰色
@property (nonatomic,assign) BOOL isNewComment;
@end
