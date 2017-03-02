//
//  ChangePositionVC.m
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/2/10.
//  Copyright © 2017年 HS. All rights reserved.
//

#import "ChangePositionVC.h"
#import "SJViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "InModel.h"

@interface ChangePositionVC ()<UITextFieldDelegate>
{
    UIButton *backBtn;
    UILabel *_refreshLabel;
}
@end

@implementation ChangePositionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initTitleView];
    //监听键盘弹出的方式
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    
    self.QRCodeNumberTextField.delegate = self;
    self.stockNumberTextField.delegate  = self;
    self.latestPositon.delegate         = self;
    self.QRCodeNumberTextField.returnKeyType    = UIReturnKeyNext;
    self.stockNumberTextField.returnKeyType     = UIReturnKeyContinue;
    self.latestPositon.returnKeyType            = UIReturnKeyDone;
    
    [self.QRCodeNumberTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.dataArr = [NSMutableArray array];
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.QRCodeNumberTextField) {
        
        if (textField.text.length >= 14 && textField.text.length < 16) {
            [self requestPositionData:textField.text];
        }else if (textField.text.length >16){
            [SCToastView showInView:self.view text:@"请检查条码号，条码号不能超过15位" duration:1.5 autoHide:YES];
        }
    }
}

- (void)initTitleView {
    
    _titleView                      = [[TitleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _titleView.title                = self.titleName;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBtn:(id)sender {
    
    [self.latestPositon resignFirstResponder];
    [self.stockNumberTextField resignFirstResponder];
    [self.QRCodeNumberTextField resignFirstResponder];
    
    [UIView animateWithDuration:.25 animations:^{
        
        _editView.transform   = CGAffineTransformIdentity;
        _cancelBtn.transform  = CGAffineTransformIdentity;
        _confirmBtn.transform = CGAffineTransformIdentity;
    }];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


//确定换位
- (IBAction)confirmBtn:(id)sender {
    
    NSString *logInUrl                  = [NSString stringWithFormat:@"%@",changePositonApi];
    
    NSURLSessionConfiguration *config   = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager       = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    manager.requestSerializer.timeoutInterval = 10;
    
    AFHTTPResponseSerializer *serializer    = manager.responseSerializer;
    
    serializer.acceptableContentTypes       = [serializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    __weak typeof(self) weakSelf            = self;
    
    NSDictionary *para = @{
                           @"kwbh":_positonNumberLabel.text,
                           @"txm":_QRCodeNumberTextField.text,
                           @"kwbhnew":_latestPositon.text,
                           @"kcsl":_stockNumberTextField.text,
                           @"PhoneVersion":@"iOS"
                           };
    
    NSURLSessionTask *task =[manager POST:logInUrl parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [weakSelf.dataArr removeAllObjects];
        
        if (responseObject) {
            
            NSError *error;
            
            if ([[responseObject objectAtIndex:0] isEqualToString:@"1"]) {
                [SCToastView showInView:self.view text:@"上传成功" duration:1 autoHide:YES];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"上传失败" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:confirm];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
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
    [task resume];}

- (IBAction)scanQRCode:(id)sender {
    
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
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"扫描出错，请重新扫描！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:action];
            [self presentViewController:alertVC animated:YES completion:^{
                
            }];
        }else{
            self.QRCodeNumberTextField.text = successString;
            [self requestPositionData:successString];
        }
    };
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)scanNewPositionBtn:(id)sender {
    
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
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"无此条码，请重新扫描或检查" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:action];
            [self presentViewController:alertVC animated:YES completion:^{
                
            }];
        }else{
            
            self.latestPositon.text = successString;
        }
    };
    
    [self presentViewController:viewController animated:YES completion:nil];
}


- (IBAction)selectBtn:(id)sender {
    
    __weak typeof(self) weekSelf = self;
    NSMutableArray *kwbhArr = [NSMutableArray array];
    NSMutableArray *kcslArr = [NSMutableArray array];
    for (int i = 0; i < _dataArr.count; i++) {
        [kwbhArr addObject:((InModel *)self.dataArr[i]).kwbh];
        [kcslArr addObject:((InModel *)self.dataArr[i]).kcsl];
    }
    [FTPopOverMenu showForSender:sender withMenuArray:kwbhArr imageArray:nil doneBlock:^(NSInteger selectedIndex) {
        
        weekSelf.positonNumberLabel.text    = kwbhArr[selectedIndex];
        weekSelf.stockNumberTextField.text  = kcslArr[selectedIndex];
        
    } dismissBlock:^{
        
    }];
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
//扫描获取库位编号
- (void)requestPositionData :(NSString *)txmh{
    
    if (!_refreshLabel) {
        
        _refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _refreshLabel.text = @"正在加载中...";
        [self.view addSubview:_refreshLabel];
        [self addshimmeringView:_refreshLabel];
    }
    [_QRCodeNumberTextField resignFirstResponder];
    
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
        
        [weakSelf.dataArr removeAllObjects];
        
        if (responseObject) {
            
            NSError *error;
            
            for (NSDictionary *dic in responseObject) {
                
                if ([[dic objectForKey:@"kcsl"] intValue] != 0) {
                    
                    InModel *inModel = [[InModel alloc] initWithDictionary:dic error:&error];
                    [weakSelf.dataArr addObject:inModel];
                }
            }
            if (weakSelf.dataArr.count>0) {
                
                weakSelf.positonNumberLabel.text    = ((InModel *)weakSelf.dataArr[0]).kwbh;
                weakSelf.stockNumberTextField.text  = ((InModel *)weakSelf.dataArr[0]).kcsl;
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



- (void)popKeyBoard:(NSNotification *)notification
{
    //获取键盘的高度
    NSValue *value  = notification.userInfo[@"UIKeyboardBoundsUserInfoKey"];
    CGRect rect     = [value CGRectValue];
    CGFloat height  = rect.size.height;
    
    // 调整View的高度
    [UIView animateWithDuration:0.25 animations:^{
        
        //调整布局
        if (148-40>kScreenHeight-height) {
            
            _editView.transform = CGAffineTransformMakeTranslation(0, kScreenHeight-height-148-40);
        }else{
//            _editView.transform = CGAffineTransformMakeTranslation(0, kScreenHeight-height-148-40);
        }
        self.cancelBtn.transform    = CGAffineTransformMakeTranslation(0, -height);
        self.confirmBtn.transform   = CGAffineTransformMakeTranslation(0, -height);
    }];
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.latestPositon resignFirstResponder];
    [self.stockNumberTextField resignFirstResponder];
    [self.QRCodeNumberTextField resignFirstResponder];
    // 调整View的高度
    [UIView animateWithDuration:0.25 animations:^{
        
        //调整布局
        _editView.transform         = CGAffineTransformIdentity;
        self.cancelBtn.transform    = CGAffineTransformIdentity;
        self.confirmBtn.transform   = CGAffineTransformIdentity;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyNext) {
        [_QRCodeNumberTextField resignFirstResponder];
        [_stockNumberTextField becomeFirstResponder];
    } else if (textField.returnKeyType == UIReturnKeyContinue) {
        [_stockNumberTextField resignFirstResponder];
        [_latestPositon becomeFirstResponder];
    }
    if (textField.returnKeyType == UIReturnKeyDone) {
        //用户结束输入
        [_latestPositon resignFirstResponder];

        [UIView animateWithDuration:.25 animations:^{
            
            _editView.transform   = CGAffineTransformIdentity;
            _cancelBtn.transform  = CGAffineTransformIdentity;
            _confirmBtn.transform = CGAffineTransformIdentity;
        }];
    }
    
    return YES;
}
@end
