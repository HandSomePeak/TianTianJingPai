//
//  ShopDetailView.m
//  JinPai
//
//  Created by yangfeng on 2018/4/11.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import "ShopDetailView.h"

@implementation ShopDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat left = 10.5;
        CGFloat view_w = self.frame.size.width;
        CGFloat ty_w = 80;
        CGFloat bu_w = 80;
        
        self.pice = [[UILabel alloc] init];
        self.pice.frame = CGRectMake(left,10,view_w - left * 2,15);
//        self.pice.text = @"￥ 1643";
        self.pice.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:20];
        self.pice.textColor = [UIColor colorWithRed:228.0/255 green:57.0/255 blue:57.0/255 alpha:1];
        [self addSubview:self.pice];
        
        //
        self.message1 = [[UILabel alloc] init];
        self.message1.frame = CGRectMake(left,35,view_w - left * 2,14);
//        self.message1.text = @"Air Jordan 1 OG Bred Toe AJ1 乔1 黑脚趾";
        self.message1.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        self.message1.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
        [self addSubview:self.message1];
        
        //
        self.message2 = [[UILabel alloc] init];
        self.message2.frame = CGRectMake(left,55,view_w - left * 2 - ty_w,14);
//        self.message2.text = @"红黑 篮球鞋 555088-610";
        self.message2.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        self.message2.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
        [self addSubview:self.message2];
        
        self.type = [[UILabel alloc] init];
        self.type.frame = CGRectMake(view_w - left - ty_w,55,ty_w,14);
//        self.type.text = @"服装鞋类";
        self.type.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        self.type.textColor = [UIColor colorWithRed:182.0/255 green:182.0/255 blue:182.0/255 alpha:1];
        self.type.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.type];
        
        UIColor *color = [UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1];
        
        self.button1 = [[UIButton alloc]init];
        self.button1.frame = CGRectMake(left, 80, bu_w, 20);
        [self.button1 setTitle:@" 假一赔十" forState:UIControlStateNormal];
        [self.button1 setTitleColor:color forState:UIControlStateNormal];
        [self.button1 setImage:[UIImage imageNamed:@"buy1"] forState:UIControlStateNormal];
        self.button1.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        self.button1.adjustsImageWhenHighlighted = NO;
        [self addSubview:self.button1];
        
        self.button2 = [[UIButton alloc]init];
        self.button2.frame = CGRectMake(left * 2 + bu_w, 80, bu_w, 20);
        [self.button2 setTitle:@" 全场包邮" forState:UIControlStateNormal];
        [self.button2 setTitleColor:color forState:UIControlStateNormal];
        [self.button2 setImage:[UIImage imageNamed:@"buy2"] forState:UIControlStateNormal];
        self.button2.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        self.button2.adjustsImageWhenHighlighted = NO;
        [self addSubview:self.button2];
        
    }
    return self;
}

@end
