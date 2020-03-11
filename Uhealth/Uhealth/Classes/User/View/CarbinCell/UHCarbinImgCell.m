//
//  UHCarbinImgCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHCarbinImgCell.h"
#import "UHCarbinImgSubCell.h"
#import "UHCabinDetailModel.h"
@interface UHCarbinImgCell()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
}
@property (nonatomic,strong) NSArray *imgData;
@end
@implementation UHCarbinImgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *contentView = self.contentView;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置cell的尺寸(行距,列距)
    layout.minimumLineSpacing = ZPWidth(22);
    layout.minimumInteritemSpacing = ZPWidth(16);
    layout.sectionInset = UIEdgeInsetsMake(0, ZPWidth(16), 0, ZPWidth(16));
    // 设置cell的宽度
    //ZPWidth(165)
    layout.itemSize = CGSizeMake(ZPWidth(100), ZPHeight(70));
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 15);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [contentView addSubview:_collectionView];
    _collectionView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.alwaysBounceHorizontal = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[UHCarbinImgSubCell class] forCellWithReuseIdentifier:NSStringFromClass([UHCarbinImgSubCell class])];
}

- (void)setModel:(UHCabinDetailModel *)model {
    _model = model;
    self.imgData = model.innerImgList;
    [_collectionView reloadData];
}

#pragma mark - collectionView数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UHCarbinImgSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UHCarbinImgSubCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    cell.model = self.imgData[indexPath.row];
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    UHAdvisoryChannelModel *model = self.channelDatas[indexPath.row];
//    if ([model.channelStatus.name isEqualToString:@"NORMAL"]) {
//        UHAuthorityCenterController *authorityCenterControl = [[UHAuthorityCenterController alloc] init];
//        authorityCenterControl.channelModel = model;
//        [self.navigationController pushViewController:authorityCenterControl animated:YES];
//    } else {
//        [LEEAlert alert].config
//        .LeeTitle(@"提醒")
//        .LeeContent(model.channelStatus.text)
//        .LeeAction(@"确认", ^{
//        })
//        .LeeClickBackgroundClose(YES)
//        .LeeShow();
//    }
}

- (NSArray *)imgData {
    if (!_imgData) {
        _imgData = [NSArray array];
    }
    return _imgData;
}

@end
