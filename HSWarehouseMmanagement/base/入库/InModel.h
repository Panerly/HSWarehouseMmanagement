//
//  InModel.h
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/23.
//  Copyright © 2017年 HS. All rights reserved.
//

#import "JSONModel.h"

@interface InModel : JSONModel

@property (nonatomic, strong) NSString *txm;    //条形码
@property (nonatomic, strong) NSString *kwbh;   //库位编号
@property (nonatomic, strong) NSString *mc;     //名称
@property (nonatomic, strong) NSString *kwmc;   //库位名称
@property (nonatomic, strong) NSString *gg;     //规格
@property (nonatomic, strong) NSString *xh;     //型号
@property (nonatomic, strong) NSString *jldw;   //计量单位
@property (nonatomic, strong) NSString *kcsl;   //库存数量
@property (nonatomic, strong) NSString *fl;     //分类
@property (nonatomic, strong) NSString *pp;     //品牌

@end
