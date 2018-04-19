//
//  WeiXinAction.m
//  KillKa
//
//  Created by YSX YSX on 3/12/15.
//
//
#import "Config.h"
#import "WeiXinAction.h"
#import "WXApiObject.h"

@implementation WeiXinAction

+ (WeiXinAction *)action {
    static WeiXinAction *action = nil;
    if (nil == action) {
        action = [[WeiXinAction alloc] init];
    }
    return action;
}

+ (BOOL)processURL:(NSURL*) url {
    return [WXApi handleOpenURL:url delegate:[WeiXinAction action]];
}

- (id)init {
    if ((self = [super init])) {
        [WXApi registerApp:@WECHAT_APP_ID];
    }
    return self;
}

- (void)login {
    if ([WXApi isWXAppInstalled] == false) {
        [self postLoginResult:@"weixin" success:NO auth:nil info:@"您没安装微信"];
        return;
    }
    
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"login";
    [WXApi sendReq:req];
}

- (BOOL)isWXAppInstalled {
    return [WXApi isWXAppInstalled];
}

- (void)shareToImpl:(int)scene callback:(void(^)(bool success, NSString *errorMsg))callbackFunc {
    if ([WXApi isWXAppInstalled] == false) {
        if (callbackFunc) {
            callbackFunc(false, @"您没安装微信");
        }
        return;
    }
    
//    [[CONFUSION_CLASS(RequestManager) sharedManager] CONFUSION_FUNC(loadShareInfo):^(NSString *title, NSString *description, NSString *imgUrl, NSString *openUrl) {
//        WXMediaMessage *message = [WXMediaMessage message];
//        message.title = title;
//        message.description = description;
//
//        UIImage *img = [CONFUSION_CLASS(LWUtils) decryptAssetsImage:imgUrl];
//        [message setThumbImage:img];
//
//        WXWebpageObject *webpageObject = [WXWebpageObject object];
//        webpageObject.webpageUrl = openUrl;
//        message.mediaObject = webpageObject;
//
//        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
//        req.bText = NO;
//        req.message = message;
//        req.scene = scene;
//
//        if ([WXApi sendReq:req]) {
//            if (callbackFunc) {
//                callbackFunc(true, nil);
//            }
//        } else {
//            if (callbackFunc) {
//                callbackFunc(false, @"分享失败");
//            }
//        }
//    }];
}

- (void)shareToSession:(void(^)(bool success, NSString *errorMsg))callbackFunc {
    [self shareToImpl:WXSceneSession callback:callbackFunc];
}

- (void)shareToTimeline:(void(^)(bool success, NSString *errorMsg))callbackFunc {
    [self shareToImpl:WXSceneTimeline callback:callbackFunc];
}

- (void)shareToImpl:(NSString *)title
        description:(NSString *)description
             imgUrl:(NSString *)imgUrl
            openUrl:(NSString *)openUrl
              scene:(int)scene
           callback:(void(^)(bool success, NSString *errorMsg))callbackFunc {
    if ([WXApi isWXAppInstalled] == false) {
        if (callbackFunc) {
            callbackFunc(false, @"您没安装微信");
        }
        return;
    }

   WXMediaMessage *message = [WXMediaMessage message];
   message.title = title;
   message.description = description;
   
   NSURL* _imgUrl = [NSURL URLWithString:imgUrl];
   NSData *imgData = [[NSData alloc] initWithContentsOfURL:_imgUrl];
   UIImage *img = [UIImage imageWithData:imgData];
   [message setThumbImage:img];
   
   WXWebpageObject *webpageObject = [WXWebpageObject object];
   webpageObject.webpageUrl = openUrl;
   message.mediaObject = webpageObject;
   
   SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
   req.bText = NO;
   req.message = message;
   req.scene = scene;
   
   if ([WXApi sendReq:req]) {
       if (callbackFunc) {
           callbackFunc(true, nil);
       }
   } else {
       if (callbackFunc) {
           callbackFunc(false, @"分享失败");
       }
   }
}

- (void)shareToSession:(NSString *)title
           description:(NSString *)description
                imgUrl:(NSString *)imgUrl
               openUrl:(NSString *)openUrl
              callback:(void(^)(bool success, NSString *errorMsg))callbackFunc {
    [self shareToImpl:title description:description imgUrl:imgUrl openUrl:openUrl scene:WXSceneSession callback:callbackFunc];
}

- (void)shareToTimeline:(NSString *)title
            description:(NSString *)description
                 imgUrl:(NSString *)imgUrl
                openUrl:(NSString *)openUrl
               callback:(void(^)(bool success, NSString *errorMsg))callbackFunc {
    [self shareToImpl:title description:description imgUrl:imgUrl openUrl:openUrl scene:WXSceneTimeline callback:callbackFunc];
}

#pragma mark - WXApiDelegate protocol
- (void)onReq:(BaseReq *)req {
}

- (void)onResp:(BaseResp *)resp {
    if (resp == nil) {
        return;
    }
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        // 登录授权
        if((WXSuccess == [resp errCode])) {
            SendAuthResp *sendResp = (SendAuthResp *)resp;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[sendResp code] forKey:@"code"];
            
            [self postLoginResult:@"weixin" success:YES auth:dict info:@"登录成功"];
        } else {
            [self postLoginResult:@"weixin" success:NO auth:nil info:@"登录失败"];
        }
        SPAM_CODE(2);
    } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        // 分享
        if((WXSuccess == [resp errCode])) {
            // 成功
        } else {
            NSLog(@"wx send message fail: %d", [resp errCode]);
        }
    }
}

@end
