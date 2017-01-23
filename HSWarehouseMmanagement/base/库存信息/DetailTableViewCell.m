//
//  DetailTableViewCell.m
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/18.
//  Copyright © 2017年 HS. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.kwNum.text = self.detailModel.kwbh;
    self.num.text = self.detailModel.num;
    self.kwName.text = self.detailModel.kwmc;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
