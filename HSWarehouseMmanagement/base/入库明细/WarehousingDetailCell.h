//
//  WarehousingDetailCell.h
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/19.
//  Copyright © 2017年 HS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WarehousingDetailModel.h"
//@class WarehousingDetailModel;

@interface WarehousingDetailCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *name;             //名称
@property (weak, nonatomic) IBOutlet UILabel *seriaNameNum;     //编号
@property (weak, nonatomic) IBOutlet UILabel *stockingNum;      //入庫数量
@property (weak, nonatomic) IBOutlet UILabel *materieNum;       //物料编号
@property (weak, nonatomic) IBOutlet UILabel *storageLocation;  //库位编号
@property (weak, nonatomic) IBOutlet UILabel *stockDate;        //入库时间

@property (nonatomic, strong) WarehousingDetailModel *warehousingDetailModel;
+ (instancetype)tableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath;


//出入库时间 & 出入库数量
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *rkNum;
@property (nonatomic, assign) NSString *flag;

@end
