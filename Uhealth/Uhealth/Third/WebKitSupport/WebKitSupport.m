//
//  WebKitSupport.m
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/12.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "WebKitSupport.h"

#import <objc/runtime.h>

@implementation WebKitSupport

+ (instancetype)sharedSupport {
    
    static WebKitSupport *_instance;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _instance = [WebKitSupport new];
    });
    
    return  _instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        _processPool = [WKProcessPool new];
    }
    
    return self;
}


+ (NSURLRequest *)fixRequest:(NSURLRequest *)request{
    
    NSMutableURLRequest *fixedRequest;
    
    if ([request isKindOfClass:[NSMutableURLRequest class]]) {
        
        fixedRequest = (NSMutableURLRequest *)request;
        
    } else {
        
        fixedRequest = request.mutableCopy;
    }
    
    // 防止Cookie丢失
    
    NSDictionary *dict = [NSHTTPCookie requestHeaderFieldsWithCookies:[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies];
    
    if (dict.count) {
        
        NSMutableDictionary *mDict = request.allHTTPHeaderFields.mutableCopy;
        
        [mDict setValuesForKeysWithDictionary:dict];
        
        fixedRequest.allHTTPHeaderFields = mDict;
    }
    
    return fixedRequest;
}

+ (NSURL *)urlAddParams:(NSURL *)url Params:(NSDictionary *)params{
    
    NSString *urlString = url.absoluteString;
    
    NSMutableArray *paramsArray = [NSMutableArray array];
    
    for (NSString *key in params) {
        
        [paramsArray addObject:[NSString stringWithFormat:@"%@=%@" , key , params[key]]];
    }
    
    NSString *paramsString = [paramsArray componentsJoinedByString:@"&"];
    
    if ([url query]) {
        
        urlString = [urlString stringByAppendingFormat:@"&%@" , paramsString];
        
    } else {
        
        urlString = [urlString stringByAppendingFormat:@"?%@" , paramsString];
    }
    
    return [NSURL URLWithString:urlString];
}

@end

@implementation NSHTTPCookie (Utils)

- (NSString *)lee_javascriptString{
    
    NSString *string = [NSString stringWithFormat:@"%@=%@;domain=%@;path=%@",
                        self.name,
                        self.value,
                        self.domain,
                        self.path ?: @"/"];
    
    if (self.secure) {
        
        string = [string stringByAppendingString:@";secure=true"];
    }
    
    return string;
}

@end


@implementation WeakScriptMessageDelegate

- (void)dealloc {
    
}

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate{
    
    self = [super init];
    
    if (self) {
        
        _scriptDelegate = scriptDelegate;
    }
    
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end

@implementation WKWebView (CrashHandle)

+ (void)load{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0f &&
        [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            NSArray *selStringsArray = @[@"evaluateJavaScript:completionHandler:"];
            
            [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
                
                NSString *leeSelString = [@"lee_" stringByAppendingString:selString];
                
                Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
                
                Method leeMethod = class_getInstanceMethod(self, NSSelectorFromString(leeSelString));
                
                method_exchangeImplementations(originalMethod, leeMethod);
            }];
            
        });
        
    }
    
}

/*
 * fix: WKWebView crashes on deallocation if it has pending JavaScript evaluation
 
 执行JS代码的情况下。WKWebView 退出并被释放后导致completionHandler变成野指针，而此时 javaScript Core 还在执行JS代码，待 javaScript Core 执行完毕后会调用completionHandler()，导致 crash。这个 crash 只发生在 iOS 8 系统上，参考Apple Open Source，在iOS9及以后系统苹果已经修复了这个bug，主要是对completionHandler block做了copy；对于iOS 8系统，可以通过在 completionHandler 里 retain WKWebView 防止 completionHandler 被过早释放
 
 https://mp.weixin.qq.com/s?__biz=MzA3NTYzODYzMg==&mid=2653578513&idx=1&sn=961bf5394eecde40a43060550b81b0bb&chksm=84b3b716b3c43e00ee39de8cf12ff3f8d475096ffaa05de9c00ff65df62cd73aa1cff606057d&scene=0&key=468207a9de9ae380f58f8bbb03e5b881df66d2830e8636774d327d1bfeebbe282ce01b62e578a94cfb8f452b61b044aaf0fc84ff24e746caf18898b90c09b84bb471fc2345f342ee2d4a807717892cd4&ascene=0&uin=MjUxNjM5OTAwOA%253D%253D&devicetype=iMac+MacBookPro12%252C1+OSX+OSX+10.12.2+build(16C67)&version=12010210&nettype=WIFI&fontScale=100&pass_ticket=0EHjNNtfFZbYLIot3eyt73N8BUKsfDodoVurhMAHy66oWndBI0zQLVu7xXx3lEz4
 
 */
- (void)lee_evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler{
    
    id strongSelf = self;
    
    [self lee_evaluateJavaScript:javaScriptString completionHandler:^(id r, NSError *e) {
        
        [strongSelf title];
        
        if (completionHandler) {
            
            completionHandler(r, e);
        }
        
    }];
    
}

@end
