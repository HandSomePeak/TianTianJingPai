//
//  JSHandler.m
//  TTBidH5
//
//  Created by ysx on 2018/4/3.
//  Copyright © 2018年 ysx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface LWBool : NSObject
@property (nonatomic) BOOL value;
+ (nonnull LWBool *) initWidthValue:(BOOL)value;
@end

@interface JSHandler : NSObject<WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate>
+ (nonnull NSArray *)allScriptMessageNames;
- (void) callJSFunc:(nonnull WKWebView *)webview funcName:(nonnull NSString *)funcName params:(NSObject *)params, ...;
@end
