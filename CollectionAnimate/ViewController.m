//
//  ViewController.m
//  CollectionAnimate
//
//  Created by zmz on 16/8/29.
//  Copyright © 2016年 tentinet. All rights reserved.
//

#import "ViewController.h"
#import "CollectionAnimateFlowOut.h"
#import "UIView+MZwebCache.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    CollectionAnimateFlowOut *flowOut = [[CollectionAnimateFlowOut alloc] init];
    flowOut.style = 0;
    
    self.collectionView =
    [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 40)
                       collectionViewLayout:flowOut];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    [self.view addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"MainCell" bundle:nil]
      forCellWithReuseIdentifier:@"MainCell"];
    
    //seg
    UISegmentedControl *segment = [[UISegmentedControl alloc]
                                   initWithItems:@[ @"缩放", @"倾斜", @"旋转", @"翻转" ]];
    segment.frame = CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40);
    segment.selectedSegmentIndex = 0;
    [self.view addSubview:segment];
    [segment addTarget:self
                action:@selector(changeStyle:)
      forControlEvents:UIControlEventValueChanged];

    //
    [self prepareData];
}

- (void)prepareData {
    NSArray *imgArray = @[     //去百度随便贴了点图
                           @"http://f.hiphotos.baidu.com/image/w%3D230/sign=0c9aab1334d3d539c13d08c00a86e927/2e2eb9389b504fc210123be8e7dde71191ef6d8a.jpg",
                           @"http://b.hiphotos.baidu.com/image/w%3D230/sign=3d85e1028fb1cb133e693b10ed5556da/4610b912c8fcc3cecad043de9045d688d53f20ce.jpg",
                           @"http://b.hiphotos.baidu.com/image/w%3D230/sign=95bc4fc238292df597c3ab168c305ce2/71cf3bc79f3df8dcd052057ccf11728b461028eb.jpg",
                           @"http://d.hiphotos.baidu.com/image/w%3D230/sign=0ad1d51334d3d539c13d08c00a86e927/2e2eb9389b504fc2165945e8e7dde71191ef6ddd.jpg",
                           @"http://b.hiphotos.baidu.com/image/w%3D230/sign=2aa64056a41ea8d38a227307a70b30cf/38dbb6fd5266d016107869c5952bd40734fa35fd.jpg",
                           
                           @"http://f.hiphotos.baidu.com/image/w%3D230/sign=847d16318813632715edc530a18ea056/2934349b033b5bb55c48aa1334d3d539b700bc44.jpg",
                           @"http://b.hiphotos.baidu.com/image/w%3D230/sign=ca80bc927af0f736d8fe4b023a57b382/6f061d950a7b02081a10b50c60d9f2d3562cc806.jpg",
                           @"http://a.hiphotos.baidu.com/image/w%3D230/sign=494c2900a344ad342ebf8084e0a30c08/f11f3a292df5e0fe414a02ec5e6034a85fdf7289.jpg",
                           @"http://d.hiphotos.baidu.com/image/w%3D310/sign=38b94db9a41ea8d38a227205a70a30cf/80cb39dbb6fd5266db55c616a918972bd40736b1.jpg",
                           @"http://f.hiphotos.baidu.com/image/pic/item/c995d143ad4bd113d69bc42a58afa40f4bfb0557.jpg"];
    self.dataArray = [NSMutableArray arrayWithArray:imgArray];
    [_collectionView setContentOffset:CGPointMake(SCREEN_WIDTH * _dataArray.count, 0)];
}

//更改列数
- (void)changeStyle:(UISegmentedControl *)segment {
    ((CollectionAnimateFlowOut *)_collectionView.collectionViewLayout).style = segment.selectedSegmentIndex;
}

#pragma mark - UICollectionView DataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count * 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainCell *cell = (MainCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MainCell" forIndexPath:indexPath];
    cell.URL = _dataArray[indexPath.item%_dataArray.count];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {       //无限循环的实现（做三倍列表数据，一直显示第二倍部分）
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = (offsetX + SCREEN_WIDTH/2)/_collectionView.frame.size.width;
    if (index < _dataArray.count) {
        [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * (index + _dataArray.count), 0) animated:NO];
    }
    else if (index >= _dataArray.count * 2) {
        [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * (index - _dataArray.count), 0) animated:NO];
    }
}

@end

@implementation MainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mainImgv.layer.cornerRadius = 8;
    self.mainImgv.layer.masksToBounds = YES;
}

- (void)setURL:(NSString *)URL {
    _URL = [URL copy];
    [_mainImgv setImageWithUrl:[NSURL URLWithString:_URL] placeHolder:[UIImage imageNamed:@"loading.jpg"]];
}

@end
