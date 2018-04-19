//
//  BuyListCell.h
//  JinPai
//
//  Created by yangfeng on 2018/4/12.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imv;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UILabel *pice;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UILabel *count;




@end
