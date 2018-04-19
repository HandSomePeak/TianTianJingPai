//
//  PayCell.h
//  JinPai
//
//  Created by yangfeng on 2018/4/13.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imv;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *message;

@property (weak, nonatomic) IBOutlet UILabel *pice;
@property (weak, nonatomic) IBOutlet UILabel *count;



@end
