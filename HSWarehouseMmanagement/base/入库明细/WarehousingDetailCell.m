//
//  WarehousingDetailCell.m
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/19.
//  Copyright © 2017年 HS. All rights reserved.
//

#import "WarehousingDetailCell.h"
#import "WarehousingDetailVC.h"

@implementation WarehousingDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)tableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";//对应xib中设置的identifier
    NSInteger index = 0; //xib中第几个Cell
    switch (indexPath.row) {
        case 0:
            identifier = @"WarehousingDetailCellFirst";
            index = 0;
            break;
        case 1:
            identifier = @"WarehousingDetailCellSecond";
            index = 1;
            break;
            
        default:
            break;
    }
    WarehousingDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WarehousingDetailCell" owner:self options:nil] objectAtIndex:index];
    }
    return cell;
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    if (self.name.text) {
        
        self.name.text              = self.warehousingDetailModel.name;
    }
    if (self.seriaNameNum.text) {
        
        self.seriaNameNum.text      = self.warehousingDetailModel.bh;
    }
    if (self.stockingNum.text) {
        
        self.stockingNum.text       = self.warehousingDetailModel.num;
    }
    if (self.materieNum.text) {
        
        self.materieNum.text        = self.warehousingDetailModel.wlbh;
    }
    if (self.storageLocation.text) {
        
        self.storageLocation.text   = self.warehousingDetailModel.kwbh;
    }
    if (self.stockDate.text) {
        
        self.stockDate.text         = self.warehousingDetailModel.date;
    }
    
    if ([((WarehousingDetailVC*)[self findVC]).titleName isEqualToString:@"入库明细"]) {
        self.date.text  = @"入库时间：";
        self.rkNum.text = @"入库数量：";
    }else{
        self.date.text  = @"出库时间：";
        self.rkNum.text = @"出库数量：";
    }
    
}

- (UIViewController *)findVC
{
    UIResponder *next = self.nextResponder;
    
    while (1) {
        
        if ([next isKindOfClass:[UIViewController class]]) {
            return  (UIViewController *)next;
        }
        next =  next.nextResponder;
    }
    return nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
