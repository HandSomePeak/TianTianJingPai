//
//  ThirdVC.m
//  JinPai
//
//  Created by yangfeng on 2018/4/10.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import "ThirdVC.h"
#import "BuyListCell.h"

@interface ThirdVC () <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *m_array;
    UITableView *tab;
}

@end

@implementation ThirdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    CGFloat view_w = self.view.frame.size.width;
    CGFloat view_h = self.view.frame.size.height;
    CGFloat hh = 0;
    tab = [[UITableView alloc]init];
    tab = [[UITableView alloc]init];
    tab.frame = CGRectMake(0, 0, view_w, view_h - hh);
    tab.delegate = self;
    tab.dataSource = self;
    tab.backgroundColor = [UIColor whiteColor];
    tab.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tab];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self initData];
    [tab reloadData];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)initData {
    m_array = [NSMutableArray array];
    NSString *key = @"alreadybuy";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    id obj = [def objectForKey:key];
    if (key != nil) {
        m_array = [NSMutableArray arrayWithArray:obj];
    }
//    for (int i = 0; i < 5; i ++) {
//        int x = arc4random() % self.ShopArr.count;
//        NSDictionary *dic = self.ShopArr[x];
//        [m_array addObject:dic];
//    }
}

- (float)subMoney:(NSDictionary *)dic {
    float k = 0.0;
    NSString *isselect = @"isselect";
    NSString *count = @"count";
    if ([dic[isselect] isEqualToString:@"1"]) {
        NSInteger num = [dic[count] integerValue];
        float pice = 0.0;
        if ([dic[@"E"] isEqualToString:@"特价商品"]) {
            pice = [dic[@"D"] floatValue];
        }
        else {
            pice = [dic[@"C"] floatValue];
        }
        CGFloat all = pice * num;
        k += all;
    }
    return k;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return m_array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"tabcell";
    BuyListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BuyListCell" owner:nil options:nil] firstObject];
    }
    // 不显示分割线
    tableView.separatorStyle = UITableViewCellEditingStyleNone;
    tableView.rowHeight = 215;
    NSDictionary *dic = m_array[indexPath.row];
    NSString *imstr = [NSString stringWithFormat:@"dh.bundle/%@/main.jpg",dic[@"A"]];
    cell.imv.image = [UIImage imageNamed:imstr];
    cell.imv.layer.masksToBounds = YES;
    cell.imv.layer.cornerRadius = 5.0;
    cell.name.text = dic[@"B"];
    cell.message.text = dic[@"F"];
    CGFloat allpice = [self subMoney:dic];
    if ([dic[@"E"] isEqualToString:@"特价商品"]) {
        cell.pice.text = [NSString stringWithFormat:@"￥ %@",dic[@"D"]];
    }
    else {
        cell.pice.text = [NSString stringWithFormat:@"￥ %@",dic[@"C"]];
    }
    cell.count.text = [NSString stringWithFormat:@"x %@",dic[@"count"]];
    
    cell.lab1.text = @"交易单号：A064714";
    cell.lab2.text = [NSString stringWithFormat:@"交易时间：%@",dic[@"time"]];
    cell.lab3.text = [NSString stringWithFormat:@"交易金额: ￥ %.2f",allpice];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
