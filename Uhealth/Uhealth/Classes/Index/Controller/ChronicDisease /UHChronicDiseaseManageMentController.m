//
//  UHChronicDiseaseManageMentController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHChronicDiseaseManageMentController.h"
#import "UHChronicDiseaseCell.h"
#import "UHChronicDiseaseModel.h"

#import "UHBloodPressureController.h"
#import "UHBUAController.h"
#import "UHSpoController.h"
#import "UHGLUController.h"
#import "UHBMIController.h"
#import "UHWeightController.h"
#import "UHLipidsController.h"
@interface UHChronicDiseaseManageMentController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *data;
@end

@implementation UHChronicDiseaseManageMentController

static NSString * const reuseIdentifier = @"UHChronicDiseaseCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    NSArray *array = @[@"血压",@"血尿酸",@"血氧",@"血糖",@"身体指数",@"体重",@"血脂"];
    for (int i=0; i<7; i++) {
        UHChronicDiseaseModel *model  =[[UHChronicDiseaseModel alloc] init];
        model.iconName = [NSString stringWithFormat:@"chronicDiseaseM_0%d",i+1];
        model.name = array[i];
        [self.data addObject:model];
    }
    [self.collectionView reloadData];
}

- (void)setupUI {
    self.title = @"健康数据";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UHChronicDiseaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.model = self.data[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ZPLog(@"%ld",indexPath.row);
    switch (indexPath.row) {
        case 0:
            {
                UHBloodPressureController *bloodControl =  [[UHBloodPressureController alloc] init];
                bloodControl.isCompany = self.isCompany;
                [self.navigationController pushViewController:bloodControl animated:YES];
            }
            break;
        case 1:
        {
            UHBUAController *buaControl = [[UHBUAController alloc] init];
            buaControl.isCompany = self.isCompany;
            [self.navigationController pushViewController:buaControl animated:YES];
        }
            break;
        case 2:
        {
            UHSpoController *spoControl = [[UHSpoController alloc] init];
            spoControl.isCompany = self.isCompany;
            [self.navigationController pushViewController:spoControl animated:YES];
        }
            break;
        case 3:
        {
            UHGLUController *gluControl = [[UHGLUController alloc] init];
            gluControl.isCompany = self.isCompany;
            [self.navigationController pushViewController:gluControl animated:YES];
        }
            break;
        case 4:
        {
            UHBMIController *bmiControl = [[UHBMIController alloc] init];
            bmiControl.isCompany = self.isCompany;
            [self.navigationController pushViewController:bmiControl animated:YES];
        }
            break;
        case 5:
        {
            UHWeightController *weightControl = [[UHWeightController alloc] init];
            weightControl.isCompany = self.isCompany;
            [self.navigationController pushViewController:weightControl animated:YES];
        }
            break;
        case 6:
        {
            UHLipidsController *lipidsControl = [[UHLipidsController alloc] init];
            lipidsControl.isCompany = self.isCompany;
            [self.navigationController pushViewController:lipidsControl animated:YES];
        }
            break;
        default:
            break;
    }
   
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置cell的尺寸(行距,列距)
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        // 设置cell的宽度
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-2)/3, (SCREEN_WIDTH-2)/3);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = KControlColor;
        //注册cell
        [_collectionView registerClass:[UHChronicDiseaseCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _collectionView;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data= [NSMutableArray array];
    }
    return _data;
}
@end
