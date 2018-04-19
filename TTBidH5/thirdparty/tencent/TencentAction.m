//
//  TencentLoginAction.m
//  KillKa
//
//  Created by YSX YSX on 3/11/15.
//
//

#import "Config.h"
#import "TencentAction.h"

@interface TencentAction()

@property (nonatomic, retain)TencentOAuth *oauth;

@end

@implementation TencentAction

+ (TencentAction *)action {
    static TencentAction *action = nil;
    if (nil == action) {
        action = [[TencentAction alloc] init];
    }
    return action;
}

+ (BOOL) processURL:(NSURL*) url {
    [QQApiInterface handleOpenURL:url delegate:[TencentAction action]];
    return [TencentOAuth HandleOpenURL:url];
}

- (void)joinQQGroup:(NSString *)groupID {
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&card_type=group&source=qrcode&jump_from=1", groupID];
    NSURL *openUrl = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:openUrl];
}

- (void)joinQQPlayer:(NSString *)playerID {
    if (playerID == nil) {
        playerID = @"bvmsAAqucGweSF9N3qIkw4Q9j0ddBbJ0";
    }
    
//    std::string _playerID = [playerID UTF8String];
//    std::string _url = std::string("http://qm.qq.com/cgi-bin/qm/qr?k=") + _playerID + "&jump_from=1";
//    NSString *url = [NSString stringWithUTF8String:CONFUSION_CLASS(Crypter)::CONFUSION_FUNC(urlEncode)(_url).c_str()];
//    NSString *urlStr = [NSString stringWithFormat:@"mqqopensdkapi://bizAgent/qm/qr?url=%@", url];
//    NSURL *openUrl = [NSURL URLWithString:urlStr];
//    [[UIApplication sharedApplication] openURL:openUrl];
}

- (id)init {
    if ((self = [super init])) {
        self.oauth = [[TencentOAuth alloc] initWithAppId:@TENCENT_APP_ID andDelegate:self];
    }
    return self;
}

#pragma mark - LoginAction
- (void)login {
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            nil];
    [self.oauth authorize:permissions inSafari:NO];
}

#pragma mark - TencentLoginDelegate
- (void)tencentDidLogin {
    NSDate *expirationDate = [_oauth expirationDate];
    int expires_in = (int)[expirationDate timeIntervalSinceNow];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[_oauth accessToken] forKey:@"access_token"];
    [dict setObject:[_oauth openId] forKey:@"openid"];
    [dict setObject:[NSNumber numberWithInt:expires_in] forKey:@"expires_in"];
    [self postLoginResult:@"qq" success:YES auth:dict info:@"登录成功"];
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    [self postLoginResult:@"qq" success:NO auth:nil info:@"取消登录"];
}

- (void)tencentDidNotNetWork {
    [self postLoginResult:@"qq" success:NO auth:nil info:@"联网失败"];
}

#pragma mark - TencentSessionDelegate
- (void)tencentDidLogout {
}

- (void)responseDidReceived:(APIResponse*)response forMessage:(NSString *)message {
}

- (BOOL)isQQInstalled {
    return [QQApiInterface isQQInstalled];
}

- (void)shareToQQ:(void(^)(bool success, NSString *errorMsg))callbackFunc {
    if (![QQApiInterface isQQInstalled]) {
        if (callbackFunc) {
            callbackFunc(false, @"您没有安装QQ");
        }
        return;
    }
    
//    [[CONFUSION_CLASS(RequestManager) sharedManager] CONFUSION_FUNC(loadShareInfo):^(NSString *title, NSString *description, NSString *imgUrl, NSString *openUrl) {
////        imgUrl = [[NSBundle mainBundle] pathForResource:imgUrl ofType:nil];
//        QQApiNewsObject *obj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:openUrl]
//                                                        title:title
//                                                  description:description
//                                              previewImageData:[CONFUSION_CLASS(LWUtils) decryptAssetsData:imgUrl]];
//        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
//        QQApiSendResultCode code = [QQApiInterface sendReq:req];
//        if (code != EQQAPISENDSUCESS) {
//            if (callbackFunc) {
//                callbackFunc(false, @"分享失败");
//            }
//        } else {
//            if (callbackFunc) {
//                callbackFunc(true, nil);
//            }
//        }
//    }];
//    SPAM_CODE(3);
}

- (void)shareToQQZone:(void(^)(bool success, NSString *errorMsg))callbackFunc {
    if (![QQApiInterface isQQInstalled]) {
        if (callbackFunc) {
            callbackFunc(false, @"您没有安装QQ");
        }
        return;
    }
    
//    [[CONFUSION_CLASS(RequestManager) sharedManager] CONFUSION_FUNC(loadShareInfo):^(NSString *title, NSString *description, NSString *imgUrl, NSString *openUrl) {
////        imgUrl = [[NSBundle mainBundle] pathForResource:imgUrl ofType:nil];
//        QQApiNewsObject *obj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:openUrl]
//                                                        title:title
//                                                  description:description
//                                              previewImageData:[CONFUSION_CLASS(LWUtils) decryptAssetsData:imgUrl]];
//        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
//        QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
//        if (code != EQQAPISENDSUCESS) {
//            if (callbackFunc) {
//                callbackFunc(false, @"分享失败");
//            }
//        } else {
//            if (callbackFunc) {
//                callbackFunc(true, nil);
//            }
//        }
//    }];
}

- (void)shareToQQ:(NSString *)title
      description:(NSString *)description
           imgUrl:(NSString *)imgUrl
          openUrl:(NSString *)openUrl
         callback:(void(^)(bool success, NSString *errorMsg))callbackFunc {
      QQApiNewsObject *obj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:openUrl]
                                                      title:title
                                                description:description
                                            previewImageURL:[NSURL URLWithString:imgUrl]];
    
      SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
      QQApiSendResultCode code = [QQApiInterface sendReq:req];
      if (code != EQQAPISENDSUCESS) {
          if (callbackFunc) {
              callbackFunc(false, @"分享失败");
          }
      } else {
          if (callbackFunc) {
              callbackFunc(true, nil);
          }
      }
}

- (void)shareToQQZone:(NSString *)title
          description:(NSString *)description
               imgUrl:(NSString *)imgUrl
              openUrl:(NSString *)openUrl
             callback:(void(^)(bool success, NSString *errorMsg))callbackFunc {
      QQApiNewsObject *obj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:openUrl]
                                                      title:title
                                                description:description
                                            previewImageURL:[NSURL URLWithString:imgUrl]];
      SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
    
      QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
      if (code != EQQAPISENDSUCESS) {
          if (callbackFunc) {
              callbackFunc(false, @"分享失败");
          }
      } else {
          if (callbackFunc) {
              callbackFunc(true, nil);
          }
      }
      SPAM_CODE(4);
}

#pragma mark - QQApiInterfaceDelegate
/**处理来至QQ的请求*/
- (void)onReq:(QQBaseReq *)req {
}

/**处理来至QQ的响应*/
- (void)onResp:(QQBaseResp *)resp {
    if (resp == nil) {
        return;
    }
    
    if ([resp isKindOfClass:[SendMessageToQQResp class]] &&
        [resp type] == ESENDMESSAGETOQQRESPTYPE &&
        [[resp result] isEqual: @"0"]) {
        // 成功
    }
}

/**处理QQ在线状态的回调*/
- (void)isOnlineResponse:(NSDictionary *)response {
}

@end
