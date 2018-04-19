//
//  SecondVC.m
//  JinPai
//
//  Created by yangfeng on 2018/4/10.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import "SecondVC.h"
#import "CategoryCell.h"
#import "ShopDetailVC.h"

@interface SecondVC () <UICollectionViewDelegate, UICollectionViewDataSource> {
    CGFloat gap;
    UIView *heardView;
}
@property (nonatomic, strong) NSMutableArray *m_array;
@end

static NSString *CellIdentifier = @"CategoryCell";
static NSString *CellHeader = @"CellHeader";

@implementation SecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    gap = 15;
    CGFloat w = (self.view.frame.size.width - gap * 4) / 3;
    CGFloat h = (150.0 / 112.0) * w;
    [self initdata];
    //创建一个layout布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(gap, gap, gap, gap);
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake(w, h);
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 40);
    //创建collectionView 通过一个布局策略layout来创建
    UICollectionView * collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    collect.backgroundColor = [UIColor colorWithRed:246.0 / 255.0 green:246.0 / 255.0 blue:246.0 / 255.0 alpha:1.0];
    //代理设置
    collect.delegate = self;
    collect.dataSource = self;
    //注册item类型 这里使用系统的类型
    [collect registerClass:[CategoryCell class] forCellWithReuseIdentifier:CellIdentifier];
    //注册头视图
    [collect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellHeader];
    [self.view addSubview:collect];
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

- (void)initdata {
    NSMutableArray *arr_1 = [NSMutableArray array];
    NSMutableArray *arr_2 = [NSMutableArray array];
    NSMutableArray *arr_3 = [NSMutableArray array];
    NSMutableArray *arr_4 = [NSMutableArray array];
    NSMutableArray *arr_5 = [NSMutableArray array];
    NSMutableArray *arr_6 = [NSMutableArray array];
    for (int i = 0; i < self.ShopArr.count; i ++) {
        NSDictionary *dic = self.ShopArr[i];
        NSString *type = dic[@"G"];
        if ([type isEqualToString:@"潮流装扮"]) {
            [arr_1 addObject:dic];
        }
        else if ([type isEqualToString:@"装饰品"]) {
            [arr_2 addObject:dic];
        }
        else if ([type isEqualToString:@"生活用品"]) {
            [arr_3 addObject:dic];
        }
        else if ([type isEqualToString:@"家具"]) {
            [arr_4 addObject:dic];
        }
        else if ([type isEqualToString:@"首饰"]) {
            [arr_5 addObject:dic];
        }
        else {
            [arr_6 addObject:dic];
        }
    }
    self.m_array = [NSMutableArray array];
    [self.m_array addObject:self.HotArr];
    [self.m_array addObject:arr_1];
    [self.m_array addObject:arr_2];
    [self.m_array addObject:arr_3];
    [self.m_array addObject:arr_4];
    [self.m_array addObject:arr_5];
    [self.m_array addObject:arr_6];
}

//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.m_array.count;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *arr = self.m_array[section];
    return arr.count;
}

//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    NSArray *arr = self.m_array[indexPath.section];
    NSDictionary *dic = arr[indexPath.row];
    cell.name.text = dic[@"B"];
    NSString *imstr = [NSString stringWithFormat:@"dh.bundle/%@/main.jpg",dic[@"A"]];
    cell.imv.image = [UIImage imageNamed:imstr];
    cell.imv.contentMode = UIViewContentModeScaleAspectFill;
    cell.imv.layer.masksToBounds = YES;
    cell.imv.layer.cornerRadius = 5.0;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5.0;
    return cell;
}

/** 头部/底部*/
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSArray *hearArr = @[@[@"热门分类",@"HOT BRAND"],
                             @[@"潮流装扮",@"GEGE TREND"],
                             @[@"装饰品",@"DECORATION"],
                             @[@"生活用品",@"LIVING GOODS"],
                             @[@"家具",@"FURNITURE"],
                             @[@"首饰",@"JEWELRY"],
                             @[@"其他",@"OTHER"]];
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellHeader forIndexPath:indexPath];
        [heardView removeFromSuperview];
        // 头部
        heardView = [self titleview:40 array:hearArr[indexPath.section]];
        [view addSubview:heardView];
        return view;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath = %@",indexPath);
    ShopDetailVC *vc = [[ShopDetailVC alloc]init];
    NSArray *arr = self.m_array[indexPath.section];
    vc.dic = arr[indexPath.row];
    NSLog(@"dic = %@",arr[indexPath.row]);
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)titleview:(CGFloat)height array:(NSArray *)array{
    
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    vi.backgroundColor = [UIColor clearColor];

    CGFloat w = vi.frame.size.width;
    CGFloat h = vi.frame.size.height;
    CGFloat top = h * 0.2;
    CGFloat h1 = h * 0.5;
    CGFloat h2 = h * 0.3;
    
    UILabel *lab_1 = [[UILabel alloc]init];
    lab_1.frame = CGRectMake(10.0, top, w, h1);
    lab_1.text = array[0];
    lab_1.textColor = [UIColor blackColor];
    lab_1.font = [UIFont systemFontOfSize:15];
    [vi addSubview:lab_1];
    
    UILabel *lab_2 = [[UILabel alloc]init];
    lab_2.frame = CGRectMake(10.0, top + h1, w, h2);
    lab_2.text = array[1];
    lab_2.textColor = [UIColor lightGrayColor];
    lab_2.font = [UIFont systemFontOfSize:11];
    [vi addSubview:lab_2];
    
    return  vi;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
