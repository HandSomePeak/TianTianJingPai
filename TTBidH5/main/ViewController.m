//
//  ViewController.m
//  JinPai
//
//  Created by yangfeng on 2018/4/10.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Image.h"
#import "HomeVC.h"
#import "SecondVC.h"
#import "ThirdVC.h"
#import "FourVC.h"

@interface ViewController ()

@end

@implementation ViewController

// 什么时候调用：程序一启动的时候就会把所有的类加载进内存
// 作用：加载类的时候调用
//+ (void)load
//{
//
//}

// 什么调用：当第一次使用这个类或者子类的时候调用
// 作用：初始化类

// appearance只要一个类遵守UIAppearance，就能获取全局的外观，UIView

+ (void)initialize
{
    // 获取所有的tabBarItem外观标识
    //    UITabBarItem *item = [UITabBarItem appearance];
    
    // self -> CZTabBarController
    // 获取当前这个类下面的所有tabBarItem
//    UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:self, nil];
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSForegroundColorAttributeName] = [UIColor colorWithRed:206/255.0 green:45/255.0 blue:30/255.0 alpha:1.0];
    //    [att setObject:[UIColor orangeColor] forKey:NSForegroundColorAttributeName];
    [item setTitleTextAttributes:att forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 添加所有子控制器
    [self setUpAllChildViewController];
}

// Item:就是苹果的模型命名规范
// tabBarItem:决定着tabBars上按钮的内容
// 如果通过模型设置控件的文字颜色，只能通过文本属性（富文本：颜色，字体，空心，阴影，图文混排）

// 在ios7之后，默认会把UITabBar上面的按钮图片渲染成蓝色
#pragma mark - 添加所有的子控制器
- (void)setUpAllChildViewController
{
//    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"format" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
//    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//    NSLog(@"jsonObj = %@, %ld",jsonObj,jsonObj.count);
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"shop" ofType:@"plist"];
    NSMutableArray *shopArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    
    NSMutableArray *collArray = [NSMutableArray array];
    NSMutableArray *array_3 = [NSMutableArray array];
    for (int i = 0; i < shopArray.count; i ++) {
        NSDictionary *dic = shopArray[i];
        NSString *type = [NSString stringWithFormat:@"%@",dic[@"E"]];
        if ([type isEqualToString:@"热门商品"]) {
            [collArray addObject:dic];
        }
        if ([type isEqualToString:@"特价商品"]) {
            [array_3 addObject:dic];
        }
    }
    
    NSString *bannerPath = [[NSBundle mainBundle] pathForResource:@"bannerList" ofType:@"plist"];
    NSMutableArray *bannerArray = [[NSMutableArray alloc] initWithContentsOfFile:bannerPath];
    
    NSMutableArray *m_arr = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
        NSDictionary *dic = bannerArray[i];
        NSString *str = [NSString stringWithFormat:@"dh.bundle/banner/%@.jpg",dic[@"image"]];
        [m_arr addObject:str];
    }
    
    // 首页
    HomeVC *home = [[HomeVC alloc] init];
    home.ShopArr = shopArray;
    home.HotArr = collArray;
    home.LowArr = array_3;
    home.BannerArr = m_arr;
    UINavigationController *nav_1 = [[UINavigationController alloc]initWithRootViewController:home];
    [self setUpOneChildViewController:nav_1 image:[UIImage imageNamed:@"first1"] selectedImage:[UIImage imageWithOriginalName:@"first2"] title:@"首页"];
    home.view.backgroundColor = [UIColor whiteColor];
    
    // 分类
    SecondVC *message = [[SecondVC alloc] init];
    message.ShopArr = shopArray;
    message.HotArr = collArray;
    message.LowArr = array_3;
    message.BannerArr = m_arr;
    message.title = @"全部分类";
    UINavigationController *nav_2 = [[UINavigationController alloc]initWithRootViewController:message];
    [self setUpOneChildViewController:nav_2 image:[UIImage imageNamed:@"second1"] selectedImage:[UIImage imageWithOriginalName:@"second2"] title:@"全部分类"];
    message.view.backgroundColor = [UIColor whiteColor];
    
    // 购物清单
    ThirdVC *discover = [[ThirdVC alloc] init];
    discover.ShopArr = shopArray;
    discover.HotArr = collArray;
    discover.LowArr = array_3;
    discover.BannerArr = m_arr;
    discover.title = @"购物清单";
    UINavigationController *nav_3 = [[UINavigationController alloc]initWithRootViewController:discover];
    [self setUpOneChildViewController:nav_3 image:[UIImage imageNamed:@"third1"] selectedImage:[UIImage imageWithOriginalName:@"third2"] title:@"购物清单"];
    discover.view.backgroundColor = [UIColor whiteColor];
    
    // 个人
    FourVC *profile = [[FourVC alloc] init];
    profile.title = @"个人中心";
    UINavigationController *nav_4 = [[UINavigationController alloc]initWithRootViewController:profile];
    [self setUpOneChildViewController:nav_4 image:[UIImage imageNamed:@"four1"] selectedImage:[UIImage imageWithOriginalName:@"four2"] title:@"个人中心"];
    profile.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 添加一个子控制器
- (void)setUpOneChildViewController:(UINavigationController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title
{
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = image;
    
//    vc.tabBarItem.badgeValue = @"10";
    vc.tabBarItem.selectedImage = selectedImage;
    
    [self addChildViewController:vc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
