//
//  NoInputAccessoryView.h
//  Uhealth
//
//  Created by Biao Geng on 2018/8/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>

#import <WebKit/WebKit.h>

#import <objc/runtime.h>
@interface NoInputAccessoryView : NSObject
- (void)removeInputAccessoryViewFromWKWebView:(WKWebView *)webView;
@end
