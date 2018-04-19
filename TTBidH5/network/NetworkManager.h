//
//  NSObject+NetworkManager.h
//  TTBidH5
//
//  Created by ysx on 2018/4/3.
//  Copyright © 2018年 ysx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>

typedef void(^RequestCallback)(BOOL success, NSDictionary *responseDict);

@interface NetworkManager: NSObject

@property (nonatomic, readwrite) NSNumber *anonymous;
@property (nonatomic, readwrite) CompletionBlock alipayCompletionBlock;

+ (NetworkManager *) instance;

- (NSString *) readToken;
- (void) writeToken:(NSString *)token;

- (NSString *) readDeviceToken;
- (void) writeDeviceToken:(NSString *)deviceToken;

- (void) checkAudit:(RequestCallback)callback;

- (void) callAlipay:(float)amount
            subject:(NSString *)subject
            address:(NSString *)address
                note:(NSString *)note
            callback:(RequestCallback)callback;

- (void) authToken:(RequestCallback)callback;

@end
