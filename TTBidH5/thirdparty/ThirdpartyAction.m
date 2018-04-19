//
//  NSObject+ThirdpartyAction.m
//  TTBidH5
//
//  Created by ysx on 2018/4/13.
//  Copyright © 2018年 ysx. All rights reserved.
//

#import "ThirdpartyAction.h"
#import "JSHandler.h"

@implementation ThirdpartyAction

- (void)login {
}

- (void) postLoginResult:(NSString *)method success:(BOOL)success auth:(NSDictionary *)authDict info:(NSString *)info {
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    [resultDict setObject:method forKey:@"method"];
    
    if (success) {
        [resultDict setObject:[LWBool initWidthValue:YES] forKey:@"success"];
    } else {
        [resultDict setObject:[LWBool initWidthValue:NO] forKey:@"success"];
    }
    
    if (authDict == nil) {
        authDict = [[NSMutableDictionary alloc] init];
    }
    [resultDict setObject:authDict forKey:@"auth"];
    
    [resultDict setObject:info forKey:@"info"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"THIRDPARTY_LOGIN" object:nil userInfo:resultDict];
}

@end
