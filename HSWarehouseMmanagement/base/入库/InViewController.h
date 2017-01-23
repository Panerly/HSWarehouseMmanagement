//
//  InViewController.h
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/19.
//  Copyright © 2017年 HS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InViewController : UIViewController

@property (nonatomic, strong) TitleView *titleView;
@property (nonatomic, strong) NSString *titleName;


@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, strong) UILabel *txmh;    //条形码号
@property (nonatomic, strong) UITextField *txmhTextField;
@property (nonatomic, strong) UIButton *scanBtn1;

@property (nonatomic, strong) UILabel *kwbh;    //库位编号
@property (nonatomic, strong) UITextField *kwbhTextField;
@property (nonatomic, strong) UIButton *scanBtn2;

@property (nonatomic, strong) UILabel *name;    //名称
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *kwName;  //库位名称
@property (nonatomic, strong) UILabel *kwNameLabel;
@property (nonatomic, strong) UILabel *gg;      //规格
@property (nonatomic, strong) UILabel *ggLabel;
@property (nonatomic, strong) UILabel *model;   //型号
@property (nonatomic, strong) UILabel *modelLabel;
@property (nonatomic, strong) UILabel *jldw;    //计量单位
@property (nonatomic, strong) UILabel *jldwLabel;

@property (nonatomic, strong) UILabel *rksl;    //入库数量
@property (nonatomic, strong) UITextField *rkslTextField;

@property (nonatomic, strong) UILabel *kcsl;    //库存数量
@property (nonatomic, strong) UILabel *kcslLabel;
@property (nonatomic, strong) UILabel *fl;      //分类
@property (nonatomic, strong) UILabel *flLabel;
@property (nonatomic, strong) UILabel *pinp;    //品牌
@property (nonatomic, strong) UILabel *pingpLabel;
@property (nonatomic, strong) UILabel *bh;      //编号
@property (nonatomic, strong) UILabel *bhLabel;
@property (nonatomic, strong) UILabel *rkDate;  //入库日期
@property (nonatomic, strong) UILabel *rkDateLabel;


@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UIPickerView *pickerView;

@end
