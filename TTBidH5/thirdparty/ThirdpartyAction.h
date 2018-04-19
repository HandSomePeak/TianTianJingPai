//
//  ThirdpartyAction.h
//  TTBidH5
//
//  Created by ysx on 2018/4/13.
//  Copyright © 2018年 ysx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThirdpartyAction : NSObject

- (void) login;
- (void) postLoginResult:(NSString *)method success:(BOOL)success auth:(NSDictionary *)authDict info:(NSString *)info;

@end
