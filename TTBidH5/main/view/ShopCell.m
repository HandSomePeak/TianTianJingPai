//
//  ShopCell.m
//  JinPai
//
//  Created by yangfeng on 2018/4/10.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import "ShopCell.h"

@implementation ShopCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ShopCell" owner:self options:nil].lastObject;
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

@end
