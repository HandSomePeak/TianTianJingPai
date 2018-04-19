//
//  HomeVC.m
//  JinPai
//
//  Created by yangfeng on 2018/4/10.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import "HomeVC.h"
#import "HotSopVC.h"
#import "LowShopVC.h"
#import "ShopDetailVC.h"
#import "NetworkManager.h"
#import "AppDelegate.h"
#import "WKWebViewController.h"

@interface HomeVC () <UIScrollViewDelegate> {
    UIScrollView *scrollview;
    UIPageControl *pageC;
    NSArray *ImageArray;
    
    UIScrollView *collview;
    NSMutableArray *collArray;
    
    NSMutableArray *array_3;
    
    NSMutableArray *shopArray;
    NSMutableArray *bannerArray;
}

@property (nonatomic, retain)NSTimer* rotateTimer;  //让视图自动切换

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initdata];
    // 轮播图
    [self scrollerView];
    // 热门商品
    [self HotShop];
    
    [self JudgeJump];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.tabBarController.tabBar.hidden = YES;
}

//
- (void)JudgeJump {
    
    NetworkManager *net = [NetworkManager instance];
    [net checkAudit:^(BOOL success, NSDictionary *responseDict) {
        if (success) {
            NSLog(@"检测成功 = %@",responseDict);
            if (![[NSString stringWithFormat:@"%@",responseDict[@"audit"]] isEqualToString:@"1"]) {
                NSLog(@"跳转H5页面");
                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                [def setObject:@"1" forKey:@"reviewing"];
                
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                
                WKWebViewController *viewController = [[WKWebViewController alloc] init];
                window.rootViewController = viewController;
                [window makeKeyAndVisible];
            }
        }
    }];
}




- (void)initdata {
    shopArray = [NSMutableArray arrayWithArray:self.ShopArr];
    collArray = [NSMutableArray arrayWithArray:self.HotArr];
    array_3 = [NSMutableArray arrayWithArray:self.LowArr];
    ImageArray = [NSArray arrayWithArray:self.BannerArr];
}

