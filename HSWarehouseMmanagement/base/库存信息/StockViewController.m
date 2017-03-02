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
UITableViewDataSource,
UISearchResultsUpdating,
UISearchBarDelegate
>
{
    UIButton *backBtn;
    UILabel *_refreshLabel;
}
//创建搜索栏
@property (nonatomic, strong) UISearchController *searchController;

@property(nonatomic,retain)NSMutableArray *searchResults;//接收数据源结果

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
    _tableView                      = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.keyboardDismissMode  = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.mj_header            = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    _tableView.delegate     = self;
    _tableView.dataSource   = self;
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLineEtched;
    [_tableView registerNib:[UINib nibWithNibName:@"StockTableViewCell" bundle:nil] forCellReuseIdentifier:@"stockTableViewID"];
    
    //调用初始化searchController
    self.searchController                                       = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.frame                       = CGRectMake(0, 0, 0, 44);
    self.searchController.dimsBackgroundDuringPresentation      = NO;
    self.searchController.hidesNavigationBarDuringPresentation  = YES;
    self.searchController.searchBar.barTintColor                = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.searchController.searchBar.placeholder                 = @"输入名称或条码号进行搜索";
    
    self.searchController.searchBar.delegate    = self;
    self.searchController.searchResultsUpdater  = self;
    //搜索栏表头视图
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar sizeToFit];
    [self.view addSubview:_tableView];
}
- (void)initTitleView {
    
    _titleView                  = [[TitleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _titleView.isTranslucent    = NO;
    _titleView.backgroundColor  = COLORRGB(63, 143, 249);
    _titleView.title            = @"库存信息";
    _titleView.isTranslucent    = YES;
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
    NSString *logInUrl                  = [NSString stringWithFormat:@"%@",stockApi];

    NSURLSessionConfiguration *config   = [NSURLSessionConfiguration defaultSessionConfiguration];

    AFHTTPSessionManager *manager       = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    manager.requestSerializer.timeoutInterval= 10;

    AFHTTPResponseSerializer *serializer = manager.responseSerializer;

    serializer.acceptableContentTypes   = [serializer.acceptableContentTypes setByAddingObject:@"text/html"];

    __weak typeof(self) weakSelf        = self;
    
    NSURLSessionTask *task              = [manager POST:logInUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        [weakSelf.tableView.mj_header endRefreshing];
        [_refreshLabel removeFromSuperview];
        _refreshLabel = nil;
        
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
        [_refreshLabel removeFromSuperview];
        _refreshLabel               = nil;
        UIAlertController *alert    = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm      = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

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
    return (!self.searchController.active)?self.dataArr.count:self.searchResults.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stockTableViewID" forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StockTableViewCell" owner:self options:nil] firstObject];
    }
    cell.stockModel = (!self.searchController.active)?self.dataArr[indexPath.row]:self.searchResults[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    DetailViewController *detailVC  = [[DetailViewController alloc] init];
    
    RAlertView *alert               = [[RAlertView alloc] initWithStyle:CancelAndConfirmAlert];
    alert.theme                     = [UIColor blueColor];
    alert.isClickBackgroundCloseWindow      = NO;
    alert.headerTitleLabel.text             = @"是否查看详细信息？";
    alert.contentTextLabel.attributedText   = [TextHelper attributedStringForString:[NSString stringWithFormat:@"名       称 :  %@\n库存数量 :  %@\n库存下限 :  %@\n正常库存 :  %@\n分       类 :  %@\n品       牌 :  %@\n计量单位 :  %@\n物料编号 :  %@\n条形码号 :  %@",
                                                                                   (!self.searchController.active)?((StockModel *)self.dataArr[indexPath.row]).name:((StockModel *)self.searchResults[indexPath.row]).name,
                                                                                   (!self.searchController.active)?((StockModel *)self.dataArr[indexPath.row]).kcsl:((StockModel *)self.searchResults[indexPath.row]).kcsl,
                                                                                   (!self.searchController.active)?((StockModel *)self.dataArr[indexPath.row]).kcxx:((StockModel *)self.searchResults[indexPath.row]).kcxx,
                                                                                   (!self.searchController.active)?((StockModel *)self.dataArr[indexPath.row]).zckc:((StockModel *)self.searchResults[indexPath.row]).zckc,
                                                                                   (!self.searchController.active)?((StockModel *)self.dataArr[indexPath.row]).fl:((StockModel *)self.searchResults[indexPath.row]).fl,
                                                                                   (!self.searchController.active)?((StockModel *)self.dataArr[indexPath.row]).pinp:((StockModel *)self.searchResults[indexPath.row]).pinp,
                                                                                   (!self.searchController.active)?((StockModel *)self.dataArr[indexPath.row]).jldw:((StockModel *)self.searchResults[indexPath.row]).jldw,
                                                                                   (!self.searchController.active)?((StockModel *)self.dataArr[indexPath.row]).wlbh:((StockModel *)self.searchResults[indexPath.row]).wlbh,
                                                                                   (!self.searchController.active)?((StockModel *)self.dataArr[indexPath.row]).txm:((StockModel *)self.searchResults[indexPath.row]).txm] lineSpacing:5];
    alert.confirm = ^(){
        NSLog(@"Click on the Ok");
        detailVC.titletext  = [NSString stringWithFormat:@"%@",(!self.searchController.active)?((StockModel *)self.dataArr[indexPath.row]).name:((StockModel *)self.searchResults[indexPath.row]).name];
        detailVC.txmh       = (!self.searchController.active)?((StockModel *)self.dataArr[indexPath.row]).txm:((StockModel *)self.searchResults[indexPath.row]).txm;
        if (self.searchController.active) {
            
            self.searchController.active = NO;
            [self.searchController.searchBar removeFromSuperview];
        }
        [self presentViewController:detailVC animated:YES completion:^{
            
        }];
    };
    alert.cancel = ^(){
        NSLog(@"Click on the Cancel");
    };
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
    
    for (StockModel *stockModel in self.dataArr) {
        
        [arr addObject:stockModel.name];
        [arr addObject:stockModel.txm];
    }
    arr2 = [[arr filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    for (StockModel *stockModel in self.dataArr) {
        
        if ([arr2 containsObject:stockModel.name]||[arr2 containsObject:stockModel.txm]) {
            
            [self.searchResults addObject:stockModel];
        }
    }
    //刷新表格
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
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

@end
