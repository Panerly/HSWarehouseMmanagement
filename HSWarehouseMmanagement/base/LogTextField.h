//
//  LogTextField.h
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/17.
//  Copyright © 2017年 HS. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface LogTextField : UIView

//注释信息
@property (nonatomic,copy) NSString *ly_placeholder;

//光标颜色
@property (nonatomic,strong) UIColor *cursorColor;

//注释普通状态下颜色
@property (nonatomic,strong) UIColor *placeholderNormalStateColor;

//注释选中状态下颜色
@property (nonatomic,strong) UIColor *placeholderSelectStateColor;

@property (nonatomic, strong) NSString *text;


@end
