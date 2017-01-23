//
//  WarehousingDetailVC.h
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/19.
//  Copyright © 2017年 HS. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WarehousingDetailModel.h"
@class WarehousingDetailModel;
@interface WarehousingDetailVC : UIViewController

@property (nonatomic, strong) TitleView *titleView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WarehousingDetailModel *warehousingDetailModel;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSString *titleName;

@end
