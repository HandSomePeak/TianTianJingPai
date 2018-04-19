//
//  ShopDetailVC.m
//  JinPai
//
//  Created by yangfeng on 2018/4/10.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import "ShopDetailVC.h"
#import "ShopDetailView.h"
#import "PayVC.h"
#import "ShoppingCarVC.h"

@interface ShopDetailVC () <UIScrollViewDelegate> {
    UIScrollView *scrollview;
    UIPageControl *pageC;
    NSArray *ImageArray;
    
    UITextView *textview;
}

@property (nonatomic, retain)NSTimer* rotateTimer;  //让视图自动切换

@end

@implementation ShopDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initdata];
    CGFloat view_w = self.view.frame.size.width;
    CGFloat view_h = self.view.frame.size.height;
    self.view.backgroundColor = [UIColor whiteColor];
    // 轮播图
    [self scrollerView];
    
    //创建一个UIButton
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *bu1 = [[UIButton alloc]initWithFrame:CGRectMake(view_w - 80, 20, 40, 40)];
    [bu1 setImage:[UIImage imageNamed:@"home1"] forState:UIControlStateNormal];
    [bu1 addTarget:self action:@selector(homeItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bu1];
    
    UIButton *bu2 = [[UIButton alloc]initWithFrame:CGRectMake(view_w - 40, 20, 40, 40)];
    [bu2 setImage:[UIImage imageNamed:@"add1"] forState:UIControlStateNormal];
    [bu2 addTarget:self action:@selector(addItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bu2];
    
    ShopDetailView *de = [[ShopDetailView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollview.frame), view_w, 110)];
    de.backgroundColor = [UIColor whiteColor];
    if ([self.dic[@"E"] isEqualToString:@"特价商品"]) {
        de.pice.text = [NSString stringWithFormat:@"￥ %@",self.dic[@"D"]];
    }
    else {
        de.pice.text = [NSString stringWithFormat:@"￥ %@",self.dic[@"C"]];
    }
    de.message1.text = self.dic[@"B"];
    de.message2.text = self.dic[@"I"];
    de.type.text = self.dic[@"G"];
    [self.view addSubview:de];
    
    CGFloat y = CGRectGetMaxY(de.frame) + 10;
    CGFloat vi_h = 50;
    CGFloat left = 10.5;
    
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, y - 10, view_w, 10)];
    vi.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    [self.view addSubview:vi];
    
    textview = [[UITextView alloc]initWithFrame:CGRectMake(left, y, view_w - left * 2, view_h - y - vi_h)];
    textview.text = @"商品详情";
    textview.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    textview.textColor = [UIColor colorWithRed:182.0/255 green:182.0/255 blue:182.0/255 alpha:1];
    textview.backgroundColor = [UIColor whiteColor];
    [textview setEditable:NO];
    textview.text = self.dic[@"F"];
    [self.view addSubview:textview];
    
    UIView *vi_1 = [[UIView alloc]initWithFrame:CGRectMake(0, view_h - vi_h, view_w, 1.0)];
    vi_1.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    [self.view addSubview:vi_1];
    
    CGFloat gap = 10;
    CGFloat base_w = (view_w - gap * 4.0) / 7.0;
    
    UIButton *button1 = [[UIButton alloc]init];
    button1.frame = CGRectMake(gap, view_h - vi_h, base_w * 2, vi_h);
    [button1 setTitle:@"客服" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1] forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"kefu2"] forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
    button1.adjustsImageWhenHighlighted = NO;
    [button1 addTarget:self action:@selector(kefuButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat imageW = button1.imageView.frame.size.width;
    CGFloat imageH = button1.imageView.frame.size.height;
    CGFloat titleW = button1.titleLabel.frame.size.width;
    CGFloat titleH = button1.titleLabel.frame.size.height;
    //图片上文字下
    [button1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageW, -imageH - 10, 0.f)];
    [button1 setImageEdgeInsets:UIEdgeInsetsMake(-titleH, 0.f, 0.f,-titleW)];

    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc]init];
    button2.frame = CGRectMake(gap + CGRectGetMaxX(button1.frame), view_h - vi_h, base_w * 2, vi_h);
    [button2 setImage:[UIImage imageNamed:@"buy3"] forState:UIControlStateNormal];
    button2.adjustsImageWhenHighlighted = NO;
    button2.contentMode = UIViewContentModeScaleAspectFit;
    [button2 addTarget:self action:@selector(addButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
 
    UIButton *button3 = [[UIButton alloc]init];
    button3.frame = CGRectMake(gap + CGRectGetMaxX(button2.frame), view_h - vi_h, base_w * 3, vi_h);
    [button3 setImage:[UIImage imageNamed:@"buy4"] forState:UIControlStateNormal];
    button3.adjustsImageWhenHighlighted = NO;
    button3.contentMode = UIViewContentModeScaleAspectFit;
    [button3 addTarget:self action:@selector(buyButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
}

#pragma mark - 客服 方法
- (void)kefuButtonMethod:(UIButton *)button {
    NSLog(@"客服");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"客服联系电话" message:@"020-28888888" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *queue = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:queue];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 加入购物车 方法
- (void)addButtonMethod:(UIButton *)button {
    NSLog(@"加入购物车");
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *key = @"shoppingCar";
    NSString *count = @"count";
    id obj = [def objectForKey:key];
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:self.dic];
    if (obj == nil) {
        NSMutableArray *arr = [NSMutableArray array];
        m_dic[count] = @"1";
        [arr addObject:m_dic];
        [def setObject:arr forKey:key];
    }
    else {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:obj];
        NSInteger flg = 0;
        for (int i = 0; i < arr.count; i ++) {
            NSDictionary *dic = arr[i];
            // 说明添加的是同一种商品，则购买个数加1
            if ([dic[@"A"] isEqualToString:self.dic[@"A"]]) {
                NSInteger k = [dic[count] integerValue];
                k ++;
                m_dic[count] = [NSString stringWithFormat:@"%ld",k];
                [arr replaceObjectAtIndex:i withObject:m_dic];
                [def setObject:arr forKey:key];
                flg = 1;
                break;
            }
        }
        if (flg == 0) {
            m_dic[count] = @"1";
            [arr addObject:m_dic];
            [def setObject:arr forKey:key];
        }
    }
    ShoppingCarVC *vc = [[ShoppingCarVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 立即购买 方法
- (void)buyButtonMethod:(UIButton *)button {
    NSLog(@"立即购买");
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:self.dic];
    m_dic[@"count"] = @"1";
    m_dic[@"isselect"] = @"1";
    PayVC *vc = [[PayVC alloc]init];
    vc.m_array = [NSMutableArray arrayWithObject:m_dic];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 主页
- (void)homeItemClick {
    NSLog(@"主页");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 购物车
- (void)addItemClick {
    NSLog(@"购物车");
    ShoppingCarVC *vc = [[ShoppingCarVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)initdata {
    NSMutableArray *allArr;
    NSArray *arr = [NSArray arrayWithArray:self.dic[@"K"]];
    if (arr.count < 3) {
        allArr = [NSMutableArray arrayWithArray:self.dic[@"L"]];
    }
    else {
        allArr = [NSMutableArray arrayWithArray:arr];
    }
    NSMutableArray *imstr = [NSMutableArray array];
    for (int i = 0; i < allArr.count; i ++) {
        NSString *str = [NSString stringWithFormat:@"dh.bundle/%@",allArr[i]];
        [imstr addObject:str];
    }
    ImageArray = [NSArray arrayWithArray:imstr];
}

#pragma mark - 轮播图
- (void)scrollerView {
    
    CGFloat view_w = self.view.frame.size.width;
    CGFloat scr_h = (352.0 / 375.0) * view_w;// h / w
    
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, view_w, scr_h)];
    scrollview.contentSize = CGSizeMake(view_w * ImageArray.count, 0);
    scrollview.pagingEnabled = YES;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.showsVerticalScrollIndicator = NO;
    
    for (int i = 0; i < ImageArray.count; i ++) {
        
        UIImageView *imv = [[UIImageView alloc]init];
        imv.frame = CGRectMake(i * scrollview.frame.size.width, 0, scrollview.frame.size.width, scrollview.frame.size.height);
        imv.image = [UIImage imageNamed:ImageArray[i]];
        imv.contentMode = UIViewContentModeScaleAspectFill;
        [scrollview addSubview:imv];
        
//        UIButton *but = [[UIButton alloc]init];
//        but.tag = i;
//        but.frame = CGRectMake(i * scrollview.frame.size.width, 0, scrollview.frame.size.width, scrollview.frame.size.height);
//        [but setBackgroundImage:[UIImage imageNamed:ImageArray[i]] forState:UIControlStateNormal];
//        [but addTarget:self action:@selector(ButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
//        but.adjustsImageWhenHighlighted = NO;
//        [scrollview addSubview:but];
    }
    [self.view addSubview:scrollview];
    
    pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollview.frame.size.height * 0.8, CGRectGetWidth(scrollview.frame), scrollview.frame.size.height * 0.2)];
    pageC.numberOfPages = ImageArray.count;
    pageC.currentPage = 0;
    pageC.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageC.currentPageIndicatorTintColor = [UIColor orangeColor];
    [self.view addSubview:pageC];
    
    //启动定时器
    self.rotateTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changeView) userInfo:nil repeats:YES];
    //为滚动视图指定代理
    scrollview.delegate = self;
}

#pragma mark - 轮播图点击方法
- (void)ButtonMethod:(UIButton *)button {
    NSLog(@"轮播图点击方法 = %ld",button.tag);
}

#pragma mark -- 滚动视图的代理方法
//开始拖拽的代理方法，在此方法中暂停定时器。
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //    NSLog(@"正在拖拽视图，所以需要将自动播放暂停掉");
    //setFireDate：设置定时器在什么时间启动
    //[NSDate distantFuture]:将来的某一时刻
    [self.rotateTimer setFireDate:[NSDate distantFuture]];
    //    CGFloat x = scrollview.contentOffset.x / scrollview.frame.size.width;
}
//视图静止时（没有人在拖拽），开启定时器，让自动轮播
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //视图静止之后，过1.5秒在开启定时器
    //    NSLog(@"开启定时器");
    [self.rotateTimer setFireDate:[NSDate dateWithTimeInterval:1.5 sinceDate:[NSDate date]]];
    //
    CGFloat x = scrollview.contentOffset.x / scrollview.frame.size.width;
    //    NSLog(@"x = %f",x);
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
