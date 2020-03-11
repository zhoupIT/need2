//
//  UHHomeMarqueeCustomCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/9/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UHHealthDynamicModel;
@interface UHHomeMarqueeCustomCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic,strong) UIView *circle;
@property (nonatomic,strong) UHHealthDynamicModel *model;
@end
