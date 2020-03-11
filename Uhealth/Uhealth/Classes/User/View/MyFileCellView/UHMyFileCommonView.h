//
//  UHMyFileCommonView.h
//  Uhealth
//
//  Created by Biao Geng on 2018/7/5.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHMyFileCommonView : UIView
- (void)setupWithItemsArray:(NSArray *)itemsArray;
- (void)setupNOData:(CGFloat)height;
@property (nonatomic,copy) NSString *modeName;
@end
