//
//  WeiXinAction.h
//  KillKa
//
//  Created by YSX YSX on 3/12/15.
//
//

#import "WXApi.h"
#include "ThirdpartyAction.h"

@interface WeiXinAction : ThirdpartyAction<WXApiDelegate>

+ (WeiXinAction *)action;
+ (BOOL)processURL:(NSURL*) url;

- (BOOL)isWXAppInstalled;

- (void)shareToSession:(void(^)(bool success, NSString *errorMsg))callbackFunc;         // 分享到好友
- (void)shareToTimeline:(void(^)(bool success, NSString *errorMsg))callbackFunc;        // 分享到朋友圈

// 分享到好友
- (void)shareToSession:(NSString *)title
           description:(NSString *)description
                imgUrl:(NSString *)imgUrl
               openUrl:(NSString *)openUrl
              callback:(void(^)(bool success, NSString *errorMsg))callbackFunc;

// 分享到朋友圈
- (void)shareToTimeline:(NSString *)title
            description:(NSString *)description
                 imgUrl:(NSString *)imgUrl
                openUrl:(NSString *)openUrl
               callback:(void(^)(bool success, NSString *errorMsg))callbackFunc;

@end
