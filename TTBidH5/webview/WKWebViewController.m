//
//  ViewController.m
//  TTBidH5
//
//  Created by ysx on 2018/3/22.
//  Copyright © 2018年 ysx. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

#import "WKWebViewController.h"
#import "JSHandler.h"
#import "NetworkManager.h"
#import "SVProgressHUD.h"

@interface WKWebViewController () {
    WKWebViewConfiguration * NewConfig;
    NSInteger webTag;
}
@property(nonatomic, retain, readwrite) JSHandler *handler;
@property(nonatomic, retain, readwrite) WKWebView *webView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *reloadButton;

@end

@implementation WKWebViewController

- (id) init {
    if ([super init]) {
        self.handler = [[JSHandler alloc] init];
        webTag = 1;
        WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        config.userContentController = userContentController;
        
        NSArray *allNames = [JSHandler allScriptMessageNames];
        for (int i = 0; i < [allNames count]; ++i) {
            NSString *name = allNames[i];
            [userContentController addScriptMessageHandler:self.handler name:name];
        }
        NewConfig = config;
        CGRect windowRect = [[UIScreen mainScreen] bounds];
        self.webView = [[WKWebView alloc] initWithFrame:windowRect configuration:config];
        self.webView.UIDelegate = self.handler;
        self.webView.navigationDelegate = self.handler;
        
        // 适配ios11沉入式状态栏
        if (@available(ios 11.0,*)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.view addSubview:self.webView];
        
        CGFloat bu_w = 150;
        CGFloat bu_h = 40;
        self.reloadButton = [[UIButton alloc]init];
        self.reloadButton.frame = CGRectMake((windowRect.size.width - bu_w) / 2.0, (windowRect.size.height - bu_h) / 2.0, bu_w, bu_h);
        self.reloadButton.layer.cornerRadius = 5.0;
        self.reloadButton.layer.masksToBounds = YES;
        self.reloadButton.layer.borderWidth = 1.0;
        self.reloadButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [self.reloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.reloadButton addTarget:self action:@selector(ReloadButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        self.reloadButton.hidden = YES;
        [self.view addSubview:self.reloadButton];
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)CreateNewWebViewWithTag:(NSInteger)tag url:(NSString *)url{
    NSLog(@"创建新的浏览器 = %ld, url = %@",tag,url);
    
    CGRect windowRect = [[UIScreen mainScreen] bounds];
    WKWebView *web = [[WKWebView alloc] initWithFrame:windowRect configuration:NewConfig];
    web.UIDelegate = self.handler;
    web.backgroundColor = [UIColor whiteColor];
    web.navigationDelegate = self.handler;
    web.tag = tag;
    
    // 适配ios11沉入式状态栏
    if (@available(ios 11.0,*)) {
        web.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:web];
    });
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [web loadRequest:request];
}

- (void)removeWebViewWithTag:(NSInteger)tag {
    WKWebView *web = [self.view viewWithTag:tag];
    if (web != nil) {
        [web removeFromSuperview];
    }
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(notifyData:) name:@"PUSH_DATA" object:nil];
    [defaultCenter addObserver:self selector:@selector(notifyData:) name:@"URL_DATA" object:nil];
    [defaultCenter addObserver:self selector:@selector(notifyData:) name:@"PAUSE" object:nil];
    [defaultCenter addObserver:self selector:@selector(notifyData:) name:@"RESUME" object:nil];
    [defaultCenter addObserver:self selector:@selector(notifyData:) name:@"THIRDPARTY_LOGIN" object:nil];
    [defaultCenter addObserver:self selector:@selector(LoadUrlNotification:) name:@"LoadUrl" object:nil];
    [defaultCenter addObserver:self selector:@selector(LoadNewWebView:) name:@"LoadNewWebView" object:nil];
    [defaultCenter addObserver:self selector:@selector(closeTwoWebView:) name:@"closeTwoWebView" object:nil];
    
    [self SetTimerss];
    [self Load];
}

