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
UITableViewDataSource,
UISearchResultsUpdating,
UISearchBarDelegate
>
{
    UIButton *backBtn;
    WarehousingDetailCell *cell;
    UILabel *_refreshLabel;
}


//创建搜索栏
@property (nonatomic, strong) UISearchController *searchController;

@property(nonatomic,retain)NSMutableArray *searchResults;//接收数据源结果

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

//创建tableview&搜索栏
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
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLineEtched;
    _tableView.keyboardDismissMode                  = UIScrollViewKeyboardDismissModeOnDrag;
    
    //调用初始化searchController
    self.searchController                                       = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.frame                       = CGRectMake(0, 0, 0, 44);
    self.searchController.dimsBackgroundDuringPresentation      = NO;
    self.searchController.hidesNavigationBarDuringPresentation  = YES;
    self.searchController.searchBar.barTintColor                = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.searchController.searchBar.placeholder                 = @"输入名称或编号进行搜索";
    
    self.searchController.searchBar.delegate    = self;
    self.searchController.searchResultsUpdater  = self;
    //搜索栏表头视图
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar sizeToFit];
   
    [self.view addSubview:_tableView];
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

//请求入库数据
- (void)requestData {
    
    if (!self.tableView.mj_header.isRefreshing && !_refreshLabel) {
        _refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _refreshLabel.text = @"正在加载中...";
        [self.view addSubview:_refreshLabel];
        [self addshimmeringView:_refreshLabel];
        
    }else if (self.tableView.mj_header.isRefreshing && _refreshLabel){
        [_refreshLabel removeFromSuperview];
        _refreshLabel = nil;
    }
    
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
        [_refreshLabel removeFromSuperview];
        _refreshLabel = nil;
        
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
//请求出库数据
- (void)requestOutData {
    
    if (!self.tableView.mj_header.isRefreshing && !_refreshLabel) {
        _refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _refreshLabel.text = @"正在加载中...";
        [self.view addSubview:_refreshLabel];
        [self addshimmeringView:_refreshLabel];
        
    }else if (self.tableView.mj_header.isRefreshing && _refreshLabel){
        [_refreshLabel removeFromSuperview];
        _refreshLabel = nil;
    }
    
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
        [_refreshLabel removeFromSuperview];
        _refreshLabel = nil;
        
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

- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return (!self.searchController.active)?self.dataArr.count : self.searchResults.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 170;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"WarehousingDetailCellID" forIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WarehousingDetailCell" owner:self options:nil] lastObject];
    }
    cell.warehousingDetailModel = (!self.searchController.active)?_dataArr[indexPath.row] : self.searchResults[indexPath.row];
    return cell;
}
#pragma mark - searchController delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    self.searchResults= [NSMutableArray array];
    [self.searchResults removeAllObjects];
    
    //NSPredicate 谓词
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchController.searchBar.text];
    
    NSMutableArray *arr     = [NSMutableArray array];
    NSMutableArray *arr2    = [NSMutableArray array];
    [arr2 removeAllObjects];
    
    for (WarehousingDetailModel *detailModel in self.dataArr) {
        
        [arr addObject:detailModel.bh];
        [arr addObject:detailModel.name];
    }
    arr2 = [[arr filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    for (WarehousingDetailModel *detailModel in self.dataArr) {
        
        if ([arr2 containsObject:detailModel.bh]||[arr2 containsObject:detailModel.name]) {
            
            [self.searchResults addObject:detailModel];
        }
    }
    //刷新表格
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//移除搜索栏
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.searchController.active) {
        
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
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
