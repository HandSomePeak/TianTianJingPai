//
//  LowShopVC.m
//  JinPai
//
//  Created by yangfeng on 2018/4/10.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import "LowShopVC.h"
#import "LowShopCell.h"
#import "ShopDetailVC.h"

@interface LowShopVC ()<UICollectionViewDelegate, UICollectionViewDataSource> {
    
    CGFloat gap;
}

@end

static NSString *CellIdentifier = @"LowShopCell";

@implementation LowShopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initdata];
    self.title = @"特惠商品";
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat w = (self.view.frame.size.width - gap * 2);
    CGFloat h = (190.0 / 355.0) * w;
    
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(gap, gap, gap, gap);
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake(w, h);
    //创建collectionView 通过一个布局策略layout来创建
    UICollectionView * collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    collect.backgroundColor = [UIColor colorWithRed:246.0 / 255.0 green:246.0 / 255.0 blue:246.0 / 255.0 alpha:1.0];
    //代理设置
    collect.delegate = self;
    collect.dataSource = self;
    //注册item类型 这里使用系统的类型
    [collect registerClass:[LowShopCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    [self.view addSubview:collect];
    
    //创建一个UIButton
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initdata {
    gap = 15;
}

//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.m_array.count;
}

//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LowShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *dic = self.m_array[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.name.text = dic[@"B"];
    cell.pice.text = [NSString stringWithFormat:@"￥ %@",dic[@"D"]];
    NSString *imstr = [NSString stringWithFormat:@"dh.bundle/%@/main.jpg",dic[@"A"]];
    cell.imv.image = [UIImage imageNamed:imstr];
    cell.imv.contentMode = UIViewContentModeScaleAspectFill;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5.0;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath = %@",indexPath);
    ShopDetailVC *vc = [[ShopDetailVC alloc]init];
    vc.dic = self.m_array[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
