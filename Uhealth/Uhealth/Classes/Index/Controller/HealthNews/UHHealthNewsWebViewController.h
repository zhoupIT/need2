//
//  UHHealthNewsWebViewController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHHealthNewsModel;
typedef NS_ENUM (NSInteger,ZPHealthEnterStatusType) {
    ZPHealthEnterStatusTypeNormal,//正常路径
    ZPHealthEnterStatusTypeBanner,//banner图
    ZPHealthEnterStatusTypeNoti//通知
};
@interface UHHealthNewsWebViewController : UIViewController
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,copy) NSString *mainBody;;
@property (nonatomic,strong) UHHealthNewsModel *healthNewsModel;


@property (nonatomic,assign) ZPHealthEnterStatusType enterStatusType;
@property (nonatomic,copy) NSString *bannerAim;
@end
