//
//  UHAddFamilyController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/3/21.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHAddFamilyController.h"
#import "UHAddFamilyView.h"
@interface UHAddFamilyController ()

@end

@implementation UHAddFamilyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.title = @"绑定家人";
}

- (void)setupUI {
    self.view.backgroundColor = KControlColor;
    UHAddFamilyView *addFamView = [UHAddFamilyView addFamilyView];
    [self.view addSubview:addFamView];
    addFamView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .heightIs(220);
}



@end
