//
//  FourVC.m
//  JinPai
//
//  Created by yangfeng on 2018/4/10.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import "FourVC.h"
#import "AddressVC.h"
#import "SettingVC.h"
#import "CallUsVC.h"
#import "AboutUsVC.h"
#import "WKWebViewController.h"

@interface FourVC ()

@end

@implementation FourVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat view_w = self.view.frame.size.width;
    CGFloat view_h = self.view.frame.size.height - 64;
    CGFloat imv1_h = (241.0 / 375.0) * view_w;
    CGFloat imv_w = 85;
    
    UIImageView *imv1 = [[UIImageView alloc]init];
    imv1.frame = CGRectMake(0, 64, view_w, imv1_h);
    imv1.image = [UIImage imageNamed:@"center"];
    imv1.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imv1];
    
    UIImageView *imv2 = [[UIImageView alloc]init];
    imv2.frame = CGRectMake((view_w - imv_w) / 2.0, 64 + (imv1_h - imv_w) / 2.0, imv_w, imv_w);
    imv2.image = [UIImage imageNamed:@"selfImage"];
    imv2.contentMode = UIViewContentModeScaleAspectFit;
    imv2.layer.masksToBounds = YES;
    imv2.layer.cornerRadius = imv_w / 2.0;
    [self.view addSubview:imv2];
    
    CGFloat y = CGRectGetMaxY(imv1.frame);
    CGFloat left = 10;
    CGFloat bu_w = (view_w - left * 2) / 2.0;
    CGFloat bu_h = (view_h - y) / 2.0;
    
    NSArray *titleArr = @[@"地址管理",@"设置",@"联系我们",@"关于我们"];
    NSArray *imageArr = @[@"center1",@"center2",@"center3",@"center4"];
    
    for (int i = 0; i < 2; i ++) {
        CGFloat y1 = y + i * bu_h;
        for (int j = 0; j < 2; j ++) {
            NSInteger k = i * 2 + j;
            CGFloat x1 = left + j * bu_w;
            UIButton *button1 = [[UIButton alloc]init];
            button1.frame = CGRectMake(x1, y1, bu_w, bu_h);
            button1.tag = k;
            [button1 setTitle:titleArr[k] forState:UIControlStateNormal];
            [button1 setTitleColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1] forState:UIControlStateNormal];
            [button1 setImage:[UIImage imageNamed:imageArr[k]] forState:UIControlStateNormal];
            button1.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
            button1.adjustsImageWhenHighlighted = NO;
            [button1 addTarget:self action:@selector(ButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
            CGFloat imageW = button1.imageView.frame.size.width;
            CGFloat imageH = button1.imageView.frame.size.height;
            CGFloat titleW = button1.titleLabel.frame.size.width;
            CGFloat titleH = button1.titleLabel.frame.size.height;
            //图片上文字下
            [button1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageW, -imageH - 10, 0.f)];
            [button1 setImageEdgeInsets:UIEdgeInsetsMake(-titleH, 0.f, 0.f,-titleW)];
            [self.view addSubview:button1];
        }
    }
    
    CGFloat le = 40;
    UIView *vi_1 = [[UIView alloc]initWithFrame:CGRectMake(le, y + bu_h, view_w - le * 2, 1.0)];
    vi_1.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    [self.view addSubview:vi_1];
    
    UIView *vi_2 = [[UIView alloc]initWithFrame:CGRectMake(view_w / 2.0, y + le, 1.0, bu_h * 2 - le * 2)];
    vi_2.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    [self.view addSubview:vi_2];
    
}

- (void)ButtonMethod:(UIButton *)button {
    NSLog(@"ButtonMethod = %ld",button.tag);
    switch (button.tag) {
        case 0: {
            AddressVC *vc = [[AddressVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            SettingVC *vc = [[SettingVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2: {
            CallUsVC *vc = [[CallUsVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3: {
            WKWebViewController *vc = [[WKWebViewController alloc]init];
            [vc openURL:@"https://share.ttbid.net/bid/help"];
            [self.navigationController pushViewController:vc animated:YES];

//            AboutUsVC *vc = [[AboutUsVC alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