#pragma mark - 热门商品
- (void)HotShop {
    
    CGFloat view_w = self.view.frame.size.width;
    CGFloat scr_h = self.view.frame.size.height - scrollview.frame.size.height - 40;
    CGFloat gap = 20;
    CGFloat bu_w = (view_w - gap * 4) / 3.0;
    CGFloat bu_h = bu_w * (132.0 / 112.0);
    
    collview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollview.frame), view_w, scr_h)];
    collview.showsHorizontalScrollIndicator = NO;
    collview.showsVerticalScrollIndicator = NO;
    collview.backgroundColor = [UIColor whiteColor];

    [self titleview:10 height:40 gap:20 tag:0 array:@[@"热门商品",@"HOT BRAND",@"更多商品"]];
    
    for (int i = 0; i < 3; i ++) {
        CGFloat y = i * (gap + bu_h) + 55;
        for (int j = 0; j < 3; j ++) {
            NSInteger k = i * 3 + j;
            CGFloat x = gap + j * (gap + bu_w);
            UIImageView *imv = [[UIImageView alloc]init];
            imv.frame = CGRectMake(x, y, bu_w, bu_h);
            imv.image = [UIImage imageNamed:@"main"];
            imv.contentMode = UIViewContentModeScaleAspectFill;
            imv.layer.masksToBounds = YES;
            imv.layer.cornerRadius = 5.0;
//            imv.alpha = 0.3;
            [collview addSubview:imv];
            
            UIView *vi = [[UIView alloc]initWithFrame:imv.frame];
            vi.backgroundColor = [UIColor blackColor];
            vi.alpha = 0.3;
            vi.layer.masksToBounds = YES;
            vi.layer.cornerRadius = 5.0;
            [collview addSubview:vi];
            
            UIButton *but = [[UIButton alloc]init];
            but.tag = k;
            but.frame = CGRectMake(x, y, bu_w, bu_h);
            [but setTitle:@"" forState:UIControlStateNormal];
            [but addTarget:self action:@selector(CollViewButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
            but.adjustsImageWhenHighlighted = NO;
            but.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:15];
            but.layer.masksToBounds = YES;
            but.layer.cornerRadius = 5.0;
            [collview addSubview:but];
            
            if (collArray.count > k) {
                NSDictionary *dic = collArray[k];
                NSString *imstr = [NSString stringWithFormat:@"dh.bundle/%@/main.jpg",dic[@"A"]];
//                NSLog(@"热门商品图片地址 = %@",imstr);
                //根据路径显示图片
                imv.image = [UIImage imageNamed:imstr];
                [but setTitle:dic[@"B"] forState:UIControlStateNormal];
            }
        }
    }
    
    CGFloat y = 45 + (bu_h + gap) * 3;
    [self titleview:y height:40 gap:20 tag:1 array:@[@"特惠商品",@"LIMTED SALE",@"更多特惠"]];
    
    CGFloat sc_w = 234.0 / 375.0 * view_w;
    CGFloat sc_h = (125.0 / 234.0) * sc_w;
    
    UIScrollView *sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, y + 45, self.view.frame.size.width, sc_h)];
    sc.contentSize = CGSizeMake(gap + (sc_w + gap) * array_3.count, sc_h);
    sc.showsHorizontalScrollIndicator = NO;
    sc.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < 5; i ++) {
        UIButton *but = [[UIButton alloc]init];
        but.tag = i;
        but.frame = CGRectMake(gap + i * (sc_w + gap), 0, sc_w, sc_h);
        [but setBackgroundImage:[UIImage imageNamed:@"main2"] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(LowShopButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        but.adjustsImageWhenHighlighted= NO;
        but.layer.masksToBounds = YES;
        but.layer.cornerRadius = 5.0;
        [sc addSubview:but];
        if (array_3.count > i) {
            NSDictionary *dic = array_3[i];
            NSString *imstr = [NSString stringWithFormat:@"dh.bundle/%@/main.jpg",dic[@"A"]];
//            NSLog(@"特惠商品图片地址 = %@",imstr);
            [but setBackgroundImage:[UIImage imageNamed:imstr] forState:UIControlStateNormal];
        }
    }
    
    [collview addSubview:sc];
    
    collview.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(sc.frame) + 20);
    
    [self.view addSubview:collview];
}

- (void)LowShopButtonMethod:(UIButton *)button {
    NSLog(@"点击了特惠商品");
    ShopDetailVC *vc = [[ShopDetailVC alloc]init];
    vc.dic = array_3[button.tag];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)titleview:(CGFloat)y height:(CGFloat)height gap:(CGFloat)gap tag:(NSInteger)tag array:(NSArray *)array{
    
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(gap, y, self.view.frame.size.width - gap * 2, height)];
    vi.backgroundColor = [UIColor whiteColor];
    [collview addSubview:vi];
    
    UIImageView *imv = [[UIImageView alloc]init];
    imv.frame = CGRectMake(0, 0, 5.0, vi.frame.size.height);
    imv.image = [UIImage imageNamed:@""];
    imv.contentMode = UIViewContentModeScaleAspectFit;
    [vi addSubview:imv];
    
    CGFloat w = (vi.frame.size.width - 5.0) / 2.0;
    CGFloat h = vi.frame.size.height;
    
    UILabel *lab_1 = [[UILabel alloc]init];
    lab_1.frame = CGRectMake(5.0, 0, w, h * 0.65);
    lab_1.text = array[0];
    lab_1.textColor = [UIColor blackColor];
    lab_1.font = [UIFont systemFontOfSize:15];
    [vi addSubview:lab_1];
    
    UILabel *lab_2 = [[UILabel alloc]init];
    lab_2.frame = CGRectMake(5.0, h * 0.7, w, h * 0.35);
    lab_2.text = array[1];
    lab_2.textColor = [UIColor lightGrayColor];
    lab_2.font = [UIFont systemFontOfSize:11];
    [vi addSubview:lab_2];
    
    UIButton *bu = [[UIButton alloc]init];
    bu.tag = tag;
    bu.frame = CGRectMake(vi.frame.size.width - 80, 0, 80, h);
    [bu setTitle:array[2] forState:UIControlStateNormal];
    [bu setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [bu addTarget:self action:@selector(jumpToMoreMethod:) forControlEvents:UIControlEventTouchUpInside];
    bu.titleLabel.font = [UIFont systemFontOfSize:14];
    [bu setImage:[UIImage imageNamed:@"leftImage"] forState:UIControlStateNormal];
    bu.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    bu.imageEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0);
    bu.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    bu.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [vi addSubview:bu];
}

