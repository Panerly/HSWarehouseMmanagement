//
//  StockViewController.m
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/18.
//  Copyright © 2017年 HS. All rights reserved.
//

#import "StockViewController.h"
#import "StockTableViewCell.h"
#import "DetailViewController.h"

@interface StockViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    UIButton *backBtn;
}
@end

@implementation StockViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self initTitleView];
    [self initTableView];
    [self requestData];
    self.dataArr = [NSMutableArray array];
}

- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.keyboardDismissMode  = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    _tableView.delegate     = self;
    _tableView.dataSource   = self;
    [_tableView registerNib:[UINib nibWithNibName:@"StockTableViewCell" bundle:nil] forCellReuseIdentifier:@"stockTableViewID"];
    [self.view addSubview:_tableView];
}
- (void)initTitleView {
    
    _titleView = [[TitleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _titleView.isTranslucent = NO;
    _titleView.backgroundColor = COLORRGB(63, 143, 249);
    _titleView.title = @"库存信息";
    _titleView.isTranslucent = YES;
    _titleView.isLeftBtnRotation = YES;
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

- (void)requestData {
    
    NSString *logInUrl                  = [NSString stringWithFormat:@"%@",stockApi];

    NSURLSessionConfiguration *config   = [NSURLSessionConfiguration defaultSessionConfiguration];

    AFHTTPSessionManager *manager       = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    manager.requestSerializer.timeoutInterval= 10;

    AFHTTPResponseSerializer *serializer = manager.responseSerializer;

    serializer.acceptableContentTypes = [serializer.acceptableContentTypes setByAddingObject:@"text/html"];

    __weak typeof(self) weakSelf    = self;
    
    NSURLSessionTask *task =[manager POST:logInUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        [weakSelf.tableView.mj_header endRefreshing];
        if (responseObject) {
            [weakSelf.dataArr removeAllObjects];
            NSError *error;
            for (NSMutableDictionary *dic in responseObject) {
                weakSelf.stockModel = [[StockModel alloc] initWithDictionary:dic error:&error];
                [weakSelf.dataArr addObject:weakSelf.stockModel];
            }
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        [weakSelf.tableView.mj_header endRefreshing];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }];
    [task resume];
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stockTableViewID" forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StockTableViewCell" owner:self options:nil] firstObject];
    }
    cell.stockModel = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    
    RAlertView *alert = [[RAlertView alloc] initWithStyle:CancelAndConfirmAlert];
    alert.theme =[UIColor blueColor];
    alert.isClickBackgroundCloseWindow = NO;
    alert.headerTitleLabel.text = @"是否查看详细信息？";
    alert.contentTextLabel.attributedText = [TextHelper attributedStringForString:[NSString stringWithFormat:@"名       称 :  %@\n库存数量 :  %@\n库存下限 :  %@\n正常库存 :  %@\n分       类 :  %@\n品       牌 :  %@\n计量单位 :  %@\n物料编号 :  %@\n条形码号 :  %@",((StockModel *)self.dataArr[indexPath.row]).name, ((StockModel *)self.dataArr[indexPath.row]).kcsl, ((StockModel *)self.dataArr[indexPath.row]).kcxx, ((StockModel *)self.dataArr[indexPath.row]).zckc, ((StockModel *)self.dataArr[indexPath.row]).fl, ((StockModel *)self.dataArr[indexPath.row]).pinp, ((StockModel *)self.dataArr[indexPath.row]).jldw, ((StockModel *)self.dataArr[indexPath.row]).wlbh, ((StockModel *)self.dataArr[indexPath.row]).txm] lineSpacing:5];
    alert.confirm = ^(){
        NSLog(@"Click on the Ok");
        detailVC.titletext = [NSString stringWithFormat:@"%@",((StockModel *)self.dataArr[indexPath.row]).name];
        detailVC.txmh = ((StockModel *)self.dataArr[indexPath.row]).txm;
        [self presentViewController:detailVC animated:YES completion:^{
            
        }];
    };
    alert.cancel = ^(){
        NSLog(@"Click on the Cancel");
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
