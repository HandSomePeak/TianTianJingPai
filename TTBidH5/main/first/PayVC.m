//
//  PayVC.m
//  JinPai
//
//  Created by yangfeng on 2018/4/11.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import "PayVC.h"
#import "payView.h"
#import "AddressVC.h"
#import "AddressView.h"
#import "PayCell.h"
#import "PiceView.h"
#import "NetworkManager.h"

@interface PayVC () <UITableViewDelegate, UITableViewDataSource> {
    UIButton *address;
    payView *payview;
    AddressView *addview;
    
}

@end

@implementation PayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1];
    self.title = @"支付";
    //创建一个UIButton
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self createUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    id obj1 = [def objectForKey:@"address1"];
    id obj2 = [def objectForKey:@"address2"];
    id obj3 = [def objectForKey:@"name"];
    id obj4 = [def objectForKey:@"phone"];
    if (obj1 != nil &&
        obj2 != nil &&
        obj3 != nil &&
        obj4 != nil) {
        address.hidden = NO;
        
        addview = [[[NSBundle mainBundle] loadNibNamed:@"AddressView" owner:nil options:nil] firstObject];
        addview.backgroundColor = [UIColor whiteColor];
        addview.frame = address.frame;
        addview.name.text = [NSString stringWithFormat:@"收货人: %@",obj3];
        addview.phone.text = [NSString stringWithFormat:@"%@",obj4];
        addview.address.text = [NSString stringWithFormat:@"收货地址: %@%@",obj1,obj2];
        [addview.button addTarget:self action:@selector(addressButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addview];
    }
}

