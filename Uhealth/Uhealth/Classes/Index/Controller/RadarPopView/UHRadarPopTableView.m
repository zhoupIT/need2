//
//  UHRadarPopTableView.m
//  Uhealth
//
//  Created by Biao Geng on 2018/7/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHRadarPopTableView.h"
#import "UHRadarPopTableViewCell.h"
#import "UHGetScore.h"
@interface UHRadarPopTableView()<UITableViewDelegate , UITableViewDataSource>
@end
@implementation UHRadarPopTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        
        //初始化数据
        [self initData];
    }
    
    return self;
}

- (void)initData {
    self.backgroundColor = [UIColor clearColor];
    
    self.delegate = self;
    
    self.dataSource = self;
    
    self.bounces = NO;
    self.scrollEnabled = NO;
    
    self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    self.separatorColor = [[UIColor grayColor] colorWithAlphaComponent:0.2f];
    
    
    [self registerClass:[UHRadarPopTableViewCell class] forCellReuseIdentifier:NSStringFromClass([UHRadarPopTableViewCell class])];
    self.estimatedRowHeight  = 0;
    self.estimatedSectionFooterHeight = 0;
    self.estimatedSectionHeaderHeight = 0;

}


- (void)setArray:(NSArray *)array{
    
    _array = array;
    
    [self reloadData];
//    CGRect selfFrame = self.frame;
//    selfFrame.size.height = self.contentSize.height;
//    self.frame = selfFrame;
   
}

#pragma mark - UITableViewDelegate , UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UHGetScore *model = self.array[indexPath.row];
//    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[UHRadarPopTableViewCell class] contentViewWidth:SCREEN_WIDTH];
    return 25.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UHRadarPopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UHRadarPopTableViewCell class])];
    cell.model = self.array[indexPath.row];
    return cell;
}


@end
