//
//  WeiBoLoginAction.m
//  KillKa
//
//  Created by YSX YSX on 3/13/15.
//
//

#import "WeiBoAction.h"
#import "WeiboSDK.h"

@implementation WeiBoAction

+ (WeiBoAction *)action {
    static WeiBoAction *action = nil;
    if (nil == action) {
        action = [[WeiBoAction alloc] init];
    }
    return action;
}

+ (BOOL)processURL:(NSURL*) url {
    return [WeiboSDK handleOpenURL:url delegate:[WeiBoAction action]];
}

- (id)init {
    if ((self = [super init])) {
        [WeiboSDK registerApp:@WEIBO_APP_ID];
    }
    return self;
}

#pragma mark - LoginAction
- (void)login {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"http://www.ttbid.net";
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

#pragma marl - isWBAppInstalled
- (BOOL)isWBAppInstalled {
    return [WeiboSDK isWeiboAppInstalled];
}

- (void)shareToSina:(void(^)(bool success, NSString *errorMsg))callbackFunc {
    if([WeiboSDK isWeiboAppInstalled] == false){
        if(callbackFunc){
            callbackFunc(false,@"您没安装微博");
        }
        return;
    }
    
//    [[CONFUSION_CLASS(RequestManager) sharedManager] CONFUSION_FUNC(loadShareInfo):^(NSString *title, NSString *description, NSString *imgUrl, NSString *openUrl){
//    
//        WBMessageObject *message = [WBMessageObject message];
//        WBWebpageObject *webpage = [WBWebpageObject object];
//        webpage.objectID = @"identifier1";
//        webpage.title = description;
//        webpage.description = title;
////        webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgUrl ofType:@""]];
//        webpage.thumbnailData = [CONFUSION_CLASS(LWUtils) decryptAssetsData:imgUrl];
//        webpage.webpageUrl = openUrl;
//        message.mediaObject = webpage;
//        
//        WBSendMessageToWeiboRequest *req = [WBSendMessageToWeiboRequest request];
//        req.message = message;
//        [WeiboSDK sendRequest:req];
//    }];
}

-(void)shareToSina:(NSString *)title WithDesc:(NSString *)description WithImgUrl:(NSString *)imgUrl WithOpenUrl:(NSString *)openUrl callback:(void(^)(bool success, NSString *errorMsg))callbackFunc {
    if([WeiboSDK isWeiboAppInstalled] == false){
        if(callbackFunc){
            callbackFunc(false,@"您没安装微博");
        }
        return;
    }
    
    WBMessageObject *message = [WBMessageObject message];
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"identifier1";
    webpage.title = title;
    webpage.description = description;
    webpage.thumbnailData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
    webpage.webpageUrl = openUrl;
    message.mediaObject = webpage;
    
    WBSendMessageToWeiboRequest *req = [WBSendMessageToWeiboRequest request];
    req.message = message;
    [WeiboSDK sendRequest:req];
}

#pragma mark - WeiboSDKDelegate protocol
/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    BOOL success = FALSE;
    
    if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        WBAuthorizeResponse *authorResponse = (WBAuthorizeResponse *)response;
        NSString *accessToken = [authorResponse accessToken];

        if (accessToken) {
            success = TRUE;
            [self postLoginResult:@"weibo" success:YES auth:response.userInfo info:@"登录成功"];
        }
    }

    if (success == FALSE) {
        [self postLoginResult:@"weibo" success:NO auth:nil info:@"登录失败"];
    }
}

@end
