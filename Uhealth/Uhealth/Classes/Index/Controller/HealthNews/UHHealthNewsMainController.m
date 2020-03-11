//
//  UHHealthNewsMainController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHHealthNewsMainController.h"
#import "VTMagic.h"
#import "UHHealthNewsController.h"
#import "UHHealthNewsWebViewController.h"

@interface UHHealthNewsMainController ()<VTMagicViewDataSource, VTMagicViewDelegate>
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong)  NSArray *menuList;
@end

@implementation UHHealthNewsMainController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    _menuList = @[@"综合",@"心理", @"儿童",@"孕妇",@"老人",@"女性"];
    [_magicController.magicView reloadData];
//    [_magicController switchToPage:self.index animated:YES];
}

- (void)setupUI {
    self.title = @"健康资讯";
    self.view.backgroundColor = KControlColor;
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
    UHHealthNewsController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[UHHealthNewsController alloc] init];
    }
//    viewController.pageIndex = pageIndex;
    viewController.didClickBlock = ^(NSString *mainBody,UHHealthNewsModel *healthNewsModel){
        UHHealthNewsWebViewController *webViewControl = [[UHHealthNewsWebViewController alloc] init];
        webViewControl.mainBody = mainBody;
        webViewControl.healthNewsModel = healthNewsModel;
        [self.navigationController pushViewController:webViewControl animated:YES];
    };
    return viewController;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    UHHealthNewsController *viewControllerTemp = viewController;
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
