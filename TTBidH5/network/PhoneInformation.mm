//
//  NSObject+PhoneInformation.m
//  TTBidH5
//
//  Created by ysx on 2018/4/4.
//  Copyright © 2018年 ysx. All rights reserved.
//

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <AdSupport/AdSupport.h>

#import <sys/utsname.h>
#import <sys/sysctl.h>
#import <string>

#import <UMAnalytics/MobClick.h>
#import "PhoneInformation.h"
#import "Config.h"

@implementation PhoneInformation

+ (NSMutableDictionary *) keychainDict:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword, (id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (NSString *) loadDeviceID {
    NSString *service = [NSString stringWithFormat:@"KEYCHAIN_SERVER_%@", @CHANNEL_NAME];
    NSMutableDictionary *deviceDict = nil;
    NSMutableDictionary *keychainDict = [PhoneInformation keychainDict:service];
    [keychainDict setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainDict setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainDict, (CFTypeRef *)&keyData) == noErr) {
        @try {
            deviceDict = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    
    NSString *ret = @"";
    if (deviceDict == nil) {
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            // idfa
            ret = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
        } else {
            // idfv
            ret = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        }
        
        if ([ret length] <= 0) {
            // 如果都拿不到
            ret = @"unknow";
        }
        
        if (![ret isEqualToString:@"unknow"]) {
            // 保存
            NSMutableDictionary *_deviceDict = [[NSMutableDictionary alloc] init];
            [_deviceDict setObject:ret forKey:@"device_id"];
            
            NSMutableDictionary *keychainDict = [PhoneInformation keychainDict:service];
            SecItemDelete((CFDictionaryRef)keychainDict);
            [keychainDict setObject:[NSKeyedArchiver archivedDataWithRootObject:_deviceDict] forKey:(id)kSecValueData];
            SecItemAdd((CFDictionaryRef)keychainDict, NULL);
        } else {
            // 重置
            NSMutableDictionary *keychainDict = [PhoneInformation keychainDict:service];
            SecItemDelete((CFDictionaryRef)keychainDict);
        }
    } else {
        NSString *deviceID = [deviceDict objectForKey:@"device_id"];
        if (deviceID != nil) {
            ret = deviceID;
        } else {
            // 重置
            NSMutableDictionary *keychainDict = [PhoneInformation keychainDict:service];
            SecItemDelete((CFDictionaryRef)keychainDict);
            ret = @"unkonw";
        }
    }
    return ret;
}

+ (NSDictionary *) deviceInfos {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@PLATFORM forKey:@"platform"];
    [dict setObject:@CHANNEL_NAME forKey:@"app-chn"];
    
    // app ver
    static NSString *app_ver = nil;
    if (app_ver == nil) {
        app_ver = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    }
    [dict setObject:app_ver forKey:@"app-ver"];
    
    // os ver
    static NSString *os_ver = nil;
    if (os_ver == nil) {
        os_ver = [[UIDevice currentDevice] systemVersion];
    }
    [dict setObject:os_ver forKey:@"os-ver"];
    
    // model
    static NSString *model = nil;
    if (model == nil) {
        const char *name = "hw.machine";
        size_t size;
        sysctlbyname(name, NULL, &size, NULL, 0);
        char *answer = (char *)malloc(size);
        sysctlbyname(name, answer, &size, NULL, 0);
        std::string _model = std::string(answer, size);
        model = [NSString stringWithUTF8String:_model.c_str()];
        free(answer);
    }
    [dict setObject:model forKey:@"model"];
    
    // idfa
    static NSString *idfa = nil;
    if (idfa == nil) {
        idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
    }
    [dict setObject:idfa forKey:@"idfa"];
    
    // idfv
    static NSString *idfv = nil;
    if (idfv == nil) {
        idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    [dict setObject:idfv forKey:@"idfv"];
    
    // device id
    static NSString *deviceID = nil;
    if (deviceID == nil) {
        deviceID = [PhoneInformation loadDeviceID];
    }
    [dict setObject:deviceID forKey:@"device-id"];
    
    // sim
    static NSString *sim = nil;
    if (sim == nil) {
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = [info subscriberCellularProvider];
        
        if (!carrier.isoCountryCode) {
            sim = @"0";
        } else {
            sim = @"1";
        }
    }
    [dict setObject:sim forKey:@"sim"];
    
    // carrier
    static NSString *carrier = nil;
    if (carrier == nil) {
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *_carrier = [info subscriberCellularProvider];
        
        if (_carrier.isoCountryCode) {
            carrier = [_carrier carrierName];
        } else {
            carrier = @"unknow";
        }
    }
    [dict setObject:carrier forKey:@"carrier"];
    
    // network
    static NSString *network = nil;
    if (network == nil) {
        NSArray *subviews;
        UIApplication *application = [UIApplication sharedApplication];
        if ([[application valueForKeyPath:@"_statusBar"] isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
            subviews = [[[[application valueForKeyPath:@"_statusBar"] valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
        } else {
            subviews = [[[application valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
        }
        
        NSNumber *dataNetworkItemView = nil;
        for (id subview in subviews) {
            if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
                dataNetworkItemView = subview;
                break;
            }
        }
        
        switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"] integerValue]) {
            case 0:
                network = @"unkonw";
                break;
            case 1:
                network = @"2G";
                break;
            case 2:
                network = @"3G";
                break;
            case 3:
                network = @"4G";
                break;
            case 4:
                network = @"LTE";
                break;
            case 5:
                network = @"Wifi";
                break;
            default:
                network = @"unknow";
                break;
        }
    }
    [dict setObject:network forKey:@"network"];
    
    // 越狱
    if (MobClick.isJailbroken) {
        [dict setObject:@"1" forKey:@"jailbreak"];
    } else {
        [dict setObject:@"1" forKey:@"jailbreak"];
    }
    
    // UserAgent
    static NSString *userAgent = nil;
    if (userAgent == nil) {
        float scale = [UIScreen mainScreen].scale;
        userAgent = [NSString stringWithFormat:@"LEWAN/%@ (%@; iOS %@; Scale/%.2f)", app_ver, model, os_ver, scale];
    }
    [dict setObject:userAgent forKey:@"User-Agent"];
    
    return dict;
}

@end
