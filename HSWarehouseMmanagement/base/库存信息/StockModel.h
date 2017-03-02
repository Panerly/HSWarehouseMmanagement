//
//  StockModel.h
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/18.
//  Copyright © 2017年 HS. All rights reserved.
//

#import "JSONModel.h"

@interface StockModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *txm;  // 条形码
@property (nonatomic, strong) NSString<Optional> *name; // 名称
@property (nonatomic, strong) NSString<Optional> *wlbh; // 物料编号
@property (nonatomic, strong) NSString<Optional> *kcsl; // 库存总数量
@property (nonatomic, strong) NSString<Optional> *kcxx; // 库存下限
@property (nonatomic, strong) NSString<Optional> *zckc; // 正常库存
@property (nonatomic, strong) NSString<Optional> *fl;   // 分类
@property (nonatomic, strong) NSString<Optional> *pinp; // 品牌
@property (nonatomic, strong) NSString<Optional> *jldw; // 计量单位

@end
