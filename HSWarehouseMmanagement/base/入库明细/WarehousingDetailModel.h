//
//  WarehousingDetailModel.h
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/19.
//  Copyright © 2017年 HS. All rights reserved.
//

#import "JSONModel.h"

@interface WarehousingDetailModel : JSONModel

@property (nonatomic, strong) NSString *name;   //名称
@property (nonatomic, strong) NSString *wlbh;   //物料编号
@property (nonatomic, strong) NSString *kwbh;   //库位编号
@property (nonatomic, strong) NSString *date;   //入库时间
@property (nonatomic, strong) NSString *bh;     //编号
@property (nonatomic, strong) NSString *num;    //入庫数量

@end
