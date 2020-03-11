//
//  UHOrderDetailImageFootView.h
//  Uhealth
//
//  Created by Biao Geng on 2018/7/4.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UHOrderDetailImageFootView : UIView
@property (nonatomic , copy ) void (^updateHeightBlock)(UHOrderDetailImageFootView *view); //更新高度Block
@end
