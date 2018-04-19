//
//  NSObject+NetworkManager.m
//  TTBidH5
//
//  Created by ysx on 2018/4/3.
//  Copyright © 2018年 ysx. All rights reserved.
//

#import <stdio.h>
#import <string>
#import <thread>
#import <sys/time.h>

#import <CommonCrypto/CommonCryptor.h>
#import <AlipaySDK/AlipaySDK.h>
#import "NetworkManager.h"
#import "PhoneInformation.h"

@interface NetworkManager()
@end

@implementation NetworkManager

+ (NetworkManager *) instance {
    static NetworkManager *manager = nil;
    if (manager == nil) {
        manager = [[NetworkManager alloc] init];
    }
    return manager;
}

- (id) init {
    if ((self = [super init])) {
        self.anonymous = [NSNumber numberWithInt:1];
        self.alipayCompletionBlock = nil;
    }
    return self;
}

- (NSString *) readToken {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"TOKEN"];
    if (token == nil) {
        return @"";
    }
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:token options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [self desEncrypt:data option:kCCDecrypt];
    if (data == nil) {
        return @"";
    }
    
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (ret == nil) {
        return @"";
    }
    return ret;
}

- (void) writeToken:(NSString *)token {
    if (token != nil && [token length] > 0) {
        NSData *data = [[NSData alloc] initWithBytes:[token UTF8String] length:[token lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
        data = [self desEncrypt:data option:kCCEncrypt];
        if (data != nil) {
            token = [data base64EncodedStringWithOptions:0];
            if (token == nil) {
                token = @"";
            }
        }
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:token forKey:@"TOKEN"];
    [userDefaults synchronize];
}

- (NSString *) readDeviceToken {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [userDefaults objectForKey:@"DTOKEN"];
    if (deviceToken == nil) {
        deviceToken = @"";
    }
    return deviceToken;
}

- (void) writeDeviceToken:(NSString *)deviceToken {
    if (deviceToken == nil) {
        deviceToken = @"";
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:deviceToken forKey:@"DTOKEN"];
    [userDefaults synchronize];
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

    const void *vkey = "9@H$LyLM";
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

- (NSData *) encodeData:(NSData *)data {
    int8_t code[32];
    for (int i = 0; i < 32; ++i) {
        code[i] = (int8_t)(arc4random() % 256);
    }
    NSData *originCode = [NSData dataWithBytes:code length:32];
    NSData *newData = [NSData dataWithData:data];
    int8_t *_newData = (int8_t *)[newData bytes];
    const int8_t *_data = (const int8_t *)[data bytes];

    int8_t *_originCode = (int8_t *)[originCode bytes];
    int index = 0;
    while (index < [data length]) {
        for (int i = 0; i < 32; ++i) {
            _newData[index] = (int8_t)(_data[index] ^ _originCode[i]);
            index ++;
            if (index >= [data length]) {
                break;
            }
        }
    }

    NSData *encodedCode = [self desEncrypt:originCode option:kCCEncrypt];
    NSString *_encodedCode = [encodedCode base64EncodedStringWithOptions:0];
    NSString *encodedData = [newData base64EncodedStringWithOptions:0];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_encodedCode forKey:@"code"];
    [dict setObject:encodedData forKey:@"data"];
    return [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
}

- (NSData *) decodeData:(NSData *)data {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    if (dict == nil) {
        return nil;
    }
    NSString *encodedCode = [dict objectForKey:@"code"];
    NSString *encodedData = [dict objectForKey:@"data"];
    
    NSData *_encodedCode = [[NSData alloc] initWithBase64EncodedString:encodedCode options:NSDataBase64DecodingIgnoreUnknownCharacters];
    _encodedCode = [self desEncrypt:_encodedCode option:kCCDecrypt];
    
    NSData *_encodedData = [[NSData alloc] initWithBase64EncodedString:encodedData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    int8_t *code = (int8_t *)[_encodedCode bytes];
    int8_t *outputData = (int8_t *)[_encodedData bytes];
    int index = 0;
    while (index < [_encodedData length]) {
        for (int i = 0; i < 32; ++i) {
            outputData[index] = (int8_t)(outputData[index] ^ code[i]);
            index ++;
            if (index >= [_encodedData length]) {
                break;
            }
        }
    }
    return _encodedData;
}

- (NSData *) requestAction:(NSString *)url dict:(NSDictionary *) requestDict {
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDict options:kNilOptions error:nil];
#if DEBUG
    NSString *_requestData = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    LWLOG("request url: %s, data: %s", [url UTF8String], [_requestData UTF8String]);
#endif
    requestData = [self encodeData:requestData];
 
    url = [NSString stringWithFormat:@"%@%@", @REQUEST_URL, url];
    NSURL *_url = [NSURL URLWithString:url];
    if (!_url) {
        _url = [NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                          timeoutInterval:60];
    
    // set post
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestData];
    
    // set request header
    NSDictionary *deviceInfos = [PhoneInformation deviceInfos];
    for (NSString *key in deviceInfos) {
        [request setValue:deviceInfos[key] forHTTPHeaderField:key];
    }
    
    NSHTTPURLResponse *response = NULL;
    NSError *_error = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&_error];
    NSString *error = @"";
    if (NULL != _error) {
        error = [_error localizedDescription];
    }
    
    int code = (int)[response statusCode];
    if([error length] <= 0 && code == 200) {
        responseData = [self decodeData:responseData];
#if DEBUG
        NSString *_responseData = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        LWLOG("response: %s", [_responseData UTF8String]);
#endif
    } else {
        LWLOG("response code: %d, error: %s", code, [error UTF8String]);
        responseData = nil;
    }
    return responseData;
}

- (void) sendRequest:(NSString *)url dict:(NSMutableDictionary *)requestDict callback:(RequestCallback)callback {
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    long nowTime = [nowDate timeIntervalSince1970];
    [requestDict setObject:[NSNumber numberWithLong:nowTime] forKey:@"t"];
    
    std::thread thread([=](){
        NSData *responseData = [self requestAction:url dict:requestDict];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (responseData == nil) {
                callback(NO, nil);
            } else {
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
                callback(YES, responseDict);
            }
        });
    });
    thread.detach();
}

