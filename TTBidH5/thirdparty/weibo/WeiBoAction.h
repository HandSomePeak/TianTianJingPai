//
//  WeiBoAction.h
//  KillKa
//
//  Created by YSX YSX on 3/13/15.
//
//

#import "WeiboSDK.h"
#import "ThirdpartyAction.h"

@interface WeiBoAction : ThirdpartyAction<WeiboSDKDelegate>

+ (WeiBoAction *)action;
+ (BOOL)processURL:(NSURL*) url;

- (BOOL)isWBAppInstalled;

- (void)shareToSina:(void(^)(bool success, NSString *errorMsg))callbackFunc;//分享到新浪微博

- (void)shareToSina:(NSString *)title WithDesc:(NSString *)description WithImgUrl:(NSString *)imgUrl WithOpenUrl:(NSString *)openUrl callback:(void(^)(bool success, NSString *errorMsg))callbackFunc;//邀请分享到新浪微博

@end
