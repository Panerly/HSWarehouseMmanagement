//
//  ChangePositionVC.h
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/2/10.
//  Copyright © 2017年 HS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePositionVC : UIViewController

@property (nonatomic, strong) TitleView *titleView;
@property (nonatomic, strong) NSString *titleName;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

- (IBAction)cancelBtn:(id)sender;
- (IBAction)confirmBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *QRCodeNumberTextField;//条形码号

- (IBAction)scanQRCode:(id)sender;
- (IBAction)scanNewPositionBtn:(id)sender;
- (IBAction)selectBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *stockNumberTextField;//库存数量
@property (weak, nonatomic) IBOutlet UILabel *positonNumberLabel;//库位编号

@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UITextField *latestPositon;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end
