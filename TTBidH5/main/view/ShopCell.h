//
//  ShopCell.h
//  JinPai
//
//  Created by yangfeng on 2018/4/10.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imv;

@property (strong, nonatomic) IBOutlet UILabel *name;

@property (strong, nonatomic) IBOutlet UILabel *pice;

@property (strong, nonatomic) IBOutlet UILabel *type;

@end
