//
//  UHHealthTestWebViewController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHHealthTestWebViewController.h"
#import "UHUserModel.h"
#import <WebKit/WebKit.h>
@interface UHHealthTestWebViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic,strong)  WKWebView *wkWebView;
@property (nonatomic,strong) UIProgressView *progressView;
@end

@implementation UHHealthTestWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAllWk];
}

- (void)initAllWk {
    self.title = @"健康自测";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.wkWebView];
    self.wkWebView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:healthUrl]]];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    UIBarButtonItem *popItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    popItem.imageInsets = UIEdgeInsetsMake(0, -45, 0, 0);
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationItem.rightBarButtonItem = popItem;
    [self initWKProgressView];
}

- (void)initWKProgressView {
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,2)];
    [self.view addSubview:self.progressView];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqual: @"estimatedProgress"] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:YES];
        if(self.wkWebView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}


#pragma mark - 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //设置JS
    NSString *hiddenTopJS = @"document.getElementsByClassName('app-top-byq')[0].hidden = true";
   
    //执行JS
    [webView evaluateJavaScript:hiddenTopJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        ZPLog(@"value: %@ error: %@", response, error);
    }];
}

#pragma mark - 返回方法和关闭方法
- (void)back {
    if (self.wkWebView.canGoBack) {
        [self.wkWebView goBack];
    } else {
        [self close];
    }
}

- (void)close {
    [self.navigationController popViewControllerAnimated:YES];
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [WKWebView new];
    }
    return _wkWebView;
}


- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
}

@end
