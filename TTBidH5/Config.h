//
//  Config.h
//  TTBidH5
//
//  Created by ysx on 2018/4/3.
//  Copyright © 2018年 ysx. All rights reserved.
//

#ifndef Config_h
#define Config_h

#ifndef UMENG_KEY
#define UMENG_KEY "59845c63b27b0a447500157d"
#endif

#ifndef TENCENT_APP_ID
#define TENCENT_APP_ID "1106241562"
#endif

#ifndef WECHAT_APP_ID
#define WECHAT_APP_ID "wx9f95e0ee00fae117"
#endif

#ifndef WEIBO_APP_ID
#define WEIBO_APP_ID "919471612"
#endif

#ifndef REQUEST_URL
#if DEBUG
#define REQUEST_URL "https://beta.ttbid.net"
#else
#define REQUEST_URL "https://api.ttbid.net"
#endif
#endif

#ifndef PLATFORM
#define PLATFORM "ios"
#endif

#ifndef LWLOG
#if DEBUG
#define LWLOG(var...) \
printf(var); \
printf("\n")
#else
#define LWLOG(var...) \
do{} while(0)
#endif
#endif


#pragma mark - 渠道定义

#ifndef TTBID_XYDB_CHANNEL_CODE
#define TTBID_XYDB_CHANNEL_CODE 1001
#endif

#ifndef CHANNEL_CODE
#error "must set CHANNEL_CODE=1001 in Macros settings"
#endif

#ifndef CHANNEL_NAME
#if CHANNEL_CODE == TTBID_XYDB_CHANNEL_CODE
#define CHANNEL_NAME "ttbid-xydb"           // 幸运兑宝
#else
#error "must set CHANNEL_CODE=1001 in Macros settings"
#endif
#endif

#ifndef CONFUSION_CLASS
#define CONFUSION_CLASS(value) TTBID##value
#endif

#ifndef CONFUSION_FUNC
#define CONFUSION_FUNC(value) TTBID##value
#endif

#ifndef CONFUSION_PARAM
#define CONFUSION_PARAM(value) TTBID##value
#endif

#ifndef SPAM_CODE
#define SPAM_CODE(index) \
do{} while(0)
#endif

#endif /* Config_h */
