//
//  NoInputAccessoryView.m
//  Uhealth
//
//  Created by Biao Geng on 2018/8/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "NoInputAccessoryView.h"

@implementation NoInputAccessoryView
- (id)inputAccessoryView {
    
    return nil;
    
}

- (void)removeInputAccessoryViewFromWKWebView:(WKWebView *)webView {
    
    UIView *targetView;
    
    for (UIView *view in webView.scrollView.subviews) {
        
        if([[view.class description] hasPrefix:@"WKContent"]) {
            
            targetView = view;
            
        }
        
    }
    
    if (!targetView) {
        
        return;
        
    }
    
    NSString *noInputAccessoryViewClassName = [NSString stringWithFormat:@"%@_NoInputAccessoryView", targetView.class.superclass];
    
    Class newClass = NSClassFromString(noInputAccessoryViewClassName);
    
    if(newClass == nil) {
        
        newClass = objc_allocateClassPair(targetView.class, [noInputAccessoryViewClassName cStringUsingEncoding:NSASCIIStringEncoding], 0);
        
        if(!newClass) {
            
            return;
            
        }
        
        Method method = class_getInstanceMethod([NoInputAccessoryView class], @selector(inputAccessoryView));
        
        class_addMethod(newClass, @selector(inputAccessoryView), method_getImplementation(method), method_getTypeEncoding(method));
        
        objc_registerClassPair(newClass);
        
    }
    
    object_setClass(targetView, newClass);
    
}
@end
