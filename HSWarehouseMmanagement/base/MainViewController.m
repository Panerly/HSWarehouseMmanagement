//
//  MainViewController.m
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/17.
//  Copyright © 2017年 HS. All rights reserved.
//

#import "MainViewController.h"
#import "FourPingTransition.h"
#import "MainCollectionViewCell.h"
#import "StockViewController.h"
#import "WarehousingDetailVC.h"
#import "InViewController.h"

@interface MainViewController ()
<
UIViewControllerTransitioningDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource
>

{
    UIButton *setBtn;
}
@end

@implementation MainViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        [self initTitleView];
    }
    return self;
}

- (void)initTitleView {
    
    _titleView = [[TitleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _titleView.isTranslucent = NO;
    _titleView.backgroundColor = COLORRGB(63, 143, 249);
    _titleView.title = @"仓库管理";
    _titleView.isTranslucent = YES;
    _titleView.isLeftBtnRotation = YES;
    setBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [setBtn setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
    setBtn.showsTouchWhenHighlighted = YES;
    [setBtn addTarget:self action:@selector(openSetPage:) forControlEvents:UIControlEventTouchUpInside];
    _titleView.rightBarButton = setBtn;

    [self.view addSubview:_titleView];
}

- (void)openSetPage :(UIButton *)sender {

    [FTPopOverMenu showForSender:sender withMenuArray:@[@"更新库存",@"更新货品",@"添加货品",@"注销用户"] imageArray:@[@"warehouse",@"refresh",@"add",@"logout"] doneBlock:^(NSInteger selectedIndex) {
        
        switch (selectedIndex) {
            case 0:
                
                break;
            case 1:
                
                break;
            case 2:
                
                break;
            case 3:
                [self dismissViewControllerAnimated:YES completion:nil];
                break;
                
            default:
                break;
        }
    } dismissBlock:^{
        
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic1.jpg"]];
    imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:imageView];
      */
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.arr_icon = @[@"库存",@"入库",@"出库",@"明细",@"明细",@"同步",@"换位"];
    [self initCollectionView];
    self.arr_title = @[@"库存信息",@"入库",@"出库",@"入库明细",@"出库明细",@"同步",@"换位"];
    for (int i = 0; i < _arr_title.count; i++) {
        self.MainModel.title = self.arr_title[i];
        self.MainModel.image = self.arr_icon[i];
    }
    [self.collectionView reloadData];
}

- (void)initCollectionView {
    
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    // 定义大小
    self.layout.itemSize = CGSizeMake(kScreenWidth/3.5, kScreenWidth/3);
    // 设置最小行间距
    self.layout.minimumLineSpacing = 2;
    // 设置垂直间距
    self.layout.minimumInteritemSpacing = 2;
    // 设置滚动方向（默认垂直滚动）
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) collectionViewLayout:self.layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MainCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"collectionCellID"];
    [self.view addSubview:self.collectionView];
    
}



-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [FourPingTransition transitionWithTransitionType:XWPresentOneTransitionTypePresent];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [FourPingTransition transitionWithTransitionType:XWPresentOneTransitionTypeDismiss];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arr_title.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCellID" forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MainCollectionViewCell" owner:self options:nil] lastObject];
    }
    cell.title.text = self.arr_title[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.arr_icon[indexPath.row]]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    StockViewController *stockViewVC = [[StockViewController alloc] init];
    WarehousingDetailVC *wareHouseingDetailVC = [[WarehousingDetailVC alloc] init];
    InViewController *inVC = [[InViewController alloc] init];
    switch (indexPath.row) {
        case 0:

            [self presentViewController:stockViewVC animated:YES completion:^{
                
            }];
            break;
        case 1:
            inVC.titleName = @"入库";
            [self presentViewController:inVC animated:YES completion:^{
                
            }];
            break;
        case 2:
            inVC.titleName = @"出库";
            [self presentViewController:inVC animated:YES completion:^{
                
            }];
            break;
        case 3:
            wareHouseingDetailVC.titleName = @"入库明细";
            [self presentViewController:wareHouseingDetailVC animated:YES completion:^{
                
            }];
            break;
        case 4:
            wareHouseingDetailVC.titleName = @"出库明细";
            [self presentViewController:wareHouseingDetailVC animated:YES completion:^{
                
            }];
            break;
        case 5:
            
            break;
        case 6:
            
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
