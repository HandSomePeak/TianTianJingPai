//
//  ShoppingCarVC.m
//  JinPai
//
//  Created by yangfeng on 2018/4/11.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import "ShoppingCarVC.h"
#import "ShoppingCarCell.h"
#import "View1.h"
#import "PayVC.h"

@interface ShoppingCarVC () <UITableViewDelegate, UITableViewDataSource, ShoppingCarCellDelegate> {
    NSUserDefaults *def;
    NSMutableArray *m_array;
    UITableView *tab;
    View1 *v1;
}

@end

@implementation ShoppingCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    def = [NSUserDefaults standardUserDefaults];
    self.title = @"购物车";
    // 创建一个UIButton
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    // 创建一个UIButton
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 40, 40)];
    [saveButton setTitle:@"清空" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(editItemClick) forControlEvents:UIControlEventTouchUpInside];
    saveButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    [self initdata];
    
    [self createUI];
    
    [self refreshAllPice];
}

- (void)initdata {
    m_array = [NSMutableArray array];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *key = @"shoppingCar";
    id obj = [def objectForKey:key];
    if (obj != nil) {
        m_array = [NSMutableArray arrayWithArray:obj];
    }
}

- (void)createUI {
    
    CGFloat view_w = self.view.frame.size.width;
    CGFloat view_h = self.view.frame.size.height;
    CGFloat hh = 60;
    
    tab = [[UITableView alloc]init];
    tab.frame = CGRectMake(0, 0, view_w, view_h - hh);
    tab.delegate = self;
    tab.dataSource = self;
    tab.separatorStyle = UITableViewCellSelectionStyleNone;
    tab.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tab];
    
    v1 = [[[NSBundle mainBundle] loadNibNamed:@"View1" owner:nil options:nil] firstObject];
    v1.frame = CGRectMake(0, view_h - hh, view_w, hh);
    v1.backgroundColor = [UIColor whiteColor];
    v1.pay.layer.masksToBounds = YES;
    v1.pay.layer.cornerRadius = 5.0;
    [v1.pay addTarget:self action:@selector(PayButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [v1.allSelect addTarget:self action:@selector(AllSelectButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:v1];
    
    [self line:CGRectMake(0, view_h - hh - 1.0, view_w, 1.0)];
}

- (void)PayButtonMethod:(UIButton *)button {
    NSString *isselect = @"isselect";
    NSMutableArray *m_arr = [NSMutableArray array];
    for (int i = 0; i < m_array.count; i ++) {
        NSDictionary *dic = m_array[i];
        NSString *se = dic[isselect];
        if ([se isEqualToString:@"1"]) {
            [m_arr addObject:dic];
        }
    }
    if (m_arr.count <= 0) {
        NSLog(@"没有选择商品，不能结算");
        return;
    }
    PayVC *vc = [[PayVC alloc]init];
    vc.m_array = [NSMutableArray arrayWithArray:m_arr];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)line:(CGRect)frame {
    UIView *vi_2 = [[UIView alloc]initWithFrame:frame];
    vi_2.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    [self.view addSubview:vi_2];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return m_array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"tabcell";
    ShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShoppingCarCell" owner:nil options:nil] firstObject];
    }
    cell.delegate = self;
    tableView.rowHeight = 100;
    NSDictionary *dic = m_array[indexPath.row];
    NSString *imstr = [NSString stringWithFormat:@"dh.bundle/%@/main.jpg",dic[@"A"]];
    cell.imv.image = [UIImage imageNamed:imstr];
    cell.name.text = dic[@"B"];
    cell.message.text = dic[@"F"];
    if ([dic[@"E"] isEqualToString:@"特价商品"]) {
        cell.pice.text = [NSString stringWithFormat:@"￥ %@",dic[@"D"]];
    }
    else {
        cell.pice.text = [NSString stringWithFormat:@"￥ %@",dic[@"C"]];
    }
    cell.selectButton.tag = indexPath.row;
    cell.number.text = dic[@"count"];
    cell.imv.layer.masksToBounds = YES;
    cell.imv.layer.cornerRadius = 5.0;
    cell.selectButton.selected = NO;
    cell.addButton.tag = indexPath.row;
    cell.deleteButton.tag = indexPath.row;
    NSString *isselect = @"isselect";
    if ([[dic allKeys] containsObject:isselect]) {
        NSInteger k = [dic[isselect] integerValue];
        if (k == 1) {
            cell.selectButton.selected = YES;
        }
    }
    
    return cell;
}

- (void)DidSelectChooseButton:(UIButton *)button {
    button.selected = !button.selected;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *key = @"shoppingCar";
    NSString *isselect = @"isselect";
    
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:m_array[button.tag]];
    if (button.isSelected) {
        m_dic[isselect] = @"1";
    }
    else {
        m_dic[isselect] = @"0";
        v1.allSelect.selected = NO;
    }
    [m_array replaceObjectAtIndex:button.tag withObject:m_dic];
    [def setObject:m_array forKey:key];
    [tab reloadData];
    [self refreshAllPice];
}

- (void)DidSelectAddButton:(UIButton *)button {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *key = @"shoppingCar";
    NSString *count = @"count";
    
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:m_array[button.tag]];
    NSInteger k = [m_dic[count] integerValue];
    k ++;
    m_dic[count] = [NSString stringWithFormat:@"%ld",k];
    [m_array replaceObjectAtIndex:button.tag withObject:m_dic];
    [def setObject:m_array forKey:key];
    [tab reloadData];
    
    [self refreshAllPice];
}

- (void)DidSelectReduceButton:(UIButton *)button {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *key = @"shoppingCar";
    NSString *count = @"count";
    
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:m_array[button.tag]];
    NSInteger k = [m_dic[count] integerValue];
    k --;
    if (k <= 0) {
        k = 1;
    }
    m_dic[count] = [NSString stringWithFormat:@"%ld",k];
    [m_array replaceObjectAtIndex:button.tag withObject:m_dic];
    [def setObject:m_array forKey:key];
    [tab reloadData];
    [self refreshAllPice];
}

- (void)refreshAllPice {
    float k = 0.0;
    NSString *isselect = @"isselect";
    NSString *count = @"count";
    
    for (int i = 0; i < m_array.count; i ++) {
        NSDictionary *dic = m_array[i];
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
    }
    v1.pice.text = [NSString stringWithFormat:@"￥ %.2f",k];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)editItemClick {
    NSLog(@"编辑");
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *key = @"shoppingCar";
    [def removeObjectForKey:key];
    [self initdata];
    [self refreshAllPice];
    [tab reloadData];
}

- (void)AllSelectButtonMethod:(UIButton *)button {
    button.selected = !button.selected;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *key = @"shoppingCar";
    NSString *isselect = @"isselect";
    
    for (int i = 0; i < m_array.count; i ++) {
        NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:m_array[i]];
        if (button.isSelected) {
            m_dic[isselect] = @"1";
        }
        else {
            m_dic[isselect] = @"0";
        }
        [m_array replaceObjectAtIndex:i withObject:m_dic];
    }
    [def setObject:m_array forKey:key];
    [tab reloadData];
    [self refreshAllPice];
}

- (void)backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
