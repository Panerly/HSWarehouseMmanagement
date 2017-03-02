//
//  InViewController.m
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/19.
//  Copyright © 2017年 HS. All rights reserved.
//

#import "InViewController.h"
#import "SJViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "InModel.h"

@interface InViewController ()
<
UIScrollViewDelegate,
UITextFieldDelegate,
UIPickerViewDelegate,
UIPickerViewDataSource
>
{
    UIButton *backBtn;
    UILabel *_refreshLabel;
}


@end

@implementation InViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self _configScrollView];
    [self initTitleView];
    _dataArr = [NSMutableArray array];
}

- (void)initTitleView {
    
    _titleView          = [[TitleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _titleView.title    = self.titleName;
    _titleView.isTranslucent        = NO;
    _titleView.backgroundColor      = COLORRGB(63, 143, 249);
    _titleView.isTranslucent        = YES;
    _titleView.isLeftBtnRotation    = YES;
    backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backBtn.showsTouchWhenHighlighted = YES;
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    _titleView.leftBarButton = backBtn;
    
    [self.view addSubview:_titleView];
}

- (void)backAction{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//配置滑动试图
- (void)_configScrollView
{
    _scrollView                 = [[UIScrollView alloc] init];
    _scrollView.contentSize     = CGSizeMake(kScreenWidth, 1.2*kScreenHeight);
    _scrollView.scrollEnabled   = YES;
    _scrollView.pagingEnabled   = NO;
    _scrollView.delegate        = self;
    _scrollView.showsVerticalScrollIndicator    = YES;
    _scrollView.showsHorizontalScrollIndicator  = NO;
    _scrollView.backgroundColor                 = [UIColor whiteColor];
    //滑动时使键盘收回
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_scrollView];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(CGSizeMake(kScreenWidth, kScreenHeight));
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self setUI];
    
    //保存按钮
    _saveBtn = [[UIButton alloc] init];
    [_saveBtn setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [_saveBtn addTarget:self action:@selector(updateDataSouce) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveBtn];
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-59);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.size.equalTo(CGSizeMake(55, 55));
    }];
}

