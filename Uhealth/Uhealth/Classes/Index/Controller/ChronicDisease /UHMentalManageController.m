//
//  UHMentalManageController.m
//  Uhealth
//
//  Created by Biao Geng on 2018/5/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHMentalManageController.h"
#import "UHPhysicalManageController.h"
#import <WebKit/WebKit.h>
#import "UHHomeViewController.h"
@interface UHMentalManageController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic,strong)  WKWebView *wkWebView;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,copy) NSString *nextUrl;
@end

@implementation UHMentalManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAllWk];
}

- (void)initAllWk {
    self.title = self.titleStr;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.wkWebView];
    self.wkWebView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
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
    NSString *hiddenPubBackJS = @"document.getElementsByClassName('pubBack')[0].hidden = true";
    NSString *hiddenIconJS = @"document.getElementsByClassName('my-icon')[0].hidden = true";
    //执行JS
    [webView evaluateJavaScript:hiddenPubBackJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        ZPLog(@"value: %@ error: %@", response, error);
    }];
    
    [webView evaluateJavaScript:hiddenIconJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        ZPLog(@"value: %@ error: %@", response, error);
    }];
    
    if (self.nextUrl.length && [self.nextUrl containsString:@"result"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *allHtml = @"document.documentElement.innerHTML";
            [webView evaluateJavaScript:allHtml completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                ZPLog(@"value: %@ error: %@", response, error);
            }];
        });
    }
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    self.nextUrl = navigationResponse.response.URL.absoluteString;
    decisionHandler(WKNavigationResponsePolicyAllow);
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
    if ([self.titleStr isEqualToString:@"身心健康评估"]) {
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"assessment/get/report" parameters:nil progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            
        } className:[UHMentalManageController class]];
        if (self.infoFilled) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[UHHomeViewController class]]) {
                    UHHomeViewController *A =(UHHomeViewController *)controller;
                    [self.navigationController popToViewController:A animated:YES];
                }
            }
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
