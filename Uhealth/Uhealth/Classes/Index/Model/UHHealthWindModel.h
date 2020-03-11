//
//  UHHealthWindModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/27.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHHealthWindModel : NSObject
@property (nonatomic,copy) NSString *directionId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSArray *titleImgList;
@property (nonatomic,copy) NSString *author;
@property (nonatomic,copy) NSString *introduction;
@property (nonatomic,copy) NSString *mainBody;
@property (nonatomic,copy) NSString *mainBodyUrl;
@property (nonatomic,copy) NSString *pageviews;
@property (nonatomic,copy) NSString *commentCount;
@property (nonatomic,copy) NSString *createDate;
//评论总量
@property (nonatomic,copy) NSString *toatalCommentsCount;
@end
