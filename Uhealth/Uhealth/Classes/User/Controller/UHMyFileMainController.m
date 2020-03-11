//
//  UHMyFileController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/26.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyFileMainController.h"
#import "VTMagic.h"
#import "UHMyFileController.h"
#import "UHMyFileDetailController.h"
@interface UHMyFileMainController ()<VTMagicViewDataSource, VTMagicViewDelegate>

@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong)  NSArray *menuList;
@end

@implementation UHMyFileMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    _menuList = @[@"检测结果", @"我的报告"];
    [_magicController.magicView reloadData];
}

- (void)setupUI {
    self.title = @"健康档案";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.magicController.view];
    self.magicController.view.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}


#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return _menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [menuItem setTitleColor:KCommonBlue forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    static NSString *gridId = @"relate.identifier";
    UHMyFileController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[UHMyFileController alloc] init];
    }
    viewController.detailClickBlock = ^(NSString *ID){
        UHMyFileDetailController *fileDetailControl = [[UHMyFileDetailController alloc] init];
        fileDetailControl.ID = ID;
        [self.navigationController pushViewController:fileDetailControl animated:YES];
    };
    return viewController;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    UHMyFileController *viewControllerTemp = viewController;
    viewControllerTemp.pageIndex = pageIndex;
}

#pragma mark - accessor methods
- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = KCommonBlue;
        _magicController.magicView.switchStyle = VTSwitchStyleStiff;
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.navigationHeight = 46.f;
        _magicController.magicView.sliderExtension = 10.f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}
@end
