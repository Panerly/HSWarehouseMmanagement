//
//  StockTableViewCell.h
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/18.
//  Copyright © 2017年 HS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockModel.h"

@interface StockTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *stockNum;
@property (weak, nonatomic) IBOutlet UILabel *num;

@property (nonatomic, strong) StockModel *stockModel;

@end
