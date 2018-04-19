//
//  AboutUsVC.m
//  JinPai
//
//  Created by yangfeng on 2018/4/11.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import "AboutUsVC.h"

@interface AboutUsVC ()

@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];

    // 创建一个UIButton
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    CGFloat view_w = self.view.frame.size.width;
    CGFloat view_h = self.view.frame.size.height;
    CGFloat left = 10;
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, view_w, view_h)];
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scroll];
    
    UIImageView *imv = [[UIImageView alloc]init];
    imv.image = [UIImage imageNamed:@"aboutus"];
    imv.frame = CGRectMake(0, 0, view_w, (375.0 / 700.0) * (view_w));
    imv.contentMode = UIViewContentModeScaleAspectFill;
    [scroll addSubview:imv];
    
    UITextView *texeview = [[UITextView alloc]init];
    texeview.frame = CGRectMake(left, CGRectGetMaxY(imv.frame) + 30, view_w - left * 2, view_h - CGRectGetMaxY(imv.frame) - 30);
    texeview.text = @"诚信为本，合规经营\n\n公司坚持把发展作为第一要务，秉承\"诚信为本，合规经营\"的核心理念，以\"居实处厚，知明而行\"为核心价值观，倡导\"快乐工作、愉快生活\"的理念，努力培育具有中建投信托特色和时代特征的企业文化，营造积极、稳健、和谐的企业文化氛围，为公司发展提供有力的文化支撑。\n\n居实处厚，知明而行\n\n公司坚持把发展作为第一要务，倡导\"快乐工作、愉快生活\"的理念，努力培育具有中建投信托特色和时代特征的企业文化，营造积极、稳健、和谐的企业文化氛围，为公司发展提供有力的文化支撑。";
    texeview.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
    texeview.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
    texeview.editable = NO;
    [texeview sizeToFit];
    [scroll addSubview:texeview];
    
    scroll.contentSize = CGSizeMake(view_w, CGRectGetMaxY(texeview.frame));
    
}



- (void)backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
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
