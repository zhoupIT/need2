//
//  UHArticleCommentListController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/7/9.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHHealthWindModel,UHHealthNewsModel;
typedef NS_ENUM (NSInteger,ZPArticleType) {
    ZPArticleTypeWind,
    ZPArticleTypeHealthNews
};
typedef NS_ENUM (NSInteger,ZPCommentListEnterStatusType) {
    ZPCommentListEnterStatusTypeNormal,//正常路径
    ZPCommentListEnterStatusTypeBanner,//banner图
    ZPCommentListEnterStatusTypeNoti//通知
};
@interface UHArticleCommentListController : UIViewController
@property (nonatomic,strong) UHHealthWindModel *windModel;
@property (nonatomic,strong) UHHealthNewsModel *healthNewsModel;
@property (nonatomic,assign) ZPArticleType articleType;


@property (nonatomic,assign) ZPCommentListEnterStatusType enterStatusType;
@property (nonatomic,copy) NSString *bannerAim;
@end
