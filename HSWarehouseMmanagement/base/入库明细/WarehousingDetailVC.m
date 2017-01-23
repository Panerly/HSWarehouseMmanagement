//
//  WarehousingDetailVC.m
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/19.
//  Copyright © 2017年 HS. All rights reserved.
//

#import "WarehousingDetailVC.h"
#import "WarehousingDetailCell.h"

@interface WarehousingDetailVC ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    UIButton *backBtn;
    WarehousingDetailCell *cell;
}
@end

@implementation WarehousingDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTitleView];
    [self initTableView];
    if ([self.titleName isEqualToString:@"入库明细"]) {
        [self requestData];
        cell.flag = @"0";
    }else{
        [self requestOutData];
        cell.flag = @"1";
    }
    self.dataArr = [NSMutableArray array];
}

- (void)initTitleView {
    
    _titleView = [[TitleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _titleView.title = self.titleName;
    _titleView.isTranslucent = NO;
    _titleView.backgroundColor = COLORRGB(63, 143, 249);
    _titleView.isTranslucent = YES;
    _titleView.isLeftBtnRotation = YES;
    backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backBtn.showsTouchWhenHighlighted = YES;
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    _titleView.leftBarButton = backBtn;
    
    [self.view addSubview:_titleView];
}

- (void)initTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.keyboardDismissMode  = UIScrollViewKeyboardDismissModeOnDrag;
    if ([self.titleName isEqualToString:@"入库明细"]) {
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    }else{
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestOutData)];
    }
    [_tableView registerNib:[UINib nibWithNibName:@"WarehousingDetailCell" bundle:nil] forCellReuseIdentifier:@"WarehousingDetailCellID"];
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    _tableView.delegate     = self;
    _tableView.dataSource   = self;
   
    [self.view addSubview:_tableView];
}

- (void)requestData {
    
    NSString *logInUrl                  = [NSString stringWithFormat:@"%@",rkmxApi];
    
    NSURLSessionConfiguration *config   = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager       = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    manager.requestSerializer.timeoutInterval = 10;
    
    AFHTTPResponseSerializer *serializer    = manager.responseSerializer;
    
    serializer.acceptableContentTypes       = [serializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    __weak typeof(self) weakSelf            = self;
    
    NSURLSessionTask *task =[manager POST:logInUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        if (responseObject) {
            
            [weakSelf.dataArr removeAllObjects];
            
            NSError *error;
            
            for (NSMutableDictionary *dic in responseObject) {
                
                weakSelf.warehousingDetailModel = [[WarehousingDetailModel alloc] initWithDictionary:dic error:&error];
                [weakSelf.dataArr addObject:weakSelf.warehousingDetailModel];
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

- (void)requestOutData {
    
    NSString *logInUrl                  = [NSString stringWithFormat:@"%@",ckmxApi];
    
    NSURLSessionConfiguration *config   = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager       = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    manager.requestSerializer.timeoutInterval = 10;
    
    AFHTTPResponseSerializer *serializer    = manager.responseSerializer;
    
    serializer.acceptableContentTypes       = [serializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    __weak typeof(self) weakSelf            = self;
    
    NSURLSessionTask *task =[manager POST:logInUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        if (responseObject) {
            
            [weakSelf.dataArr removeAllObjects];
            
            NSError *error;
            
            for (NSMutableDictionary *dic in responseObject) {
                
                weakSelf.warehousingDetailModel = [[WarehousingDetailModel alloc] initWithDictionary:dic error:&error];
                [weakSelf.dataArr addObject:weakSelf.warehousingDetailModel];
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

- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 160;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"WarehousingDetailCellID" forIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WarehousingDetailCell" owner:self options:nil] lastObject];
    }
    cell.warehousingDetailModel = self.dataArr[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
