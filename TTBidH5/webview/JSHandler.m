//
//  JSHandler.m
//  TTBidH5
//
//  Created by ysx on 2018/4/3.
//  Copyright © 2018年 ysx. All rights reserved.
//

#import <AlipaySDK/AlipaySDK.h>
#import <CommonCrypto/CommonCryptor.h>

#import "JSHandler.h"
#import "NetworkManager.h"
#import "PhoneInformation.h"
#import "WeiXinAction.h"
#import "TencentAction.h"
#import "WeiBoAction.h"
#import "SVProgressHUD.h"

@implementation LWBool
+ (nonnull LWBool *) initWidthValue:(BOOL)value {
    LWBool *ret = [[LWBool alloc] init];
    ret.value = value;
    return ret;
}
@end

@implementation JSHandler

+ (nonnull NSArray *)allScriptMessageNames {
    return [NSArray arrayWithObjects:
            @"log_error",               // 错误提示
            @"log_toast",               // 提示
            @"fetch_device_info",       // 设备信息
            @"thirdparty_login",        // 第三方登录
            @"store_token",             // 保存token
            @"load_token",              // 获取token
            @"load_device_token",
            @"anonymous",               // 获取匿名登录
            @"open_inner_url",          // 打开内部页面
            @"open_outer_url",          // 打开外部浏览器
            @"open_new_web",            // 打开新的web页面
            @"close_web",
            @"clear_web_cache",         // 清除浏览器缓存
            @"web_load_finished",       // 页面加载完成
            @"show_loading",            // 加载loading
            @"hide_loading",
            @"alipay_purchase",         // 支付宝支付
            @"store_value",             // 存取数据
            @"load_value",
            nil];
}

