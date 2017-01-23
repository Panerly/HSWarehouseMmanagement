//
//  LoginViewController.m
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/17.
//  Copyright © 2017年 HS. All rights reserved.
//

#import "LoginViewController.h"
#import "LogTextField.h"
#import "MainViewController.h"
#import "HyLoglnButton.h"
#import "HyTransitions.h"

@interface LoginViewController ()<UIViewControllerTransitioningDelegate>
{
    HyLoglnButton *logInButton;
    LogTextField *username;
    LogTextField *password;
    NSString *device;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view.layer addSublayer: [self backgroundLayer]];
    
    //判断机型
    if (kScreenHeight == 736) {
        device = @"6p";
    }
    else if (kScreenHeight == 667) {
        device = @"6";
    }
    else if (kScreenHeight == 568) {
        device = @"5";
    }
    else {
        device = @"4";
    }
    
    //监听键盘弹出的方式
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)popKeyBoard:(NSNotification *)notification
{
    //获取键盘的高度
    NSValue *value  = notification.userInfo[@"UIKeyboardBoundsUserInfoKey"];
    CGRect rect     = [value CGRectValue];
    CGFloat height  = rect.size.height;
    
    // 调整View的高度
    [UIView animateWithDuration:0.25 animations:^{
        
        
        
        if ([device isEqualToString:@"4"]) {
            
        }
        if ([device isEqualToString:@"5"]) {
            //调整布局
            username.transform = CGAffineTransformMakeTranslation(0, kScreenHeight/3.5-height);
            password.transform = CGAffineTransformMakeTranslation(0, kScreenHeight/3.5-height);
            logInButton.frame = CGRectMake(20, CGRectGetHeight(self.view.bounds) - height - 70, kScreenWidth - 40, 40);
            
        }else{
            username.transform = CGAffineTransformMakeTranslation(0, kScreenHeight/2.8-height);
            password.transform = CGAffineTransformMakeTranslation(0, kScreenHeight/2.8-height);
            logInButton.frame = CGRectMake(20, CGRectGetHeight(self.view.bounds) - height - 50, kScreenWidth - 40, 40);
        }
        
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = YES;
    [self setUp];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}
//配置UI
-(void)setUp{
    
    UILabel *titleLabel     = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 50, 25)];
    titleLabel.center       = CGPointMake(self.view.center.x, kScreenHeight/6);
    titleLabel.textColor    = [UIColor whiteColor];
    titleLabel.text         = @"杭水仓库管理系统";
    titleLabel.font         = [UIFont systemFontOfSize:30.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    
    UILabel *detail         = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 90)];
    detail.center           = CGPointMake(self.view.center.x,kScreenHeight-40);
    detail.textColor        = [UIColor whiteColor];
    detail.numberOfLines    = 0;
    detail.text             = @"杭州水表有限公司\n\n服务电话:400-108-1616";
    detail.font             = [UIFont systemFontOfSize:13.f];
    detail.textAlignment    = NSTextAlignmentCenter;
    [self.view addSubview:detail];
    
    username                = [[LogTextField alloc]initWithFrame:CGRectMake(0, 0, 270, 30)];
    username.center         = CGPointMake(self.view.center.x, kScreenHeight/2.5);
    username.ly_placeholder = @"用户名";
    [self.view addSubview:username];
    
    password                = [[LogTextField alloc]initWithFrame:CGRectMake(0, 0, 270, 30)];
    password.center         = CGPointMake(self.view.center.x, username.center.y+60);
    password.ly_placeholder = @"密码";
    [self.view addSubview:password];
    
    
    logInButton         = [[HyLoglnButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 100, 40)];
    logInButton.center  = CGPointMake(self.view.center.x,kScreenHeight - 150);
    
    [logInButton setBackgroundColor:[UIColor colorWithRed:0 green:119/255.0f blue:204.0f/255.0f alpha:1]];
    
    [logInButton setTitle:@"登录" forState:UIControlStateNormal];
    
    [logInButton addTarget:self action:@selector(LoginBtn) forControlEvents:UIControlEventTouchUpInside];
    
    logInButton.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:logInButton];
    
}

