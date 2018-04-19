//
//  SettingVC.m
//  JinPai
//
//  Created by yangfeng on 2018/4/11.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import "SettingVC.h"

@interface SettingVC () <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *m_array;
    
}

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
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
    CGFloat hh = 60;
//    CGFloat left = 30;
    
    UITableView *tab = [[UITableView alloc]init];
    tab = [[UITableView alloc]init];
    tab.frame = CGRectMake(0, 0, view_w, view_h - hh);
    tab.delegate = self;
    tab.dataSource = self;
    tab.backgroundColor = [UIColor whiteColor];
    tab.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tab];
    
//    UIButton *bu = [[UIButton alloc]init];
//    bu.frame = CGRectMake(left, view_h - hh, view_w - left * 2, 44);
//    [bu setTitle:@"退出登录" forState:UIControlStateNormal];
//    [bu setBackgroundColor:[UIColor colorWithRed:117.0/255 green:117.0/255 blue:117.0/255 alpha:1]];
//    bu.layer.masksToBounds = YES;
//    bu.layer.cornerRadius = 5.0;
//    [self.view addSubview:bu];
}

- (void)initdata {
    m_array = [NSMutableArray array];
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    dic1[@"1"] = @"检查更新（V1.0.5）";
    dic1[@"2"] = @"";
    
//    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
//    dic2[@"1"] = @"清除缓存";
//    dic2[@"2"] = @"3.05Mb";

    [m_array addObject:dic1];
//    [m_array addObject:dic2];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return m_array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"tabcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    tableView.rowHeight = 60;
    NSDictionary *dic = m_array[indexPath.row];
    cell.textLabel.text = dic[@"1"];
    cell.textLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    cell.textLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = dic[@"2"];;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"检查更新" message:@"该版本已经是最新版本" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *queue = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:queue];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