- (NSData *) desEncrypt:(NSData*)data option:(CCOperation)option {
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = (uint8_t *)malloc(bufferPtrSize * sizeof(uint8_t));
    memset(bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = "67HdeyEN";
    const void *vinitVec = "\x22\x33\x35\x81\xBC\x38\x5A\xE7";
    
    ccStatus = CCCrypt(option,
                       kCCAlgorithmDES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySizeDES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    if (ccStatus == kCCSuccess) {
        return [NSData dataWithBytes:bufferPtr length:(NSUInteger)movedBytes];
    }
    return nil;
}

- (NSString *) encodeValue:(NSString *) value {
    if (value == nil) return @"";
    
    NSData *data = [[NSData alloc] initWithBytes:[value UTF8String] length:[value lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    data = [self desEncrypt:data option:kCCEncrypt];
    if (data != nil) {
        value = [data base64EncodedStringWithOptions:0];
        if (value == nil) {
            value = @"";
        }
    }
    
    return value;
}

- (NSString *) decodeValue:(NSString *) value {
    if (value == nil) return @"";
    NSData *data = [[NSData alloc] initWithBase64EncodedString:value options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [self desEncrypt:data option:kCCDecrypt];
    if (data == nil) {
        return @"";
    }
    
    value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (value == nil) {
        return @"";
    }
    return value;
}

- (NSString *) translateParam:(NSObject *) param {
    if (param == nil) {
        return @"";
    }
    
    if ([param isKindOfClass:[NSString class]]) {
        // to String
        return [NSString stringWithFormat:@"\"%@\"", param];
    } else if ([param isKindOfClass:[NSDictionary class]]) {
        // to JSON String
        NSData *data = [NSJSONSerialization dataWithJSONObject:param options:kNilOptions error:nil];
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    } else if ([param isKindOfClass:[LWBool class]]) {
        // to Bool
        LWBool *lwbool = (LWBool *)param;
        if (lwbool.value == YES) {
            return [NSString stringWithFormat:@"true"];
        } else {
            return [NSString stringWithFormat:@"false"];
        }
    }
    return [NSString stringWithFormat:@"%@", param];
}

- (void) callJSFunc:(WKWebView *)webview funcName:(NSString *)funcName params:(NSObject *)params, ... {
    NSString *jsStr = [NSString stringWithFormat:@"javascript:%@(", funcName];
    
    va_list values;
    va_start(values, params);
    if (params) {
        jsStr = [NSString stringWithFormat:@"%@%@", jsStr, [self translateParam:params]];
        
        NSObject *arg;
        while ((arg = va_arg(values, NSObject *))) {
            if (arg) {
                jsStr = [NSString stringWithFormat:@"%@, %@", jsStr, [self translateParam:arg]];
            }
        }
    }
    va_end(values);
    
    jsStr = [NSString stringWithFormat:@"%@)", jsStr];
    NSLog(@"\ncall javascript:\n%@", jsStr);
    dispatch_async(dispatch_get_main_queue(), ^{
        [webview evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"\nfrom javascript:\nfunc: %@\nresult: %@\nerror: %@\n", funcName, result, error);
        }];
    });
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"\ncall native: \nname: %@\nbody: %@\nframeInfo: %@\n", message.name, message.body, message.frameInfo);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            NSString *name = message.name;
            if ([name isEqualToString:@"log_error"]) {
#if DEBUG
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误提示" message:message.body delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
#endif
            } else if ([name isEqualToString:@"log_toast"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message.body delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            } else if ([name isEqualToString:@"fetch_device_info"]) {
                // 设备信息
                [self callJSFunc:message.webView funcName:@"g_fetch_device_info" params:[PhoneInformation deviceInfos], nil];
            } else if ([name isEqualToString:@"thirdparty_login"]) {
                // 第三方登录
                NSString *method = message.body;
                if ([method isEqualToString:@"weixin"]) {
                    [[WeiXinAction action] login];
                } else if ([method isEqualToString:@"qq"]) {
                    [[TencentAction action] login];
                } else if ([method isEqualToString:@"weibo"]) {
                    [[WeiBoAction action] login];
                }
            } else if ([name isEqualToString:@"store_token"]) {
                NSString *token = message.body;
                [[NetworkManager instance] writeToken:token];
            } else if ([name isEqualToString:@"load_token"]) {
                [self callJSFunc:message.webView funcName:@"g_load_token" params:[[NetworkManager instance] readToken], nil];
            } else if ([name isEqualToString:@"load_device_token"]) {
                [self callJSFunc:message.webView funcName:@"g_load_device_token" params:[[NetworkManager instance] readDeviceToken], nil];
            } else if ([name isEqualToString:@"anonymous"]) {
                [self callJSFunc:message.webView funcName:@"g_anonymous" params:[NetworkManager instance].anonymous, nil];
            } else if ([name isEqualToString:@"open_inner_url"]) {
                // 内部浏览器
                NSString *url = message.body;
                NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
                [message.webView loadRequest:request];
            } else if ([name isEqualToString:@"open_outer_url"]) {
                // 外部浏览器
                NSString *url = message.body;
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            } else if ([name isEqualToString:@"open_new_web"]) {
                // 打开新的浏览器
                NSString *url = message.body;
                NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
                [defaultCenter postNotificationName:@"LoadNewWebView" object:url];
            } else if ([name isEqualToString:@"close_web"]) {
                // 关闭浏览器
                NSString *tagStr = [NSString stringWithFormat:@"%ld",message.webView.tag];
                NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
                [defaultCenter postNotificationName:@"closeTwoWebView" object:tagStr];
            } else if ([name isEqualToString:@"clear_web_cache"]) {
                // 清除浏览器缓存
                if (@available(ios 9.0,*)) {
                    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
                    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
                    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
                    }];
                }
            } else if ([name isEqualToString:@"web_load_finished"]) {
                // 首页加载完成
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSDictionary *actionDict = nil;
                
                actionDict = [userDefaults objectForKey:@"PUSH_DATA"];
                if (actionDict != nil && [actionDict count] > 0) {
                    // 清空推送数据
                    NSDictionary *_actionDict = [[NSDictionary alloc] init];
                    [userDefaults setObject:_actionDict forKey:@"PUSH_DATA"];
                    [userDefaults synchronize];
                    // 发出通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PUSH_DATA" object:nil userInfo:actionDict];
                }
                
                actionDict = [userDefaults objectForKey:@"URL_DATA"];
                if (actionDict != nil && [actionDict count] > 0) {
                    // 清空推送数据
                    NSDictionary *_actionDict = [[NSDictionary alloc] init];
                    [userDefaults setObject:_actionDict forKey:@"URL_DATA"];
                    [userDefaults synchronize];
                    // 发出通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"URL_DATA" object:nil userInfo:actionDict];
                }
            } else if ([name isEqualToString:@"show_loading"]) {
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
                [SVProgressHUD show];
            } else if ([name isEqualToString:@"hide_loading"]) {
                [SVProgressHUD dismiss];
            } else if ([name isEqualToString:@"alipay_purchase"]) {
                // 支付宝
                [NetworkManager instance].alipayCompletionBlock = ^(NSDictionary *resultDict) {
                    [self callJSFunc:message.webView funcName:@"g_alipay_result" params:resultDict, nil];
                    [NetworkManager instance].alipayCompletionBlock = nil;
                };
                
                NSString *orderInfo = message.body;
                [[AlipaySDK defaultService] payOrder:orderInfo fromScheme:@"aplwh5" callback:[NetworkManager instance].alipayCompletionBlock];
            } else if ([name isEqualToString:@"store_value"]) {
                // 存储数据
                NSString *data = message.body;
                NSData *_data = [NSData dataWithBytes:[data UTF8String] length:[data lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:_data options:kNilOptions error:nil];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                for (NSString *key in jsonDict) {
                    NSObject *value = jsonDict[key];
                    if ([value isKindOfClass:[NSString class]]) {
                        [userDefaults setObject:[self encodeValue:(NSString *)value] forKey:key];
                    } else {
                        NSLog(@"%@: is not a string", value);
                    }
                }
                [userDefaults synchronize];
            } else if ([name isEqualToString:@"load_value"]) {
                // 读取数据
                NSString *key = message.body;
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *value = [userDefaults objectForKey:key];
                value = [self decodeValue:value];
                value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                [self callJSFunc:message.webView funcName:@"g_load_value" params:key, value, nil];
            }
        } @catch (NSException *e) {
#if DEBUG
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"出错提示" message:[NSString stringWithFormat:@"%@", e] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
#endif
        } @finally {
        }
    });
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
#if DEBUG
    NSLog(@"webview error1:\n%@", error);
    NSString *_error = [NSString stringWithFormat:@"%@", error];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网页错误提示1" message:_error delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
#endif
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
#if DEBUG
    NSLog(@"webview error2:\n%@", error);
    NSString *_error = [NSString stringWithFormat:@"%@", error];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网页错误提示2" message:_error delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
#endif
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"finish load url: %@", webView.URL);
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter postNotificationName:@"LoadUrl" object:nil];
}

@end