- (void)updateDataSouce {
    
    NSString *logInUrl;
    if ([self.titleName isEqualToString:@"出库"]) {
        logInUrl = [NSString stringWithFormat:@"%@",ckApi];
    }else {
        logInUrl = [NSString stringWithFormat:@"%@",rkApi];
    }
    
    NSURLSessionConfiguration *config   = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager       = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    manager.requestSerializer.timeoutInterval = 10;
    
    AFHTTPResponseSerializer *serializer    = manager.responseSerializer;
    
    serializer.acceptableContentTypes       = [serializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    __weak typeof(self) weakSelf            = self;
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    if ([_rkslTextField.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"出入库数量不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    if ([_txmhTextField.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"条形码号不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    if ([_kwbhTextField.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"库位编号不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    if ([_bhLabel.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"编号不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    if ([_rkDateLabel.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"入库日期不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    if ([_kcsl.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"库存数量不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    NSString *crkDate;
    NSString *crksl;
    if ([self.titleName isEqualToString:@"入库"]) {
        crkDate = @"rkrq";
        crksl   = @"rksl";
    }else{
        crkDate = @"ckrq";
        crksl   = @"cksl";
    }
    
    NSDictionary *parameters = @{
                                 crksl:_rkslTextField.text,
                                 @"wlbh":_txmhTextField.text,
                                 @"kwbh":_kwbhTextField.text,
                                 @"bh":_bhLabel.text,
                                 crkDate:_rkDateLabel.text,
                                 @"kcsl":_kcslLabel.text,
                                 @"Phone":@"iOS"
                                 };
    
    NSURLSessionTask *task =[manager POST:logInUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            if ([[responseObject objectAtIndex:0] isEqualToString:@"1"]) {
                [SCToastView showInView:self.view text:@"入库成功" duration:.5 autoHide:YES];
                
                weakSelf.rkslTextField.text = @"";
            }else if ([[responseObject objectAtIndex:0] isEqualToString:@"0"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[weakSelf.titleName isEqualToString:@"入库"]?@"入库失败":@"出库失败" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancel];
                [weakSelf presentViewController:alert animated:YES completion:nil];
                
            }else if ([[responseObject objectAtIndex:0] isEqualToString:@"9"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"库位不存在" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancel];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }];
    [task resume];
    
}

- (void)setUI {
    
    //条形码号
    _txmh       = [[UILabel alloc] init];
    _txmh.text  = @"条形码号：";
    [_scrollView addSubview:_txmh];
    [_txmh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_top).with.offset(75);
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
        
    }];
    _txmhTextField              = [[UITextField alloc] init];
    _txmhTextField.placeholder  = @"扫码或输入";
    _txmhTextField.borderStyle  = UITextBorderStyleRoundedRect;
    _txmhTextField.font         = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:_txmhTextField];
    [_txmhTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_txmh.mas_right).with.offset(5);
        make.centerY.equalTo(_txmh.mas_centerY);
        make.size.equalTo(CGSizeMake(150, 25));
    }];
    [_txmhTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _scanBtn1 = [[UIButton alloc] init];
    _scanBtn1.tag = 200;
    [_scanBtn1 addTarget:self action:@selector(begainScan) forControlEvents:UIControlEventTouchUpInside];
    [_scanBtn1 setTitle:@"扫描" forState:UIControlStateNormal];
    _scanBtn1.clipsToBounds = YES;
    _scanBtn1.layer.cornerRadius = 5;
    [_scanBtn1 setBackgroundColor:[UIColor darkTextColor]];
    [_scrollView addSubview:_scanBtn1];
    [_scanBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_txmhTextField.mas_right).with.offset(10);
        make.centerY.equalTo(_txmhTextField.mas_centerY);
        make.size.equalTo(CGSizeMake(55, 25));
    }];

    //库位编号
    _kwbh       = [[UILabel alloc] init];
    _kwbh.text  = @"库位编号：";
    [_scrollView addSubview:_kwbh];
    [_kwbh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_txmh.mas_bottom).with.offset(10);
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
    }];
    _kwbhTextField = [[UITextField alloc] init];
    _kwbhTextField.placeholder = @"扫码或输入";
    _kwbhTextField.borderStyle = UITextBorderStyleRoundedRect;
    _kwbhTextField.font        = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:_kwbhTextField];
    [_kwbhTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_kwbh.mas_right).with.offset(5);
        make.centerY.equalTo(_kwbh.mas_centerY);
        make.size.equalTo(CGSizeMake(150, 25));
    }];
    _kwbhTextField.delegate = self;
    _kwbhTextField.returnKeyType = UIReturnKeyGo;
    UIButton *btn = [[UIButton alloc] init];
    [_scrollView addSubview:btn];
    [btn addTarget:self action:@selector(pickData) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_kwbh.mas_right).with.offset(5);
        make.centerY.equalTo(_kwbh.mas_centerY);
        make.size.equalTo(CGSizeMake(70, 25));
    }];
    
    
    _scanBtn2 = [[UIButton alloc] init];
    _scanBtn2.tag = 201;
    [_scanBtn2 addTarget:self action:@selector(begainScan) forControlEvents:UIControlEventTouchUpInside];
    [_scanBtn2 setTitle:@"扫描" forState:UIControlStateNormal];
    _scanBtn2.clipsToBounds = YES;
    _scanBtn2.layer.cornerRadius = 5;
    [_scanBtn2 setBackgroundColor:[UIColor darkTextColor]];
    [_scrollView addSubview:_scanBtn2];
    [_scanBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_kwbhTextField.mas_right).with.offset(10);
        make.centerY.equalTo(_kwbhTextField.mas_centerY);
        make.size.equalTo(CGSizeMake(55, 25));
    }];
    
    //名称
    _name = [[UILabel alloc] init];
    _name.text = @"名        称：";
    [_scrollView addSubview:_name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_kwbh.mas_bottom).with.offset(10);
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
    }];
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"";
    [_scrollView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_name.mas_right).with.offset(5);
        make.centerY.equalTo(_name.mas_centerY);
        make.right.equalTo(self.view.mas_right);
    }];

    //库位名称
    _kwName = [[UILabel alloc] init];
    _kwName.text = @"库位名称：";
    [_scrollView addSubview:_kwName];
    [_kwName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_name.mas_bottom).with.offset(10);
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
    }];
    _kwNameLabel = [[UILabel alloc] init];
    _kwNameLabel.text = @"";
    [_scrollView addSubview:_kwNameLabel];
    [_kwNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_kwName.mas_right).with.offset(5);
        make.centerY.equalTo(_kwName.mas_centerY);
        make.right.equalTo(self.view.mas_right);
    }];
    
    //规格
    _gg = [[UILabel alloc] init];
    _gg.text = @"规        格：";
    [_scrollView addSubview:_gg];
    [_gg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_kwName.mas_bottom).with.offset(10);
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
    }];
    _ggLabel = [[UILabel alloc] init];
    _ggLabel.text = @"";
    [_scrollView addSubview:_ggLabel];
    [_ggLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_gg.mas_right).with.offset(5);
        make.centerY.equalTo(_gg.mas_centerY);
        make.right.equalTo(self.view.mas_right);
    }];
    
    //型号
    _model = [[UILabel alloc] init];
    _model.text = @"型        号：";
    [_scrollView addSubview:_model];
    [_model mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_gg.mas_bottom).with.offset(10);
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
    }];
    _modelLabel = [[UILabel alloc] init];
    _modelLabel.text = @"";
    [_scrollView addSubview:_modelLabel];
    [_modelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_model.mas_right).with.offset(5);
        make.centerY.equalTo(_model.mas_centerY);
        make.right.equalTo(self.view.mas_right);
    }];
    
    //计量单位
    _jldw = [[UILabel alloc] init];
    _jldw.text = @"计量单位：";
    [_scrollView addSubview:_jldw];
    [_jldw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_model.mas_bottom).with.offset(10);
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
    }];
    _jldwLabel = [[UILabel alloc] init];
    _jldwLabel.text = @"";
    [_scrollView addSubview:_jldwLabel];
    [_jldwLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_jldw.mas_right).with.offset(5);
        make.centerY.equalTo(_jldw.mas_centerY);
        make.right.equalTo(self.view.mas_right);
    }];
    
    //入库数量
    _rksl = [[UILabel alloc] init];
    if ([self.titleName isEqualToString:@"入库"]) {
        
        _rksl.text = @"入库数量：";
    }else {
        
        _rksl.text = @"出库数量：";
    }
    [_scrollView addSubview:_rksl];
    [_rksl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_jldw.mas_bottom).with.offset(10);
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
    }];
    _rkslTextField = [[UITextField alloc] init];
    _rkslTextField.borderStyle = UITextBorderStyleRoundedRect;
    _rkslTextField.font        = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:_rkslTextField];
    [_rkslTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rksl.mas_right).with.offset(5);
        make.centerY.equalTo(_rksl.mas_centerY);
        make.size.equalTo(CGSizeMake(150, 25));
    }];

    //库存数量
    _kcsl = [[UILabel alloc] init];
    _kcsl.text = @"库存数量：";
    [_scrollView addSubview:_kcsl];
    [_kcsl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rksl.mas_bottom).with.offset(10);
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
    }];
    _kcslLabel = [[UILabel alloc] init];
    _kcslLabel.text = @"";
    [_scrollView addSubview:_kcslLabel];
    [_kcslLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_kcsl.mas_right).with.offset(5);
        make.centerY.equalTo(_kcsl.mas_centerY);
        make.right.equalTo(self.view.mas_right);
    }];
    
    //分类
    _fl         = [[UILabel alloc] init];
    _fl.text    = @"分        类：";
    [_scrollView addSubview:_fl];
    [_fl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_kcsl.mas_bottom).with.offset(10);
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
    }];
    _flLabel        = [[UILabel alloc] init];
    _flLabel.text   = @"";
    [_scrollView addSubview:_flLabel];
    [_flLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_fl.mas_right).with.offset(5);
        make.centerY.equalTo(_fl.mas_centerY);
        make.right.equalTo(self.view.mas_right);
    }];
    
    //品牌
    _pinp       = [[UILabel alloc] init];
    _pinp.text  = @"品        牌：";
    [_scrollView addSubview:_pinp];
    [_pinp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fl.mas_bottom).with.offset(10);
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
    }];
    _pingpLabel         = [[UILabel alloc] init];
    _pingpLabel.text    = @"";
    [_scrollView addSubview:_pingpLabel];
    [_pingpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_pinp.mas_right).with.offset(5);
        make.centerY.equalTo(_pinp.centerY);
        make.right.equalTo(self.view.mas_right);
    }];
    
    //编号
    _bh = [[UILabel alloc] init];
    _bh.text = @"编        号：";
    [_scrollView addSubview:_bh];
    [_bh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pinp.mas_bottom).with.offset(10);
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
    }];
    _bhLabel = [[UILabel alloc] init];
    _bhLabel.text = @"";
    [_scrollView addSubview:_bhLabel];
    [_bhLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bh.mas_right).with.offset(5);
        make.centerY.equalTo(_bh.mas_centerY);
        make.right.equalTo(self.view.mas_right);
    }];
    //获取系统当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd hhmmss"];
    NSString *currentTime      = [formatter stringFromDate:[NSDate date]];
    _bhLabel.text = currentTime;
    
    //入库日期
    _rkDate = [[UILabel alloc] init];
    _rkDate.text = @"入库日期：";
    [_scrollView addSubview:_rkDate];
    [_rkDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bh.mas_bottom).with.offset(10);
        make.left.equalTo(_scrollView.mas_left).with.offset(5);
    }];
    _rkDateLabel = [[UILabel alloc] init];
    _rkDateLabel.text = @"";
    [_scrollView addSubview:_rkDateLabel];
    [_rkDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rkDate.mas_right).with.offset(5);
        make.centerY.equalTo(_rkDate.mas_centerY);
        make.right.equalTo(self.view.mas_right);
    }];
    //获取系统当前时间
    [formatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    NSString *currentTimeStr      = [formatter stringFromDate:[NSDate date]];
    _rkDateLabel.text = currentTimeStr;
}

