//
//  ShoppingCarCell.h
//  JinPai
//
//  Created by yangfeng on 2018/4/11.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShoppingCarCellDelegate <NSObject>

- (void)DidSelectChooseButton:(UIButton *)button;

- (void)DidSelectAddButton:(UIButton *)button;

- (void)DidSelectReduceButton:(UIButton *)button;

@end

@interface ShoppingCarCell : UITableViewCell

@property (nonatomic, weak) id <ShoppingCarCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *imv;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *message;

@property (weak, nonatomic) IBOutlet UILabel *pice;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *number;



@end
