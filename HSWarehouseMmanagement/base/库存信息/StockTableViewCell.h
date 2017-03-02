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

@property (weak, nonatomic) IBOutlet UILabel *name;     //名称
@property (weak, nonatomic) IBOutlet UILabel *stockNum; //库存数量
@property (weak, nonatomic) IBOutlet UILabel *num;      //条形码号

@property (nonatomic, strong) StockModel *stockModel;

@end
