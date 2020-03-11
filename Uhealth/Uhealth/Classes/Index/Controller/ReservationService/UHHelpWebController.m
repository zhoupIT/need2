//
//  UHHelpWebController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/6/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHHelpWebController.h"

@interface UHHelpWebController ()
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UIImageView *iconView;
@end

@implementation UHHelpWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

- (void)initAll {
    switch (self.pageindex) {
        case 0:
            self.title= @"绿通产品介绍";
            break;
        case 1:
            self.title= @"绿通服务细则";
            break;
        case 2:
            self.title= @"绿通服务流程";
            break;
        default:
            self.title= @"优医家";
            break;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    self.webView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"product_%ld",self.pageindex+1] ofType:@"html"];
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
