//
//  ShoppingCarCell.m
//  JinPai
//
//  Created by yangfeng on 2018/4/11.
//  Copyright © 2018年 sfy. All rights reserved.
//

#import "ShoppingCarCell.h"

@implementation ShoppingCarCell

- (IBAction)selectButtonMethod:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(DidSelectChooseButton:)]) {
        [self.delegate DidSelectChooseButton:sender];
    }
}

- (IBAction)addButtonMethod:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(DidSelectAddButton:)]) {
        [self.delegate DidSelectAddButton:sender];
    }
}

- (IBAction)deleButtonmethod:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(DidSelectReduceButton:)]) {
        [self.delegate DidSelectReduceButton:sender];
    }
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
