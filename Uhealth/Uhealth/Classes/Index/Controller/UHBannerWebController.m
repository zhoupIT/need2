//
//  UHBannerWebController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHBannerWebController.h"

@interface UHBannerWebController ()
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UIImageView *iconView;
@end

@implementation UHBannerWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

- (void)initAll {
    switch (self.pageindex) {
        case 0:
            self.title= @"员工身心健康关爱计划";
            break;
        case 1:
            self.title= @"温馨家园 关心无限";
            break;
        case 2:
            self.title= @"健康小屋开业啦";
            break;
        case 3:
            self.title= @"精神杀手抑郁症";
            break;
        case 4:
            self.title= @"中国居民食品营养健康关注度大数据";
            break;
        default:
            self.title= @"优医家";
            break;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    self.webView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%ld",self.pageindex+1] ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:basePath];
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [UIWebView new];
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}
@end
