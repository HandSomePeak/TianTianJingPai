//
//  CallUsVC.m
//  JinPai
//
//  Created by yangfeng on 2018/4/11.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import "CallUsVC.h"
#import "CallUsCell.h"

@interface CallUsVC () <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *m_array;
    
}

@end

@implementation CallUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系我们";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initdata];
    // 创建一个UIButton
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    CGFloat view_w = self.view.frame.size.width;
    CGFloat view_h = self.view.frame.size.height;
    CGFloat hh = 0;
    UITableView *tab = [[UITableView alloc]init];
    tab = [[UITableView alloc]init];
    tab.frame = CGRectMake(0, 0, view_w, view_h - hh);
    tab.delegate = self;
    tab.dataSource = self;
    tab.backgroundColor = [UIColor whiteColor];
    tab.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tab];
}

- (void)initdata {
    m_array = [NSMutableArray array];
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    dic1[@"1"] = @"微信客服：童童";
    dic1[@"2"] = @"020-28888888";
    dic1[@"3"] = @"call";
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    dic2[@"1"] = @"微信客服：娜娜";
    dic2[@"2"] = @"020-28883838";
    dic2[@"3"] = @"call";
    
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    dic3[@"1"] = @"微信客服：丹丹";
    dic3[@"2"] = @"020-28880808";
    dic3[@"3"] = @"call";
    
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
    dic4[@"1"] = @"微信客服：校长";
    dic4[@"2"] = @"020-28886868";
    dic4[@"3"] = @"call";
    
    [m_array addObject:dic1];
    [m_array addObject:dic2];
    [m_array addObject:dic3];
    [m_array addObject:dic4];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return m_array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"tabcell";
    CallUsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CallUsCell" owner:nil options:nil] firstObject];
    }
    tableView.rowHeight = 90;
    NSDictionary *dic = m_array[indexPath.row];
    
    cell.imv.image = [UIImage imageNamed:dic[@"3"]];
    cell.imv.contentMode = UIViewContentModeScaleAspectFill;
    cell.name.text = dic[@"1"];
    cell.phone.text = dic[@"2"];
    cell.imv.layer.masksToBounds = YES;
    cell.imv.layer.cornerRadius = cell.imv.frame.size.height / 2.0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
