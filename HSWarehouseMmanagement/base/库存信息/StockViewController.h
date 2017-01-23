//
//  StockViewController.h
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/18.
//  Copyright © 2017年 HS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockModel.h"

@interface StockViewController : UIViewController

@property (nonatomic, strong) TitleView *titleView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) StockModel *stockModel;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end