- (void)closeTwoWebView:(NSNotification *)notificatio {
    NSLog(@"关闭 tag = %@",notificatio.object);
    if (notificatio.object != nil) {
        [self removeWebViewWithTag:[notificatio.object integerValue]];
    }
    
}

- (void)LoadNewWebView:(NSNotification *)notification {
    NSLog(@"显示新的浏览器 = %@",notification.object);
    [self.timer setFireDate:[NSDate distantFuture]];
    self.reloadButton.hidden = YES;
    [SVProgressHUD dismiss];
    NSString *urlstr = [NSString stringWithFormat:@"%@",notification.object];
    [self CreateNewWebViewWithTag:webTag url:urlstr];
    webTag ++;
}

- (void)SetTimerss {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(TimerMethod) userInfo:nil repeats:NO];
}

- (void)Load {
    NSLog(@"SVProgressHUD 显示");
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD show];
    });
    
    [[NetworkManager instance] authToken:^(BOOL success, NSDictionary *responseDict) {
        if (success) {
            NSString *url = responseDict[@"h5_url"];
#if DEBUG
            url = [NSString stringWithFormat:@"https://beta.share.ttbid.net/h5?token=%@&anonymous=%@", responseDict[@"token"], responseDict[@"anonymous"]];
#endif
            [self openURL:url];
        } else {
            // 请求数据出错
        }
    }];
}

- (void) viewDidUnload {
    WKUserContentController *userContentController = self.webView.configuration.userContentController;
    if (userContentController) {
        NSArray *allNames = [JSHandler allScriptMessageNames];
        
        for (int i = 0; i < [allNames count]; ++i) {
            NSString *name = allNames[i];
            [userContentController removeScriptMessageHandlerForName:name];
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void)TimerMethod {
    [SVProgressHUD dismiss];
    self.reloadButton.hidden = NO;
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)LoadUrlNotification:(NSNotification *)notification {
    [self.timer setFireDate:[NSDate distantFuture]];
    self.reloadButton.hidden = YES;
    [SVProgressHUD dismiss];
}

- (void)ReloadButtonMethod:(UIButton *)button {
    button.hidden = YES;
    [self Load];
    [self SetTimerss];
}

- (void) openURL:(NSString *)url {
    NSLog(@"start load url: %@", url);
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

- (void) notifyData:(NSNotification *)notification {
    NSString *name = notification.name;
    if ([name isEqualToString:@"PUSH_DATA"]) {
        // push数据
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *_actionDict = [[NSDictionary alloc] init];
        [userDefaults setObject:_actionDict forKey:@"PUSH_DATA"];
        [userDefaults synchronize];
        
        NSDictionary *actionDict = notification.userInfo;
        if (actionDict != nil) {
            [self.handler callJSFunc:self.webView funcName:@"g_recv_push_data" params:actionDict, nil];
        }
    } else if ([name isEqualToString:@"URL_DATA"]) {
        // url数据
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *_actionDict = [[NSDictionary alloc] init];
        [userDefaults setObject:_actionDict forKey:@"URL_DATA"];
        [userDefaults synchronize];
        
        NSDictionary *actionDict = notification.userInfo;
        if (actionDict != nil) {
            [self.handler callJSFunc:self.webView funcName:@"g_recv_url_data" params:actionDict, nil];
        }
    } else if ([name isEqualToString:@"PAUSE"]) {
        // 进入后台
        [self.handler callJSFunc:self.webView funcName:@"g_pause" params:nil];
    } else if ([name isEqualToString:@"RESUME"]) {
        // 进入前台
        [self.handler callJSFunc:self.webView funcName:@"g_resume" params:nil];
    } else if ([name isEqualToString:@"THIRDPARTY_LOGIN"]) {
        // 第三方登录
        NSDictionary *resultDict = notification.userInfo;
        [self.handler callJSFunc:self.webView funcName:@"g_thirdparth_login" params:resultDict[@"method"], resultDict[@"success"], resultDict[@"auth"], resultDict[@"info"], nil];
    }
}

@end
