//
//  AddressVC.m
//  JinPai
//
//  Created by yangfeng on 2018/4/11.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import "AddressVC.h"
#import "GFAddressPicker.h"

@interface AddressVC () <UITextFieldDelegate, GFAddressPickerDelegate> {
    UITextField *tf1;
    UITextField *tf2;
    UITextField *tf3;
    UITextField *tf4;
    NSUserDefaults *def;
}

@property (nonatomic, strong) GFAddressPicker *pickerView;

@end

@implementation AddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    def = [NSUserDefaults standardUserDefaults];
    self.title = @"收货地址";
    // 创建一个UIButton
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    // 创建一个UIButton
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 40, 40)];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveItemClick) forControlEvents:UIControlEventTouchUpInside];
    saveButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    [self createUI];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)createUI {
    
    CGFloat view_w = self.view.frame.size.width;
    CGFloat view_h = self.view.frame.size.height;
    CGFloat tf_h = 60;
    CGFloat le = 10;
    
    CGRect frame1 = CGRectMake(le, 64, view_w - le * 2, tf_h);
    CGRect frame2 = CGRectMake(le, 64 + tf_h * 1, view_w - le * 2, tf_h);
    CGRect frame3 = CGRectMake(le, 64 + tf_h * 2, view_w - le * 2, tf_h);
    CGRect frame4 = CGRectMake(le, 64 + tf_h * 3, view_w - le * 2, tf_h);
    
    tf1 = [[UITextField alloc]init];
    tf2 = [[UITextField alloc]init];
    tf3 = [[UITextField alloc]init];
    tf4 = [[UITextField alloc]init];
    
    [self createTextField:tf1 frame:frame1 text:@"省份、城市、区县" tag:1 right:YES];
    [self createTextField:tf2 frame:frame2 text:@"详细地址、如街道、楼牌号等" tag:2 right:NO];
    [self createTextField:tf3 frame:frame3 text:@"姓名" tag:3 right:NO];
    [self createTextField:tf4 frame:frame4 text:@"手机号码" tag:4 right:NO];
    
    CGRect frame5 = CGRectMake(le, 64 + tf_h * 1, view_w - le * 2, 1.0);
    CGRect frame6 = CGRectMake(le, 64 + tf_h * 2, view_w - le * 2, 1.0);
    CGRect frame7 = CGRectMake(le, 64 + tf_h * 3, view_w - le * 2, 1.0);
    CGFloat yy = 64 + tf_h * 4;
    CGRect frame8 = CGRectMake(0, yy, view_w, view_h - yy);
    [self line:frame5];
    [self line:frame6];
    [self line:frame7];
    [self line:frame8];
    
    id obj1 = [def objectForKey:@"address1"];
    id obj2 = [def objectForKey:@"address2"];
    id obj3 = [def objectForKey:@"name"];
    id obj4 = [def objectForKey:@"phone"];
    
    
    if (obj1 != nil) {
        tf1.text = [NSString stringWithFormat:@"%@",obj1];
    }
    if (obj2 != nil) {
        tf2.text = [NSString stringWithFormat:@"%@",obj2];
    }
    if (obj3 != nil) {
        tf3.text = [NSString stringWithFormat:@"%@",obj3];
    }
    if (obj4 != nil) {
        tf4.text = [NSString stringWithFormat:@"%@",obj4];
    }
}

- (void)line:(CGRect)frame {
    UIView *vi_2 = [[UIView alloc]initWithFrame:frame];
    vi_2.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    [self.view addSubview:vi_2];
}

- (void)createTextField:(UITextField *)tf frame:(CGRect)frame text:(NSString *)text tag:(NSInteger)tag right:(BOOL)right {
    tf.frame = frame;
    tf.placeholder = text;
    tf.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    tf.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
    tf.tag = tag;
    tf.delegate = self;
    if (right) {
        CGFloat h = frame.size.height * 0.3;
        UIImageView *imv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftImage"]];
        imv.contentMode = UIViewContentModeScaleAspectFit;
        imv.frame = CGRectMake(0, (frame.size.height - h) / 2.0, h, h);
        
        tf.rightViewMode = UITextFieldViewModeAlways;
        tf.rightView = imv;
    }
    [self.view addSubview:tf];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        
        id obj1 = [def objectForKey:@"address1"];
        self.pickerView = [[GFAddressPicker alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        if (obj1 != nil) {
            NSArray *arr = [[NSString stringWithFormat:@"%@",obj1] componentsSeparatedByString:@" "];
            [self.pickerView updateAddressAtProvince:arr[0] city:arr[1] town:arr[2]];
        }
        else {
            [self.pickerView updateAddressAtProvince:@"广东省" city:@"广州市" town:@"天河区"];
        }
        self.pickerView.delegate = self;
        self.pickerView.font = [UIFont boldSystemFontOfSize:18];
        [self.view addSubview:self.pickerView];
    }
}

- (void)GFAddressPickerCancleAction {
    [self.pickerView removeFromSuperview];
}

- (void)GFAddressPickerWithProvince:(NSString *)province
                               city:(NSString *)city area:(NSString *)area {
    [self.pickerView removeFromSuperview];
    tf1.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,area];
    NSLog(@"%@  %@  %@",province,city,area);
}

- (void)backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveItemClick {
    NSLog(@"save");
    if (tf1.text.length > 0 &&
        tf2.text.length > 0 &&
        tf3.text.length > 0 &&
        tf4.text.length > 0) {
        [def setObject:tf1.text forKey:@"address1"];
        [def setObject:tf2.text forKey:@"address2"];
        [def setObject:tf3.text forKey:@"name"];
        [def setObject:tf4.text forKey:@"phone"];
        [self backItemClick];
    }
}






- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
