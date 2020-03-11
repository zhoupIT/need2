//
//  UHAuthorityChannelController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/8/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHAuthorityChannelController.h"
#import "UHAuthorityChannelCell.h"
#import "UHAuthorityCenterController.h"
#import "UHAdvisoryChannelModel.h"
@interface UHAuthorityChannelController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *channelDatas;
@end

@implementation UHAuthorityChannelController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

- (void)initAll {
    self.title = @"权威频道";
    self.view.backgroundColor = KControlColor;
    [self.view addSubview:self.collectionView];
    self.collectionView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    [self setupRefresh];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)setupRefresh {
    WEAK_SELF(weakSelf);
    __unsafe_unretained UICollectionView *collectionView = self.collectionView;
    // 下拉刷新
    collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"advisory/channel" parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [collectionView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                weakSelf.channelDatas  = [UHAdvisoryChannelModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                [collectionView reloadData];
                [collectionView.mj_footer  resetNoMoreData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [collectionView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHAuthorityChannelController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    collectionView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"advisory/channel" parameters:@{@"offset":[NSNumber numberWithInteger:self.channelDatas.count]} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [collectionView.mj_footer endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [UHAdvisoryChannelModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (!arrays.count) {
    
                    [collectionView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [weakSelf.channelDatas addObjectsFromArray:arrays];
                    [collectionView reloadData];
                }
            } else {
                
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            
            // 结束刷新
            [collectionView.mj_footer endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[UHAuthorityChannelController class]];
    }];
    
}

#pragma mark - collectionView数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.channelDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UHAuthorityChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UHAuthorityChannelCell class]) forIndexPath:indexPath];
    cell.model = self.channelDatas[indexPath.row];
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    UHAdvisoryChannelModel *model = self.channelDatas[indexPath.row];
    if ([model.channelStatus.name isEqualToString:@"NORMAL"]) {
        UHAuthorityCenterController *authorityCenterControl = [[UHAuthorityCenterController alloc] init];
        authorityCenterControl.channelModel = model;
        [self.navigationController pushViewController:authorityCenterControl animated:YES];
    } else {
        [LEEAlert alert].config
        .LeeTitle(@"提醒")
        .LeeContent(model.channelStatus.text)
        .LeeAction(@"确认", ^{
        })
        .LeeClickBackgroundClose(YES)
        .LeeShow();
    }
    
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置cell的尺寸(行距,列距)
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        // 设置cell的宽度
        //ZPWidth(165)
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-45)*0.5, ZPHeight(100));
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 15);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UHAuthorityChannelCell class] forCellWithReuseIdentifier:NSStringFromClass([UHAuthorityChannelCell class])];
    }
    return _collectionView;
}

- (NSMutableArray *)channelDatas {
    if (!_channelDatas) {
        _channelDatas = [NSMutableArray array];
    }
    return _channelDatas;
}

@end
