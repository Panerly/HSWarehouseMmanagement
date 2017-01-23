//
//  DetailViewController.h
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/18.
//  Copyright © 2017年 HS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"

@interface DetailViewController : UIViewController

@property (nonatomic, strong) TitleView *titleView;
@property (nonatomic, strong) NSString *titletext;

@property (nonatomic, strong) DetailModel *detailModel;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSString *txmh;

@end
