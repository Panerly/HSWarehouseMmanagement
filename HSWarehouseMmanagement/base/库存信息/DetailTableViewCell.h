//
//  DetailTableViewCell.h
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/18.
//  Copyright © 2017年 HS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"

@interface DetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *kwNum;    //库位编号
@property (weak, nonatomic) IBOutlet UILabel *num;      //数量
@property (weak, nonatomic) IBOutlet UILabel *kwName;   //库位名称

@property (nonatomic, strong) DetailModel *detailModel;

@end
