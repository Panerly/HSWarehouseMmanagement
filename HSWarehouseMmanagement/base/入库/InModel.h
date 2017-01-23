//
//  InModel.h
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/23.
//  Copyright © 2017年 HS. All rights reserved.
//

#import "JSONModel.h"

@interface InModel : JSONModel

/* _txmhTextField.text = [dic objectForKey:@"txm"]?[dic objectForKey:@"txm"]:@"";
 _kwbhTextField.text = [dic objectForKey:@"kwbh"]?[dic objectForKey:@"kwbh"]:@"";
 _nameLabel.text = [dic objectForKey:@"mc"]?[dic objectForKey:@"mc"]:@"";
 _kwNameLabel.text = [dic objectForKey:@"kwmc"]?[dic objectForKey:@"kwmc"]:@"";
 _ggLabel.text = [dic objectForKey:@"gg"]?[dic objectForKey:@"gg"]:@"";
 _modelLabel.text = [dic objectForKey:@"xh"]?[dic objectForKey:@"xh"]:@"";
 _jldwLabel.text = [dic objectForKey:@"jldw"]?[dic objectForKey:@"jldw"]:@"";
 _kcslLabel.text = [dic objectForKey:@"kcsl"]?[dic objectForKey:@"kcsl"]:@"";
 _flLabel.text = [dic objectForKey:@"fl"]?[dic objectForKey:@"fl"]:@"";
 _pingpLabel.text */

@property (nonatomic, strong) NSString *txm;
@property (nonatomic, strong) NSString *kwbh;
@property (nonatomic, strong) NSString *mc;
@property (nonatomic, strong) NSString *kwmc;
@property (nonatomic, strong) NSString *gg;
@property (nonatomic, strong) NSString *xh;
@property (nonatomic, strong) NSString *jldw;
@property (nonatomic, strong) NSString *kcsl;
@property (nonatomic, strong) NSString *fl;
@property (nonatomic, strong) NSString *pp;

@end
