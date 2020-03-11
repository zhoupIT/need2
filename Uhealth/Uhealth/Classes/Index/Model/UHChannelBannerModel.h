//
//  UHChannelBannerModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/8/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHChannelBannerModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *companyName;
@property (nonatomic,strong) UHCommonEnumType *launchPlatform;
@property (nonatomic,strong) UHCommonEnumType *position;
@property (nonatomic,copy) NSString *banner;
@property (nonatomic,strong) UHCommonEnumType *bannerType;
@property (nonatomic,copy) NSString *bannerAim;
@end