- (void)LoginBtn {
    
    
    MainViewController *mainVC      = [[MainViewController alloc] init];
    __weak typeof(self) weakSelf    = self;
    
    [self resignKeyBoardInView:username];
    [self resignKeyBoardInView:password];
    [UIView animateWithDuration:.5 animations:^{
        username.transform  = CGAffineTransformIdentity;
        password.transform  = CGAffineTransformIdentity;
        logInButton.frame   = CGRectMake(0, 0, kScreenWidth - 100, 40);
        logInButton.center  = CGPointMake(self.view.center.x,kScreenHeight - 150);
        
    } completion:^(BOOL finished) {
        
    }];

//#warning forTest
//    [logInButton ExitAnimationCompletion:^{
//        
//        
//        mainVC.transitioningDelegate = self;
//        
//        [weakSelf presentViewController:mainVC animated:NO completion:^{
//            mainVC.modalPresentationStyle = UIModalPresentationPageSheet;
//        }];
//        
//    }];
    
    
    
    if (!username.text) {
        [logInButton ErrorRevertAnimationCompletion:^{
            
        }];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }else{
        if ([username.text isEqualToString:@"管理员"]) {
            
            [logInButton ExitAnimationCompletion:^{
                
                
                mainVC.transitioningDelegate = self;
                
                [weakSelf presentViewController:mainVC animated:NO completion:^{
                    mainVC.modalPresentationStyle = UIModalPresentationPageSheet;
                }];
                
            }];
        }else{
            [logInButton ErrorRevertAnimationCompletion:^{
                
            }];
        }
//        NSString *logInUrl                  = [NSString stringWithFormat:@"%@",logApi];
//        
//        NSURLSessionConfiguration *config   = [NSURLSessionConfiguration defaultSessionConfiguration];
//        
//        AFHTTPSessionManager *manager       = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
//        manager.requestSerializer.timeoutInterval= 10;
//        
//        NSDictionary *parameters = @{
//                                     @"username":username.text,
//                                     @"password":password.text?password.text:@"",
//                                     };
//        
//        AFHTTPResponseSerializer *serializer = manager.responseSerializer;
//        
//        serializer.acceptableContentTypes = [serializer.acceptableContentTypes setByAddingObject:@"text/html"];
//        
//        NSURLSessionTask *task =[manager POST:logInUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
//            
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            
//            if (responseObject) {
//                [logInButton ExitAnimationCompletion:^{
//                    
//                    
//                    mainVC.transitioningDelegate = self;
//                    
//                    [weakSelf presentViewController:mainVC animated:NO completion:^{
//                        mainVC.modalPresentationStyle = UIModalPresentationPageSheet;
//                    }];
//                    
//                }];
//            }
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            
//            
//            [logInButton ErrorRevertAnimationCompletion:^{
//                
//            }];
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                
//            }];
//            [alert addAction:confirm];
//            [self presentViewController:alert animated:YES completion:^{
//                
//            }];
//        }];
//        [task resume];
    }
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self resignKeyBoardInView:username];
    [self resignKeyBoardInView:password];
    [UIView animateWithDuration:.5 animations:^{
        
        username.transform = CGAffineTransformIdentity;
        password.transform = CGAffineTransformIdentity;
        logInButton.frame  = CGRectMake(0, 0, kScreenWidth - 100, 40);
        logInButton.center = CGPointMake(self.view.center.x,kScreenHeight - 150);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)resignKeyBoardInView:(UIView *)view
{
    for (UIView *v in view.subviews) {
        if ([v.subviews count] > 0) {
            [self resignKeyBoardInView:v];
        }
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
            [v resignFirstResponder];
        }
    }
}

-(CAGradientLayer *)backgroundLayer{
    CAGradientLayer *gradientLayer  = [CAGradientLayer layer];
    gradientLayer.frame             = self.view.bounds;
    gradientLayer.colors            = @[(__bridge id)[UIColor purpleColor].CGColor,(__bridge id)[UIColor redColor].CGColor];
    gradientLayer.startPoint        = CGPointMake(0.5, 0);
    gradientLayer.endPoint          = CGPointMake(0.5, 1);
    gradientLayer.locations         = @[@0.65,@1];
    return gradientLayer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