- (void)begainScan {
    SJViewController *viewController = [[SJViewController alloc] init];
    
    //判断是否已授权
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == ALAuthorizationStatusDenied||authStatus == ALAuthorizationStatusRestricted) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请前往设置->隐私->相机授权应用拍照权限" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            return ;
        }
    }
    
    /** 扫描成功返回来的数据 */
    viewController.successBlock = ^(NSString *successString) {
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"successBlock = %@",successString);
        
        if (successString == nil) {
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"库中不存在此户信息！\n请更新或检查条码信息！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:action];
            [self presentViewController:alertVC animated:YES completion:^{
                
            }];
        }else{
            
            [self requestOutData:successString];
        }
    };
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)addshimmeringView :(UIView *)view{
    FBShimmeringView *shimmeringView           = [[FBShimmeringView alloc] initWithFrame:view.bounds];
    shimmeringView.shimmering                  = YES;
    shimmeringView.shimmeringBeginFadeDuration = 0.4;
    shimmeringView.shimmeringOpacity           = 0.4f;
    shimmeringView.shimmeringAnimationOpacity  = 1.f;
    [self.view addSubview:shimmeringView];
    shimmeringView.center                      = self.view.center;
    shimmeringView.contentView                 = view;
    shimmeringView.multipleTouchEnabled        = NO;
}

