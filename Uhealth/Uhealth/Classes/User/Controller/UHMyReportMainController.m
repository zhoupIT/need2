//
//  UHMyReportMainController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMyReportMainController.h"
#import "VTMagic.h"
#import "UHMyReportController.h"
@interface UHMyReportMainController ()<VTMagicViewDataSource, VTMagicViewDelegate>

@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong)  NSArray *menuList;
@end

@implementation UHMyReportMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    _menuList = @[@"日常报告", @"周报月报"];
    [self.magicController.magicView reloadData];
}

- (void)setupUI {
    switch (self.index) {
        case 0:
             self.title = @"血压报告";
            break;
        case 1:
            self.title = @"血尿酸报告";
            break;
        case 2:
            self.title = @"血氧报告";
            break;
        case 3:
            self.title = @"血糖报告";
            break;
        case 4:
            self.title = @"身体指数报告";
            break;
        case 5:
            self.title = @"体重报告";
            break;
        case 6:
            self.title = @"血脂报告";
            break;
        default:
            break;
    }
   
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
    UHMyReportController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[UHMyReportController alloc] init];
    }
     viewController.index = self.index;
     viewController.pageIndex = pageIndex;
    return viewController;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    
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
        _magicController.magicView.needPreloading = NO;
    }
    return _magicController;
}
@end
