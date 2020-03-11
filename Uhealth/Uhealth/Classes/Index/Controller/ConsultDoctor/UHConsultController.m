//
//  UHConsultController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHConsultController.h"
#import "UHMentalManageController.h"
#import "UHConsultDoctorController.h"
#import "UHConsultViewCell.h"
@interface UHConsultController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *data;
@end

@implementation UHConsultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    self.title = @"身心咨询";
    self.view.backgroundColor = KControlColor;
    [self.view addSubview:self.collectionView];
    self.collectionView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UHConsultViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UHConsultViewCell class]) forIndexPath:indexPath];
    cell.dict = self.data[indexPath.row];
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ZPLog(@"%ld",indexPath.row);
    UHConsultDoctorController *doctorControl = [[UHConsultDoctorController alloc] init];
    doctorControl.index = indexPath.row;
    [self.navigationController pushViewController:doctorControl animated:YES];
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(SCREEN_WIDTH-1)/2,67+ZPHeight(104)};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){SCREEN_WIDTH,10};
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        // 设置cell的尺寸(行距,列距)
//        layout.minimumLineSpacing = 1;
//        layout.minimumInteritemSpacing = 1;
//        // 设置cell的宽度
//        layout.itemSize = CGSizeMake((SCREEN_WIDTH-1)/2, (SCREEN_WIDTH-1)/2);
//
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = KControlColor;
        //注册cell
        [_collectionView registerClass:[UHConsultViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UHConsultViewCell class])];
    }
    return _collectionView;
}

- (NSArray *)data {
    if (!_data) {
        _data = @[@{@"title":@"心理咨询",@"subTitle":@"国家二级心理咨询师",@"iconName":@"consult_icon_psychic"},@{@"title":@"健康咨询",@"subTitle":@"专业全科医生",@"iconName":@"consult_icon_health"}];
    }
    return _data;
}
@end
