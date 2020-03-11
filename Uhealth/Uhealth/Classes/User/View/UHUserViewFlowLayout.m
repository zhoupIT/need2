//
//  UHUserViewFlowLayout.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHUserViewFlowLayout.h"

@implementation UHUserViewFlowLayout
- (void)prepareLayout {
    [super prepareLayout];
    
    self.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
}
@end
