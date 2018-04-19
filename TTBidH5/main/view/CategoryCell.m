//
//  CategoryCell.m
//  JinPai
//
//  Created by yangfeng on 2018/4/12.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CategoryCell" owner:self options:nil].lastObject;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
