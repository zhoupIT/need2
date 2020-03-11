//
//  UHHealthWindWebViewController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHHealthWindModel;
typedef NS_ENUM (NSInteger,ZPWindEnterStatusType) {
    ZPWindEnterStatusTypeNormal,//正常路径
    ZPWindEnterStatusTypeBanner,//banner图
    ZPWindEnterStatusTypeNoti//通知
};
@interface UHHealthWindWebViewController : UIViewController
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,copy) NSString *urlStr;
@property (nonatomic,strong) UHHealthWindModel *windModel;

@property (nonatomic,assign) ZPWindEnterStatusType enterStatusType;
@property (nonatomic,copy) NSString *bannerAim;
@end
