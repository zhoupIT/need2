//
//  UHHealthDynamicModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/9/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHHealthDynamicModel : NSObject
//类别：枚举值：HEALTH_DIRECTION(1010, "健康风向"),HEALTH_INFORMATION(1020, "健康资讯")
@property (nonatomic,strong) UHCommonEnumType *articleSort;
//所指向的文章id
@property (nonatomic,copy) NSString *articleId;
//标题
@property (nonatomic,copy) NSString *title;
//标签：目前枚举值只有最新
@property (nonatomic,strong) UHCommonEnumType *flag;
@end