- (void)requestOutData :(NSString *)txmh{
    if (!_refreshLabel) {
        
        _refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _refreshLabel.text = @"正在加载中...";
        [self.view addSubview:_refreshLabel];
        [self addshimmeringView:_refreshLabel];
    }
    [_txmhTextField resignFirstResponder];
    
    NSString *logInUrl                  = [NSString stringWithFormat:@"%@",tmcxApi];
    
    NSURLSessionConfiguration *config   = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager       = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    manager.requestSerializer.timeoutInterval = 10;
    
    AFHTTPResponseSerializer *serializer    = manager.responseSerializer;
    
    serializer.acceptableContentTypes       = [serializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    __weak typeof(self) weakSelf            = self;
    
    NSDictionary *para = @{
                           @"txm":txmh
                           };
    
    NSURLSessionTask *task =[manager POST:logInUrl parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [_refreshLabel removeFromSuperview];
        _refreshLabel = nil;
        if (responseObject) {
            
            NSError *error;
            
            for (NSDictionary *dic in responseObject) {
                
                if ([[dic objectForKey:@"kcsl"] intValue] != 0) {
                    
                    InModel *inModel = [[InModel alloc] initWithDictionary:dic error:&error];
                    [weakSelf.dataArr addObject:inModel];
                }
                
            }
            if (weakSelf.dataArr.count>0) {
                
                _txmhTextField.text = ((InModel *)weakSelf.dataArr[0]).txm;
                _kwbhTextField.text = ((InModel *)weakSelf.dataArr[0]).kwbh;
                _nameLabel.text = ((InModel *)weakSelf.dataArr[0]).mc;
                _kwNameLabel.text = ((InModel *)weakSelf.dataArr[0]).kwmc;
                _ggLabel.text = ((InModel *)weakSelf.dataArr[0]).gg;
                _modelLabel.text = ((InModel *)weakSelf.dataArr[0]).xh;
                _jldwLabel.text = ((InModel *)weakSelf.dataArr[0]).jldw;
                _kcslLabel.text = ((InModel *)weakSelf.dataArr[0]).kcsl;
                _flLabel.text = ((InModel *)weakSelf.dataArr[0]).fl;
                _pingpLabel.text = ((InModel *)weakSelf.dataArr[0]).pp;
            }else{
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"此条码号暂无库存信息，请检查后重试" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertVC addAction:cancel];
                [weakSelf presentViewController:alertVC animated:YES completion:^{
                    
                }];
                
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_refreshLabel removeFromSuperview];
        _refreshLabel = nil;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }];
    [task resume];
    
}

