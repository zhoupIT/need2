//
//  UHAllLectureHistoryCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/8/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHAllLectureHistoryCell : UITableViewCell
@property (nonatomic,copy) void (^moreHistoryLecturesBlock) (void);
@end
