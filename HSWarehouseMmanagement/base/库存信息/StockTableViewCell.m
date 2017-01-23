
//
//  StockTableViewCell.m
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/18.
//  Copyright © 2017年 HS. All rights reserved.
//

#import "StockTableViewCell.h"

@implementation StockTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.name.text = self.stockModel.name;
    self.stockNum.text = self.stockModel.kcsl;
    self.num.text = self.stockModel.txm;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