- (void)jumpToMoreMethod:(UIButton *)button {
    NSLog(@"跳转到更多");
    switch (button.tag) {
        case 0: {
            HotSopVC *vc = [[HotSopVC alloc]init];
            vc.m_array = collArray;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            LowShopVC *vc = [[LowShopVC alloc]init];
            vc.m_array = array_3;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - CollViewButtonMethod
- (void)CollViewButtonMethod:(UIButton *)button {
    ShopDetailVC *vc = [[ShopDetailVC alloc]init];
    vc.dic = collArray[button.tag];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 轮播图
- (void)scrollerView {
    
    CGFloat view_w = self.view.frame.size.width;
    CGFloat scr_h = (214.0 / 375.0) * view_w;// h / w
    
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, view_w, scr_h)];
    scrollview.backgroundColor = [UIColor whiteColor];
    scrollview.pagingEnabled = YES;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.showsVerticalScrollIndicator = NO;
    //为滚动视图指定代理
    scrollview.delegate = self;
    scrollview.contentSize = CGSizeMake(view_w * ImageArray.count, 0);
    [self.view addSubview:scrollview];
    for (int i = 0; i < ImageArray.count; i ++) {
//        UIImageView *imv = [[UIImageView alloc]init];
//        imv.frame = CGRectMake(i * view_w, 0, view_w, scr_h);
//        imv.image = [UIImage imageNamed:ImageArray[i]];
//        imv.contentMode = UIViewContentModeScaleAspectFill;
//        [scrollview addSubview:imv];
        
        UIButton *but = [[UIButton alloc]init];
        but.tag = i;
        but.frame = CGRectMake(i * view_w, 0, view_w, scr_h);
        [but setBackgroundImage:[UIImage imageNamed:ImageArray[i]] forState:UIControlStateNormal];
        but.imageView.contentMode = UIViewContentModeScaleAspectFit;
        but.contentMode = UIViewContentModeScaleAspectFill;
        [but addTarget:self action:@selector(ButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        but.adjustsImageWhenHighlighted = NO;
        [scrollview addSubview:but];
    }
    
    
    
    pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollview.frame.size.height * 0.8, CGRectGetWidth(scrollview.frame), scrollview.frame.size.height * 0.2)];
    pageC.numberOfPages = ImageArray.count;
    pageC.currentPage = 0;
    pageC.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageC.currentPageIndicatorTintColor = [UIColor orangeColor];
    [self.view addSubview:pageC];
    
    //启动定时器
    self.rotateTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changeView) userInfo:nil repeats:YES];
    
}

#pragma mark - 轮播图点击方法
- (void)ButtonMethod:(UIButton *)button {
    NSDictionary *dic = bannerArray[button.tag];
    NSLog(@"url = %@",dic);
}

#pragma mark -- 滚动视图的代理方法
//开始拖拽的代理方法，在此方法中暂停定时器。
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    NSLog(@"正在拖拽视图，所以需要将自动播放暂停掉");
    [self.rotateTimer setFireDate:[NSDate distantFuture]];
}

//视图静止时（没有人在拖拽），开启定时器，让自动轮播
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.rotateTimer setFireDate:[NSDate dateWithTimeInterval:1.5 sinceDate:[NSDate date]]];
    CGFloat x = scrollview.contentOffset.x / scrollview.frame.size.width;
    pageC.currentPage = x;
}


//定时器的回调方法   切换界面
- (void)changeView {
    //通过改变contentOffset来切换滚动视图的子界面
    CGFloat offset_X = scrollview.contentOffset.x / scrollview.frame.size.width;
    offset_X ++;
    if (offset_X >= ImageArray.count) {
        pageC.currentPage = 0;
    }
    else {
        pageC.currentPage ++;
    }
    [scrollview setContentOffset:CGPointMake(CGRectGetWidth(scrollview.frame) * pageC.currentPage, 0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