- (void) checkAudit:(RequestCallback)callback {
    NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
    [self sendRequest:@"/control/audit" dict:requestDict callback:callback];
}

- (void) callAlipay:(float)amount
            subject:(NSString *)subject
            address:(NSString *)address
               note:(NSString *)note
           callback:(RequestCallback)callback {
    NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
    [requestDict setObject:[NSNumber numberWithFloat:amount] forKey:@"amount"];
    [requestDict setObject:subject forKey:@"subject"];
    [requestDict setObject:address forKey:@"address"];
    [requestDict setObject:note forKey:@"note"];
    
    [self sendRequest:@"/ext/pay/alipay" dict:requestDict callback:^(BOOL success, NSDictionary *responseDict) {
        if (!success) {
            callback(NO, nil);
            return;
        }
        
        self.alipayCompletionBlock = ^(NSDictionary *resultDict) {
            NSString *resultStatus = [resultDict objectForKey:@"resultStatus"];
            if (resultStatus != nil && [resultStatus isEqualToString:@"9000"]) {
                // 支付成功
                callback(YES, nil);
            } else {
                // 支付失败
                callback(NO, nil);
            }
            
            [NetworkManager instance].alipayCompletionBlock = nil;
        };
        
        NSString *orderInfo = [responseDict objectForKey:@"order_info"];
        [[AlipaySDK defaultService] payOrder:orderInfo fromScheme:@"aplwh5" callback:self.alipayCompletionBlock];
    }];
}

- (void) authToken:(RequestCallback)callback {
    NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
    [requestDict setObject:[self readToken] forKey:@"token"];
    [requestDict setObject:[self readDeviceToken] forKey:@"apns_device_token"];
    [self sendRequest:@"/login/auth/token" dict:requestDict callback:^(BOOL success, NSDictionary *responseDict) {
        if (success) {
            [self writeToken:responseDict[@"token"]];
            self.anonymous = responseDict[@"anonymous"];
        }
        
        if (callback) {
            callback(success, responseDict);
        }
    }];
}

@end
