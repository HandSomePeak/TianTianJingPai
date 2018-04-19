//
//  TencentAction.h
//  KillKa
//
//  Created by YSX YSX on 3/11/15.
//
//

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

#import "ThirdpartyAction.h"

@interface TencentAction : ThirdpartyAction<TencentSessionDelegate, QQApiInterfaceDelegate>

+ (TencentAction *)action;
+ (BOOL)processURL:(NSURL*) url;

- (void)joinQQGroup:(NSString *)groupID;
- (void)joinQQPlayer:(NSString *)playerID;

- (BOOL)isQQInstalled;

- (void)shareToQQ:(void(^)(bool success, NSString *errorMsg))callbackFunc;          // 分享到QQ好友
- (void)shareToQQZone:(void(^)(bool success, NSString *errorMsg))callbackFunc;      // 分享到QQ空间

// 分享到QQ好友
- (void)shareToQQ:(NSString *)title
      description:(NSString *)description
           imgUrl:(NSString *)imgUrl
          openUrl:(NSString *)openUrl
         callback:(void(^)(bool success, NSString *errorMsg))callbackFunc;

// 分享到QQ空间
- (void)shareToQQZone:(NSString *)title
          description:(NSString *)description
               imgUrl:(NSString *)imgUrl
              openUrl:(NSString *)openUrl
             callback:(void(^)(bool success, NSString *errorMsg))callbackFunc;

@end