- (void)createUI {
    
    CGFloat view_w = self.view.frame.size.width;
    CGFloat view_h = self.view.frame.size.height;
    CGFloat gap = 10;
    CGFloat ad_h = 60;
    
    // address
    address = [[UIButton alloc]init];
    address.frame = CGRectMake(0, 64 + gap, view_w, ad_h);
    [address setTitle:@" 添加新地址" forState:UIControlStateNormal];
    [address setTitleColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1] forState:UIControlStateNormal];
    [address setImage:[UIImage imageNamed:@"address"] forState:UIControlStateNormal];
    address.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    address.adjustsImageWhenHighlighted = NO;
    [address setBackgroundColor:[UIColor whiteColor]];
    [address addTarget:self action:@selector(addressButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:address];

    //
    CGFloat y = CGRectGetMaxY(address.frame) + gap;
    CGRect frame = CGRectMake(0, y, view_w, view_h - y);
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"payView" owner:nil options:nil];
    payview = views.firstObject;
    payview.frame = frame;
    payview.paybutton.backgroundColor = [UIColor colorWithRed:241.0/255 green:89.0/255 blue:64.0/255 alpha:1];
    payview.paybutton.layer.cornerRadius = 5.0;
    payview.paybutton.layer.masksToBounds = YES;
    [payview.paybutton addTarget:self action:@selector(PayButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    payview.tabview.delegate = self;
    payview.tabview.dataSource = self;
    payview.allpice2.text = [NSString stringWithFormat:@"￥ %.2f",[self refreshAllPice]];;
    [self.view addSubview:payview];
    
}

- (void)PayButtonMethod:(UIButton *)button {
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    id obj1 = [def objectForKey:@"address1"];
    id obj2 = [def objectForKey:@"address2"];
    id obj3 = [def objectForKey:@"name"];
    id obj4 = [def objectForKey:@"phone"];
    if (obj1 == nil || obj2 == nil ||
        obj3 == nil || obj4 == nil) {
        NSLog(@"地址不全，不能支付");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"地址无效" message:@"请添加收货地址" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *queue = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:queue];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (self.m_array.count <= 0) {
        NSLog(@"没有商品，不能支付");
        return;
    }
    NSLog(@"支付");
    NSString *address = [NSString stringWithFormat:@"%@%@",obj1,obj2];
    NSString *nameAndPhone = [NSString stringWithFormat:@"%@%@",obj3,obj4];
    float pice = [self refreshAllPice];
    NSString *subjects = [self allShopName];
    
    NetworkManager *net = [NetworkManager instance];
    [net callAlipay:pice subject:subjects address:address note:nameAndPhone callback:^(BOOL success, NSDictionary *responseDict) {
        
        if (success) {
            NSLog(@"支付成功 = %@",responseDict);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"购买成功" message:@"订单已支付" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *queue = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self alreadyPayMoney:self.m_array];
                
                [self.navigationController.tabBarController setSelectedIndex:2];
                // 回到根控制器
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alert addAction:queue];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            NSLog(@"支付失败 = %@",responseDict);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"购买失败" message:@"订单支付失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *queue = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:queue];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)alreadyPayMoney:(NSArray *)array {
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *key = @"alreadybuy";
    id obj = [def objectForKey:key];
    // 把已经购买的商品添加到购买清单中
    NSMutableArray *m_arr = [NSMutableArray array];
    if (obj != nil) {
        m_arr = [NSMutableArray arrayWithArray:obj];
    }
    for (int i = 0; i < array.count; i ++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:array[i]];
        dic[@"time"] = [self NewTimeString];
        [m_arr insertObject:dic atIndex:0];
    }
    [def setObject:m_arr forKey:key];
    
    // 移除购物车中的商品
    NSString *car = @"shoppingCar";
    id carObj = [def objectForKey:car];
    if (carObj != nil) {
        NSMutableArray *CarArray = [NSMutableArray arrayWithArray:carObj];
        for (int i = 0; i < array.count; i ++) {
            NSDictionary *dic = array[i];
            for (int j = 0; j < CarArray.count; j ++) {
                NSDictionary *cardic = CarArray[j];
                if ([cardic[@"A"] isEqualToString:dic[@"A"]]) {
                    [CarArray removeObjectAtIndex:j];
                    break;
                }
            }
        }
        [def setObject:CarArray forKey:car];
    }
}

- (NSString *)NewTimeString {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%.4ld年%.2ld月%.2ld日 %.2ld:%.2ld",comps.year,comps.month,comps.day,comps.hour,comps.minute];
}

- (void)addressButtonMethod:(UIButton *)button {
    NSLog(@"添加新地址");
    AddressVC *vc = [[AddressVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.m_array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PayCell";
    PayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PayCell" owner:nil options:nil] firstObject];
    }

    NSDictionary *dic = self.m_array[indexPath.row];
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
    cell.imv.layer.masksToBounds = YES;
    cell.imv.layer.cornerRadius = 5.0;
    NSString *count = @"count";
    if ([[dic allKeys] containsObject:count]) {
        NSInteger k = [dic[count] integerValue];
        cell.count.text = [NSString stringWithFormat:@"x%ld",k];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 60);
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PiceView" owner:nil options:nil];
    PiceView *piceview = views.firstObject;
    piceview.backgroundColor = [UIColor whiteColor];
    piceview.frame = frame;
    piceview.pice.text = [NSString stringWithFormat:@"￥ %.2f",[self refreshAllPice]];
    return piceview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60.0;
}

- (NSString *)allShopName {
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < self.m_array.count; i ++) {
        NSDictionary *dic = self.m_array[i];
        NSString *name = [NSString stringWithFormat:@"%@ %@",dic[@"B"],dic[@"count"]];
        [str appendString:name];
        if (i != self.m_array.count - 1) {
            [str appendString:@"-"];
        }
    }
    return str;
}

- (float)refreshAllPice {
    float k = 0.0;
    NSString *isselect = @"isselect";
    NSString *count = @"count";
    
    for (int i = 0; i < self.m_array.count; i ++) {
        NSDictionary *dic = self.m_array[i];
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
    return k;
}

- (void)backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
