//
//  MainViewController.h
//  HSWarehouseMmanagement
//
//  Created by HS on 2017/1/17.
//  Copyright © 2017年 HS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainVCModel.h"

@interface MainViewController : UIViewController

@property (nonatomic, strong) TitleView *titleView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGSize estimatedItemSize NS_AVAILABLE_IOS(8_0); // defaults to CGSizeZero - setting a non-zero size enables cells that self-size via -preferredLayoutAttributesFittingAttributes:
@property (nonatomic) UICollectionViewScrollDirection scrollDirection; // default is UICollectionViewScrollDirectionVertical
@property (nonatomic) CGSize headerReferenceSize;
@property (nonatomic) CGSize footerReferenceSize;
@property (nonatomic) UIEdgeInsets sectionInset;


@property (nonatomic, strong) NSArray *arr_icon;
@property (nonatomic, strong) NSArray *arr_title;
@property (nonatomic, strong) MainVCModel *MainModel;

@end