- (void)pickData {
    
    if (!_pickerView) {
        
        _pickerView                 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 150)];
        
        _pickerView.backgroundColor = [UIColor lightGrayColor];
        _pickerView.delegate        = self;
        _pickerView.dataSource      = self;
        
        for (int i = 0; i < _dataArr.count; i++) {
            
            if ([((InModel *)_dataArr[i]).kwbh isEqualToString:_kcslLabel.text]) {
                [_pickerView selectRow:i inComponent:0 animated:YES];
                [_pickerView reloadComponent:0];
            }
        }
    }
    [self.view addSubview:_pickerView];
    
    [UIView animateWithDuration:.3 animations:^{
        
        _pickerView.transform = CGAffineTransformMakeTranslation(0, -150);
        
    } completion:^(BOOL finished) {
        
    }];
}



#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataArr.count;
}
#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return ((InModel *)_dataArr[row]).kwbh;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _kwbhTextField.text = ((InModel *)_dataArr[row]).kwbh;
    _kcslLabel.text = ((InModel *)_dataArr[row]).kcsl;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [UIView animateWithDuration:.3 animations:^{
        
        _pickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 150);
        
    } completion:^(BOOL finished) {
        
        [_pickerView removeFromSuperview];
        _pickerView = nil;
    }];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ((textField.returnKeyType = UIReturnKeyGo)) {
        [_kwbhTextField resignFirstResponder];
        [self requestOutData:_kwbhTextField.text];
    }
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.txmhTextField) {
        
        if (textField.text.length >= 14 && textField.text.length < 16) {
            [self requestOutData:textField.text];
        }else if (textField.text.length >16){
            [SCToastView showInView:self.view text:@"请检查条码号，条码号不能超过15位" duration:1.5 autoHide:YES];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
